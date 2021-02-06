import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:blake2/blake2.dart';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:dio/dio.dart';
import 'package:image/image.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:loggy/loggy.dart';
import 'package:path/path.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';

import 'download_queue_item.dart';

class ImageHelper {
  static const JPEG_QUALITY = 90;
  static const maxHeight = 2048;

  static Future<void> handleDownloads(List<Note> changedNotes) async {
    imageQueue.downloadQueue.clear();
    for (Note note in changedNotes) {
      if (note.images.length > 0) {
        for (SavedImage image in note.images) {
          if (!image.existsLocally) {
            imageQueue.addDownload(image, note.id);
          }
        }
      }
    }
    await imageQueue.processDownloads();
  }

  static Future<SavedImage> copyToCache(File file) async {
    SavedImage savedImage = SavedImage.empty();
    String path =
        join(appInfo.tempDirectory.path, savedImage.id + extension(file.path));
    file.copy(path);
    final _size = getImageSize(file);
    savedImage.width = _size.width.toDouble();
    savedImage.height = _size.height.toDouble();
    savedImage.fileExtension = extension(file.path);

    return savedImage;
  }

  static String generateImageHash(Uint8List rawBytes) {
    var blake2b = Blake2b();
    blake2b.update(rawBytes);
    var rawDigest = blake2b.digest();
    var hash =
        rawDigest.map((int) => int.toRadixString(16).toString()).join('');
    print(hash);
    return hash;
  }

  static Size getImageSize(File file) {
    return ImageSizeGetter.getSize(FileInput(file));
  }

  static String generateBlurHash(Image image) {
    String hash = encodeBlurHash(
        image.getBytes(format: Format.rgba), image.width, image.height);
    return hash;
  }

  static Image compressImage(Uint8List rawBytes) {
    Image image = decodeImage(rawBytes);
    // Default height of compressed images
    int height = maxHeight;
    Image resized;
    // Ensure we dont enlarge the picture since the resize algorithm makes it look ugly then
    if (image.height > height) {
      resized = copyResize(image, height: height);
    } else {
      resized = image;
    }
    return resized;
  }

  static Image compressForBlur(Image image) {
    // Default height of compressed images
    int height = 100;
    Image resized;
    // Ensure we dont enlarge the picture since the resize algorithm makes it look ugly then
    if (image.height > height) {
      resized = copyResize(image, height: height);
    } else {
      resized = image;
    }
    return resized;
  }

  static Future<File> saveImage(Image image, String path) async {
    File imageFile = File(path);
    await imageFile.writeAsBytes(encodeJpg(image, quality: JPEG_QUALITY));
    return imageFile;
  }

  static DownloadQueueItem getDownloadItem(SavedImage savedimage) {
    var index = imageQueue.downloadQueue
        .indexWhere((e) => e.savedImage.id == savedimage.id);
    if (index == -1) {
      return null;
    } else {
      return imageQueue.downloadQueue[index];
    }
  }

  static Future<String> getAvatar() async {
    String token = await prefs.getToken();
    var url = "${prefs.apiUrl}/files/get/avatar.jpg";
    Loggy.v(message: "Going to send GET to :" + url);
    Response presign = await dio.get(url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ));
    Loggy.v(
        message:
            "Server responded with (${presign.statusCode}): ${presign.data}");
    if (presign.statusCode != 200) {
      return null;
    } else {
      return presign.data;
    }
  }

  static handleNoteDeletion(Note note) {
    for (SavedImage image in note.images) {
      imageQueue.addDelete(image);
    }
  }
}
