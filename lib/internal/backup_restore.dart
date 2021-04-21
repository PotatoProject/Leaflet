import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/data/model/tag_list.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

class BackupRestore {
  static Future<void> saveNote(Note note) async {
    final Directory baseDir = await getTemporaryDirectory();
    final Directory noteDir =
        Directory(p.join(baseDir.path, "${note.id}-export"));
    await _createNoteFolderStructure(
      note: note,
      baseDir: noteDir,
    );

    final Directory docsDir = await getApplicationDocumentsDirectory();
    final Directory outDir = Directory(p.join(
      docsDir.path,
      "LeafletBackups",
    ));
    final String formattedDate =
        DateFormat("dd_MM_yyyy-HH_mm_ss").format(DateTime.now());
    ZipFileEncoder()
      ..create(p.join(outDir.path, "note-$formattedDate.note"))
      ..addDirectory(noteDir, includeDirName: false)
      ..close();

    await noteDir.delete(recursive: true);
  }

  static Future<File> createBackup({
    required List<Note> notes,
    String? name,
    ValueChanged<int>? onProgress,
  }) async {
    final Directory tempDir = await getTemporaryDirectory();
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat("dd_MM_yyyy-HH_mm_ss").format(now);
    final Directory baseDir =
        Directory(p.join(tempDir.path, "$formattedDate-backup"));
    await baseDir.create();

    final Map<String, dynamic> metadata = {};
    final List<String> noteIds = [];
    for (int i = 0; i < notes.length; i++) {
      final Note note = notes[i];
      final Directory noteDir =
          Directory(p.join(baseDir.path, "${note.id}-export"));
      noteIds.add(note.id);
      await _createNoteFolderStructure(
        note: note,
        baseDir: noteDir,
      );
      onProgress?.call(i + 1);
    }
    final String _name = name ?? formattedDate;
    metadata["name"] = _name;
    metadata["notes"] = noteIds;
    metadata["note_count"] = notes.length;
    metadata["creation_date"] = now.millisecondsSinceEpoch;
    metadata["app_version"] = appInfo.packageInfo.buildNumberInt;
    final File metadataFile = File(p.join(baseDir.path, "meta.data"));
    await metadataFile.writeAsString(
      const JsonEncoder.withIndent('    ').convert(metadata),
    );

    final Directory docsDir = await getApplicationDocumentsDirectory();
    final Directory outDir = Directory(p.join(
      docsDir.path,
      "LeafletBackups",
    ));
    ZipFileEncoder()
      ..create(p.join(outDir.path, "backup-$_name.backup"))
      ..addDirectory(baseDir, includeDirName: false)
      ..close();

    await baseDir.delete(recursive: true);

    return File(p.join(outDir.path, "backup-$_name.backup"));
  }

  static Future<void> _createNoteFolderStructure({
    required Note note,
    required Directory baseDir,
  }) async {
    await baseDir.create();
    final DateTime now = DateTime.now();
    final File noteDataFile = File(p.join(baseDir.path, "note.data"));
    final Map<String, dynamic> noteData = {};
    noteData["note"] = note.toJson();
    noteData["creation_date"] = now.millisecondsSinceEpoch;
    noteData["app_version"] = appInfo.packageInfo.buildNumberInt;

    await noteDataFile.writeAsString(
      const JsonEncoder.withIndent('    ').convert(noteData),
    );

    if (note.images.isNotEmpty) {
      final Directory imagesDirectory =
          Directory(p.join(baseDir.path, "images"));
      await imagesDirectory.create();
      for (final SavedImage image in note.images) {
        await File(image.path).copy(
          p.join(imagesDirectory.path, "${image.id}${image.fileExtension}"),
        );
      }
    }
  }

  static Future<Note?> restoreNote(String path) async {
    final Directory imagesDir = await getTemporaryDirectory();
    final File zipFile = File(path);
    final List<int> fileBytes = await zipFile.readAsBytes();
    final List<ArchiveFile> files = ZipDecoder().decodeBytes(fileBytes).files;
    Note? returnNote;

    for (final ArchiveFile file in files) {
      if (file.isFile) {
        if (file.name == "note.data") {
          final String content = utf8.decode(file.content as List<int>);
          final Map<String, dynamic> decodedContent =
              Utils.asMap<String, dynamic>(json.decode(content));
          final Map<String, dynamic> noteJson =
              Utils.asMap<String, dynamic>(decodedContent["note"]);
          final Note note = Note.fromJson(
            noteJson,
            serializer: const _TypeAwareValueSerializer(),
          );
          helper.saveNote(note);
          returnNote = note;
        } else if (file.name.startsWith("images/")) {
          final File image = File(
            p.join(
              imagesDir.path,
              file.name.replaceAll("images/", ""),
            ),
          );
          await image.writeAsBytes(file.content as List<int>);
        }
      }
    }
    return returnNote;
  }
}

class _TypeAwareValueSerializer extends ValueSerializer {
  const _TypeAwareValueSerializer();

  @override
  T fromJson<T>(dynamic jsonContent) {
    if (jsonContent == null) {
      return null as T;
    }

    final _typeList = <T>[];

    if (_typeList is List<DateTime?>) {
      return DateTime.fromMillisecondsSinceEpoch(jsonContent as int) as T;
    }

    if (_typeList is List<double> && jsonContent is int) {
      return jsonContent.toDouble() as T;
    }

    // blobs are encoded as a regular json array, so we manually convert that to
    // a Uint8List
    if (_typeList is List<Uint8List> && jsonContent is! Uint8List) {
      final asList = (jsonContent as List).cast<int>();
      return Uint8List.fromList(asList) as T;
    }

    if (jsonContent is List<dynamic> && _typeList is List<List<SavedImage>>) {
      return const ImageListConverter().mapToDart(json.encode(jsonContent))
          as T;
    }

    if (jsonContent is List<dynamic> && _typeList is List<List<ListItem>>) {
      return const ListContentConverter().mapToDart(json.encode(jsonContent))
          as T;
    }

    if (jsonContent is List<dynamic> && _typeList is List<List<DateTime>>) {
      return const ReminderListConverter().mapToDart(json.encode(jsonContent))
          as T;
    }

    if (jsonContent is List<dynamic> && _typeList is List<List<String>>) {
      return const TagListConverter().mapToDart(json.encode(jsonContent)) as T;
    }

    return jsonContent as T;
  }

  @override
  dynamic toJson<T>(T value) {
    if (value is DateTime) {
      return value.millisecondsSinceEpoch;
    }

    return value;
  }
}
