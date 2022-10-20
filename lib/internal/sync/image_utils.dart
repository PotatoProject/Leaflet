import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart';
import 'package:liblymph/database.dart';
import 'package:liblymph/encryption.dart';
import 'package:loggy/loggy.dart';
import 'package:path/path.dart';
import 'package:potato_notes/internal/providers.dart';

// ignore: avoid_classes_with_only_static_members
class ImageUtils {
  static const int maxHeight = 4096;
  static const int maxBlurHashHeight = 100;
  static const int jpegQuality = 60;

  static String filePathFromImage(NoteImage noteImage) {
    return join(
      appDirectories.imagesDirectory.path,
      noteImage.id + noteImage.type,
    );
  }

  static Future<bool> imageDownloaded(NoteImage image) async {
    return File(filePathFromImage(image)).exists();
  }

  static Future<NoteImage> processImage(NoteImage noteImage) async {
    String filePath = filePathFromImage(noteImage);

    Uint8List bytes = await File(filePath).readAsBytes();
    var image = compressImage(bytes);
    var nI = noteImage.copyWith(width: image.width, height: image.height);
    final String blurhash = generateBlurHash(compressForBlur(image));
    nI = nI.copyWith(blurHash: blurhash);
    await saveImage(image, filePath);
    return nI;
  }

  static Image compressImage(Uint8List rawBytes) {
    final Image image = decodeImage(rawBytes)!;
    // Default height of compressed images
    Image resized;
    // Ensure we dont enlarge the picture since the resize algorithm makes it look ugly then
    if (image.height > maxHeight) {
      resized = copyResize(image, height: maxHeight);
    } else {
      resized = image;
    }
    return resized;
  }

  static Image compressForBlur(Image image) {
    // Default height of compressed images
    Image resized;
    // Ensure we dont enlarge the picture since the resize algorithm makes it look ugly then
    if (image.height > maxBlurHashHeight) {
      resized = copyResize(image, height: maxBlurHashHeight);
    } else {
      resized = image;
    }
    return resized;
  }

  static String generateBlurHash(Image image) {
    final String hash = BlurHash.encode(image).hash;
    return hash;
  }

  static Future saveImage(Image image, String path) async {
    final File imageFile = File(path);
    await imageFile.writeAsBytes(encodeJpg(image, quality: jpegQuality));
  }
}
