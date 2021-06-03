import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';

class FileSystemHelper {
  static const MethodChannel filePromptChannel =
      MethodChannel('potato_notes_file_prompt');

  static Future<String?> getFile({
    String? initialDirectory,
    List<String>? allowedExtensions,
  }) async {
    final dynamic asyncFile = DeviceInfo.isDesktop
        ? await openFile(
            acceptedTypeGroups: [
              XTypeGroup(
                extensions: allowedExtensions,
              ),
            ],
            initialDirectory: initialDirectory,
          )
        : (await FilePicker.platform.pickFiles())?.files.first;

    return asyncFile?.path as String;
  }

  static Future<List<String>?> getFiles({
    String? initialDirectory,
    List<String>? allowedExtensions,
  }) async {
    final List<dynamic>? asyncFiles = DeviceInfo.isDesktop
        ? await openFiles(
            acceptedTypeGroups: [
              XTypeGroup(
                extensions: allowedExtensions,
              ),
            ],
            initialDirectory: initialDirectory,
          )
        : (await FilePicker.platform.pickFiles())?.files;

    return asyncFiles?.map((e) => e.path as String).toList();
  }

  static Future<SaveFileResult> saveFile({
    required String inputFile,
    String? outputPath,
    String? name,
  }) async {
    final File input = File(inputFile);
    if (UniversalPlatform.isIOS) {
      await Share.shareFiles([inputFile]);
      return const SaveFileResult._(path: null, success: true);
    }
    if (UniversalPlatform.isMacOS) {
      final String? savePath = await getSavePath(
        initialDirectory: outputPath ?? input.parent.path,
        suggestedName: name,
      );

      return SaveFileResult._(path: savePath, success: savePath != null);
    }
    if (UniversalPlatform.isAndroid) {
      final String? savePath = await filePromptChannel.invokeMethod<String>(
        'requestFileExport',
        {
          'name': name ?? basename(inputFile),
          'path': outputPath ?? input.parent.path
        },
      );

      return SaveFileResult._(path: null, success: savePath != null);
    }

    if (outputPath != null) {
      return SaveFileResult._(
          path: join(outputPath, basename(inputFile)), success: true);
    } else {
      return SaveFileResult._(path: inputFile, success: true);
    }
  }
}

class SaveFileResult {
  final String? path;
  final bool success;

  const SaveFileResult._({
    required this.path,
    required this.success,
  });
}
