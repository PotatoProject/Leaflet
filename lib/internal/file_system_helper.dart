import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';

class FileSystemHelper {
  const FileSystemHelper._();

  static const MethodChannel filePromptChannel =
      MethodChannel('potato_notes_file_prompt');

  static Future<String?> getFile({
    String? initialDirectory,
    List<String>? allowedExtensions,
  }) async {
    String? pickedPath;

    if (DeviceInfo.isDesktop) {
      final XFile? file = await openFile(
        acceptedTypeGroups: [
          XTypeGroup(
            extensions: allowedExtensions,
          ),
        ],
        initialDirectory: initialDirectory,
      );
      pickedPath = file?.path;
    } else {
      final List<PlatformFile>? files =
          (await FilePicker.platform.pickFiles())?.files;
      if (files?.isNotEmpty == true) {
        pickedPath = files!.first.path;
      }
    }

    return pickedPath;
  }

  static Future<List<String>?> getFiles({
    String? initialDirectory,
    List<String>? allowedExtensions,
  }) async {
    List<String>? pickedPaths;

    if (DeviceInfo.isDesktop) {
      final List<XFile> files = await openFiles(
        acceptedTypeGroups: [
          XTypeGroup(
            extensions: allowedExtensions,
          ),
        ],
        initialDirectory: initialDirectory,
      );

      pickedPaths = files.map((e) => e.path).toList();
    } else {
      final List<PlatformFile>? files =
          (await FilePicker.platform.pickFiles())?.files;

      pickedPaths = files?.map((e) => e.path!).toList() ?? [];
    }

    return pickedPaths;
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
        {'name': name ?? basename(inputFile), 'path': inputFile},
      );

      return SaveFileResult._(path: null, success: savePath != null);
    }

    if (outputPath != null) {
      return SaveFileResult._(
        path: join(outputPath, basename(inputFile)),
        success: true,
      );
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
