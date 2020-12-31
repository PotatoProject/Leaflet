import 'dart:io';
import 'dart:typed_data';

import 'package:blake2/blake2.dart';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image_queue.dart';

class ImageHelper {
  static const JPEG_QUALITY = 90;
  static const maxHeight = 2048;

  /*static Future<void> downloadImage(SavedImage savedImage) async {
    switch (savedImage.storageLocation) {
      case StorageLocation.LOCAL:
        break;
      case StorageLocation.IMGUR:
        String url = savedImage.uri.toString();
        await downloadImageToCache(url, savedImage, savedImage.path);
        break;
      case StorageLocation.SYNC:
        String url =
            await FilesController.getDownloadUrlFromSync(savedImage.hash!);
        await downloadImageToCache(url, savedImage, savedImage.path);
        break;
    }
    return;
  }*/

  /*static Future<void> downloadImageToCache(
      String url, SavedImage image, String path) async {
    Response response = await http.get(url);
    Loggy.v(
        message:
            "(${image.hash} downloadImage) Server responded with (${response.statusCode}): ${response.contentLength}");
    if (response.statusCode == 200) {
      File file = new File(path);
      await file.create();
      file.writeAsBytesSync(response.bodyBytes);
      return;
    } else if (response.statusCode == 404) {
      throw ("File doesnt exist on server");
    } else if (response.statusCode == 403) {
      throw ("Not allowed to access file");
    }
    return;
  }*/

  static Future<void> handleDownloads(List<Note> changedNotes) async {
    ImageQueue.downloadQueue.clear();
    for (Note note in changedNotes) {
      if (note.images.length > 0) {
        for (SavedImage image in note.images) {
          print(image.existsLocally);
          if (!image.existsLocally) {
            ImageQueue.addDownload(image, note.id);
            //downloadImage(image);
          }
        }
      }
    }
    print(ImageQueue.downloadQueue.length);
    await ImageQueue.processDownloads();
  }

  static Future<SavedImage> copyToCache(File file) async {
    SavedImage savedImage = SavedImage.empty();
    String path =
        appInfo.tempDirectory.path + "/" + savedImage.id + extension(file.path);
    file.copy(path);
    savedImage.uri = Uri.file(path);
    return savedImage;
  }

  static String generateImageHash(Uint8List rawBytes) {
    var blake2b = Blake2b();
    blake2b.update(rawBytes);
    var rawDigest = blake2b.digest();
    return rawDigest.map((int) => int.toRadixString(16)).join('');
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

  static handleNoteDeletion(Note note) {
    for (SavedImage image in note.images) {
      ImageQueue.addDelete(image);
    }
  }
}
