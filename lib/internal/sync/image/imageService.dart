import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:crypto/crypto.dart';
import 'package:image/image.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image_controller.dart';
import 'package:potato_notes/internal/utils.dart';

class ImageService {
  static final int jpegQuality = 90;
  static final int maxHeight = 2048;
  List<String> currentDownloads = List();

  Future<String> downloadImage(SavedImage savedImage) async {
    if (!this.currentDownloads.contains(savedImage.hash)) {
      this.currentDownloads.add(savedImage.hash);
      String url =
          await ImageController.getDownloadUrlFromSync(savedImage.hash);
      String path = await ImageController.downloadImageToCache(url, savedImage);
      this.currentDownloads.remove(savedImage.hash);
      return path;
    } else {
      return "";
    }
  }

  static Future<bool> handleUploads(List<Note> changedNotes) async {
    List<Note> imageChanged = changedNotes
        .where((note) =>
            note.images.data
                .indexWhere((savedImage) => !savedImage.encrypted) !=
            -1)
        .toList();
    for (Note note in imageChanged) {
      for (SavedImage savedImage in note.images.data) {
        if (savedImage.uploaded) continue;
        await uploadImage(savedImage);
        savedImage.uploaded = true;
      }
      helper.saveNote(Utils.markNoteChanged(note));
    }
    return true;
    //uploadImage(uri, savedImage);
    //return true if no error
  }

  static Future<void> ensureImageExists(List<SavedImage> images) async {
    for (SavedImage savedImage in images) {
      await imageService.downloadImage(savedImage);
    }
  }

  static bool imageCached(SavedImage savedImage) {
    return File(savedImage.getPath()).existsSync();
  }

  static Future<void> uploadImage(SavedImage savedImage) async {
    //get normal image
    File normalImage =
        File("${appInfo.tempDirectory.path}/${savedImage.hash}.jpg");
    switch (savedImage.storageLocation) {
      case StorageLocation.LOCAL:
        // TODO: Handle this case.
        break;
      case StorageLocation.IMGUR:
        // TODO: Handle this case.
        break;
      case StorageLocation.SYNC:
        await ImageController.uploadImageToSync(savedImage.hash, normalImage);
        break;
    }
  }

  static Future<SavedImage> loadLocalFile(File file) async {
    SavedImage savedImage = SavedImage.empty();
    Uint8List rawBytes = await file.readAsBytes();
    savedImage.hash = await _generateImageHash(rawBytes);
    Image compressedImage = await _compressImage(rawBytes, savedImage);
    String blurHash = _generateBlurHash(compressedImage);
    savedImage.blurHash = blurHash;
    File imageFile = await _saveImage(compressedImage, savedImage);
    savedImage.uri = imageFile.uri;
    return savedImage;
  }

  static Future<String> _generateImageHash(Uint8List rawBytes) async {
    String imageData = rawBytes.toString();
    List<int> bytes = utf8.encode(imageData);
    String digest = sha256.convert(bytes).toString();
    return digest;
  }

  static String _generateBlurHash(Image image) {
    String hash = encodeBlurHash(
        image.getBytes(format: Format.rgba), image.width, image.height);
    return hash;
  }

  static Future<Image> _compressImage(
      Uint8List rawBytes, SavedImage savedImage) async {
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

  static Future<File> _saveImage(Image image, SavedImage savedImage) async {
    File imageFile = File(savedImage.getPath());
    await imageFile.writeAsBytes(encodeJpg(image, quality: jpegQuality));
    return imageFile;
  }
}
