import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart';
import 'package:image/image.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/imgur_controller.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:http/http.dart' as http;

import 'files_controller.dart';

class ImageService {
  static const JPEG_QUALITY = 90;
  static const maxHeight = 2048;

  static Future<void> downloadImage(SavedImage savedImage) async {
    switch (savedImage.storageLocation) {
      case StorageLocation.LOCAL:
        break;
      case StorageLocation.IMGUR:
        String url = savedImage.uri.toString();
        await downloadImageToCache(url, savedImage);
        addToDownloaded(savedImage.hash!);
        break;
      case StorageLocation.SYNC:
        String url =
            await FilesController.getDownloadUrlFromSync(savedImage.hash!);
        await downloadImageToCache(url, savedImage);
        addToDownloaded(savedImage.hash!);
        break;
    }
    return;
  }

  static Future<void> downloadImageToCache(
      String url, SavedImage savedImage) async {
    var path = savedImage.path;
    Response response = await http.get(url);
    Loggy.v(
        message:
            "(${savedImage.hash} downloadImage) Server responded with (${response.statusCode}): ${response.contentLength}");
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
  }

  static Future<void> handleDownloads(List<Note> changedNotes) async {
    for (Note note in changedNotes) {
      if (note.images.length > 0) {
        for (SavedImage image in note.images) {
          if (!image.existsLocally) {
            downloadImage(image);
          }
        }
      }
    }
  }

  static Future<bool> handleUploads(List<Note> changedNotes) async {
    List<Note> imageChanged = changedNotes
        .where((note) =>
            note.images.indexWhere((savedImage) => !savedImage.encrypted) != -1)
        .toList();
    for (Note note in imageChanged) {
      for (SavedImage savedImage in note.images) {
        if (savedImage.uploaded) continue;
        await uploadImage(savedImage);
        savedImage.uploaded = true;
      }
      helper.saveNote(note.markChanged());
    }
    return true;
  }

  static void handleUpload(Note note) {
    for (SavedImage image in note.images) {
      if (image.existsLocally && !image.uploaded) {
        uploadImage(image).then((_) {
          image.uploaded = true;
          helper.saveNote(note.markChanged());
        });
      }
    }
  }

  static Future<void> ensureImageExists(List<SavedImage> images) async {
    for (SavedImage savedImage in images) {
      await downloadImage(savedImage);
    }
  }

  static bool imageCached(SavedImage savedImage) {
    return File(savedImage.path).existsSync();
  }

  static Future<void> uploadImage(SavedImage savedImage) async {
    //get normal image
    File normalImage =
        File("${appInfo.tempDirectory.path}/${savedImage.hash}.jpg");
    switch (savedImage.storageLocation) {
      case StorageLocation.LOCAL:
        // TODO: Handle this case.
        // Just dont upload duh
        break;
      case StorageLocation.IMGUR:
        await ImgurController.uploadImage(savedImage, normalImage);
        break;
      case StorageLocation.SYNC:
        await FilesController.uploadImageToSync(savedImage.hash!, normalImage);
        break;
    }
  }

  static Future<SavedImage> prepareLocally(File file) async {
    SavedImage savedImage = SavedImage.empty();
    Uint8List rawBytes = await file.readAsBytes();
    savedImage.hash = await _generateImageHash(rawBytes);
    Image compressedImage = await _compressImage(rawBytes, savedImage);
    String blurHash =
        _generateBlurHash(await _compressForBlur(compressedImage, savedImage));
    savedImage.blurHash = blurHash;
    File imageFile = await _saveImage(compressedImage, savedImage);
    savedImage.uri = imageFile.uri;
    addToDownloaded(savedImage.hash!);
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
      resized = copyResize(image, height: height, width: height);
    } else {
      resized = image;
    }
    return resized;
  }

  static Future<Image> _compressForBlur(
      Image image, SavedImage savedImage) async {
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

  static Future<File> _saveImage(Image image, SavedImage savedImage) async {
    File imageFile = File(savedImage.path);
    await imageFile.writeAsBytes(encodeJpg(image, quality: JPEG_QUALITY));
    return imageFile;
  }

  static void addToDownloaded(String hash) {
    List<String> downloadedImages = prefs.downloadedImages;
    downloadedImages.add(hash);
    prefs.downloadedImages = downloadedImages;
  }

  static void addToDeleted(String hash) {
    List<String> deletedImages = prefs.deletedImages;
    deletedImages.add(hash);
    prefs.deletedImages = deletedImages;
  }

  static void removeFromDeleted(String hash) {
    List<String> deletedImages = prefs.deletedImages;
    deletedImages.remove(hash);
    prefs.deletedImages = deletedImages;
  }

  static void deleteImage(SavedImage image) {
    if (image.uploaded == true) {
      helper.listNotes(ReturnMode.LOCAL).then((notes) {
        var images = [];
        for (var note in notes) {
          images.addAll(note.images);
        }
        if (images.where((otherImage) => otherImage.id != image.id).length >
            0) {
          return;
        } else {
          if (image.storageLocation == StorageLocation.SYNC) {
            addToDeleted(image.hash!);
          }
          if (image.existsLocally) {
            try {
              File(image.path).deleteSync();
            } catch (e) {
              Loggy.e(message: "Could not remove local file ${e.toString()}");
            }
          }
        }
      });
    }
  }

  static Future<bool> handleDeletes() async {
    for (String hash in prefs.deletedImages) {
      await FilesController.deleteImage(hash);
    }
    prefs.deletedImages = [];
    return true;
  }

  static handleNoteDeletion(Note note) {
    for (SavedImage image in note.images) {
      deleteImage(image);
    }
  }
}
