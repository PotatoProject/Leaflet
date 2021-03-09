import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

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
import 'package:potato_notes/internal/sync/image/blake/stub.dart';

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
    final SavedImage savedImage = SavedImage.empty();
    final String path =
        join(appInfo.tempDirectory.path, savedImage.id + extension(file.path));
    file.copy(path);
    final Size _size = getImageSize(file);
    savedImage.width = _size.width.toDouble();
    savedImage.height = _size.height.toDouble();
    savedImage.fileExtension = extension(file.path);

    return savedImage;
  }

  static String generateImageHash(Uint8List rawBytes) {
    final Blake2 blake2b = Blake2();
    blake2b.update(rawBytes);
    final Uint8List rawDigest = blake2b.digest();
    final String hash =
        rawDigest.map((int) => int.toRadixString(16).toString()).join('');
    print(hash);
    return hash;
  }

  static Size getImageSize(File file) {
    return ImageSizeGetter.getSize(FileInput(file));
  }

  static String generateBlurHash(Image image) {
    final String hash = BlurHash.encode(image).hash;
    return hash;
  }

  static Image compressImage(Uint8List rawBytes) {
    final Image image = decodeImage(rawBytes);
    // Default height of compressed images
    final int height = maxHeight;
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
    final int height = 100;
    Image resized;
    // Ensure we dont enlarge the picture since the resize algorithm makes it look ugly then
    if (image.height > height) {
      resized = copyResize(image, height: height);
    } else {
      resized = image;
    }
    return resized;
  }

  static File saveImage(Image image, String path) {
    final File imageFile = File(path);
    imageFile.writeAsBytesSync(encodeJpg(image, quality: JPEG_QUALITY));
    return imageFile;
  }

  static DownloadQueueItem getDownloadItem(SavedImage savedimage) {
    final int index = imageQueue.downloadQueue
        .indexWhere((e) => e.savedImage.id == savedimage.id);
    if (index == -1) {
      return null;
    } else {
      return imageQueue.downloadQueue[index];
    }
  }

  static Future<String> getAvatar(String token) async {
    final String url = "${prefs.getFromCache("api_url")}/files/get/avatar.jpg";
    Loggy.v(message: "Going to send GET to :" + url);
    final Response presign = await dio.get(
      url,
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    Loggy.v(
      message: "Server responded with (${presign.statusCode}): ${presign.data}",
    );
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

  static String processImage(String jsonParameters) {
    Map<String, dynamic> parameters = json.decode(jsonParameters);
    Map<String, String> data = Map();
    final Uint8List rawBytes = File(parameters["original"]).readAsBytesSync();
    print("Hashing image");
    data["hash"] = ImageHelper.generateImageHash(rawBytes);
    print("Resizing image");
    final Image compressedImage = ImageHelper.compressImage(rawBytes);
    data["width"] = compressedImage.width.toString();
    data["height"] = compressedImage.height.toString();
    print("generating blurhash");
    final String blurHash = ImageHelper.generateBlurHash(
        ImageHelper.compressForBlur(compressedImage));
    data["blurhash"] = blurHash;
    print("Saving image");
    ImageHelper.saveImage(
        compressedImage, parameters["tempDirectory"] + "/${data["hash"]}.jpg");
    return jsonEncode(data);
  }
}
