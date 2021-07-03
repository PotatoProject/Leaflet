import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:cryptography/cryptography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/data/model/tag_list.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/file_system_helper.dart';
import 'package:potato_notes/internal/logger_provider.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

class BackupDelegate with LoggerProvider {
  Future<bool> saveNote(Note note, String password) async {
    try {
      final String outputDir = appDirectories.backupDirectory.path;
      final String formattedDate =
          DateFormat("dd_MM_yyyy-HH_mm_ss").format(DateTime.now());
      final String name = "note-$formattedDate.note";
      final Map<String, dynamic> payload = {
        'note': note.toJson(serializer: const _TypeAwareValueSerializer()),
        'password': password,
        'buildNumber': appInfo.packageInfo.buildNumberInt,
        'baseDir': appDirectories.tempDirectory.path,
        'imagesDir': appDirectories.imagesDirectory.path,
        'outputDir': outputDir,
        'name': name,
        'tags': _encodeTags(await tagHelper.getTagsById(note.tags)),
      };
      logger.d(payload['tags']);

      final String filePath = await compute(_rawSaveNote, json.encode(payload));

      final SaveFileResult outputFile = await FileSystemHelper.saveFile(
        inputFile: filePath,
        outputPath: appDirectories.backupDirectory.path,
        name: name,
      );

      if (outputFile.success && outputFile.path != null) {
        await File(filePath).copy(outputFile.path!);
        return true;
      } else {
        return outputFile.success;
      }
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  static Future<String> _rawSaveNote(String payload) async {
    final Map<String, dynamic> data =
        json.decode(payload) as Map<String, dynamic>;

    final Note note = Note.fromJson(
      data['note']! as Map<String, dynamic>,
      serializer: const _TypeAwareValueSerializer(),
    );
    final String password = data['password']! as String;
    final int buildNumber = data['buildNumber']! as int;
    final String baseDir = data['baseDir']! as String;
    final String imagesDir = data['imagesDir']! as String;
    final String outputDir = data['outputDir']! as String;
    final String name = data['name']! as String;
    final List<Map<String, dynamic>> rawTags =
        Utils.asList<Map<String, dynamic>>(data['tags']);
    final List<Tag> tags = _decodeTags(rawTags);

    final Directory noteDir = Directory(p.join(baseDir, "${note.id}-export"));
    await _createNoteFolderStructure(
      note: note,
      baseDir: noteDir,
      imagesDir: imagesDir,
    );
    final Directory outDir = Directory(outputDir);
    if (!await outDir.exists()) await outDir.create();
    final ZipByteEncoder encoder = ZipByteEncoder()
      ..create()
      ..addDirectory(noteDir, includeDirName: false);
    final List<int> fileBytes = encoder.close();
    await noteDir.delete(recursive: true);
    final NoteBackupMetadata metadata = NoteBackupMetadata(
      name: name,
      createdAt: DateTime.now(),
      appVersion: buildNumber,
      noteCount: 1,
      tags: tags,
    );
    final String filePath = p.join(outputDir, name);
    await File(filePath).writeAsBytes(
      _combineMetadata(
        metadata,
        await _encryptBytes(fileBytes, password),
      ),
    );
    return filePath;
  }

  Future<String> createBackup({
    required List<Note> notes,
    required String password,
    required String name,
    ValueChanged<int>? onProgress,
  }) async {
    final ReceivePort progressPort = ReceivePort();
    final ReceivePort returnPort = ReceivePort();
    final String outDir = appDirectories.backupDirectory.path;
    final List<Tag> tags = [];
    for (final Note note in notes) {
      tags.addAll(await tagHelper.getTagsById(note.tags));
    }

    final _BackupPayload payload = _BackupPayload(
      progressPort: progressPort.sendPort,
      returnPort: returnPort.sendPort,
      notes: notes,
      password: password,
      outDir: outDir,
      baseDir: appDirectories.tempDirectory.path,
      imagesDir: appDirectories.imagesDirectory.path,
      appVersion: appInfo.packageInfo.buildNumberInt,
      name: name,
      tags: tags,
    );
    await Isolate.spawn(_rawCreateBackup, payload);
    progressPort.listen((message) {
      onProgress?.call(message as int);
    });

    final String finalBackupName = await returnPort.first as String;
    return p.join(outDir, finalBackupName);
  }

  static Future<void> _rawCreateBackup(_BackupPayload payload) async {
    final SendPort progressPort = payload.progressPort;
    final List<Note> notes = payload.notes;
    final String password = payload.password;
    final String outDir = payload.outDir;
    final String tempDir = payload.baseDir;
    final String imagesDir = payload.imagesDir;
    final int appVersion = payload.appVersion;
    final String name = payload.name;
    final List<Tag> tags = payload.tags;

    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat("dd_MM_yyyy-HH_mm_ss").format(now);
    final Directory baseDir =
        Directory(p.join(tempDir, "$formattedDate-backup"));
    await baseDir.create();

    final List<String> noteIds = [];
    for (int i = 0; i < notes.length; i++) {
      final Note note = notes[i];
      final Directory noteDir =
          Directory(p.join(baseDir.path, "${note.id}-export"));
      noteIds.add(note.id);
      await _createNoteFolderStructure(
        note: note,
        baseDir: noteDir,
        imagesDir: imagesDir,
      );
      progressPort.send(i + 1);
    }
    final NoteBackupMetadata metadata = NoteBackupMetadata(
      noteCount: notes.length,
      name: name,
      createdAt: now,
      appVersion: appVersion,
      tags: tags,
    );

    final ZipByteEncoder encoder = ZipByteEncoder()
      ..create()
      ..addDirectory(baseDir, includeDirName: false)
      ..close();
    final List<int> fileBytes = encoder.close();
    await baseDir.delete(recursive: true);
    final String backupPath = p.join(outDir, name);
    File(backupPath).writeAsBytes(
      _combineMetadata(
        metadata,
        await _encryptBytes(fileBytes, password),
      ),
    );
    payload.returnPort.send(backupPath);
  }

  static Future<void> _createNoteFolderStructure({
    required Note note,
    required Directory baseDir,
    required String imagesDir,
  }) async {
    await baseDir.create();
    final File noteDataFile = File(p.join(baseDir.path, "note.data"));

    await noteDataFile.writeAsString(
      const JsonEncoder.withIndent('    ').convert(note.toJson()),
    );

    if (note.images.isNotEmpty) {
      final Directory imagesDirectory =
          Directory(p.join(baseDir.path, "images"));
      await imagesDirectory.create();
      for (final SavedImage image in note.images) {
        final String imagePath =
            p.join(imagesDir, "${image.id}${image.fileExtension}");
        final String newImagePath =
            p.join(imagesDirectory.path, "${image.id}${image.fileExtension}");
        try {
          await File(imagePath).copy(newImagePath);
        } on FileSystemException {}
      }
    }
  }

  Future<RestoreResult> restoreNote(
      MetadataExtractionResult extractionResult, String password) async {
    final Map<String, dynamic> payload = {
      'data': extractionResult.data,
      'tags': _encodeTags(extractionResult.metadata.tags),
      'password': password,
      'baseDir': appDirectories.tempDirectory.path,
    };

    try {
      final String rawPayload =
          await compute(_rawRestoreNote, json.encode(payload));

      return RestoreResult.fromJsonString(rawPayload);
    } catch (e) {
      logger.e(e);
      return const RestoreResult.fromStatus(RestoreResultStatus.unknown);
    }
  }

  static Future<String> _rawRestoreNote(String payload) async {
    final Map<String, dynamic> data =
        json.decode(payload) as Map<String, dynamic>;

    final List<int> fileData = Utils.asList<int>(data['data']);
    final List<Tag> tags =
        _decodeTags(Utils.asList<Map<String, dynamic>>(data['tags']));
    final String password = data['password']! as String;
    final String baseDir = data['baseDir']! as String;

    late final List<int> decryptedBytes;
    late final List<ArchiveFile> files;

    try {
      decryptedBytes = await _decryptBytes(fileData, password);
    } catch (e) {
      return const RestoreResult.fromStatus(RestoreResultStatus.wrongPassword)
          .toJsonString();
    }

    try {
      files = ZipDecoder().decodeBytes(decryptedBytes).files;
    } catch (e) {
      return const RestoreResult.fromStatus(RestoreResultStatus.wrongFormat)
          .toJsonString();
    }

    final List<Note> returnNotes = [];

    for (final ArchiveFile file in files) {
      if (file.isFile) {
        if (file.name.endsWith("note.data")) {
          final String content = utf8.decode(file.content as List<int>);
          final Map<String, dynamic> decodedContent =
              Utils.asMap<String, dynamic>(json.decode(content));
          final Map<String, dynamic> noteJson =
              Utils.asMap<String, dynamic>(decodedContent);
          final Note note = Note.fromJson(
            noteJson,
            serializer: const _TypeAwareValueSerializer(),
          );
          returnNotes.add(note);
        } else if (file.name.contains("images/")) {
          final File image = File(
            p.join(
              baseDir,
              file.name.replaceAll(RegExp(".*images/"), ""),
            ),
          );
          await image.writeAsBytes(file.content as List<int>);
        }
      }
    }

    return RestoreResult(
      notes: returnNotes,
      tags: tags,
      status: RestoreResultStatus.success,
    ).toJsonString();
  }

  static List<int> _combineMetadata(
      NoteBackupMetadata metadata, List<int> data) {
    final List<int> metadataBytes = metadata.toJsonString().codeUnits;

    final ByteData byteData = ByteData(2);
    byteData.setInt16(0, metadataBytes.length, Endian.little);

    return [
      ...byteData.buffer.asUint8List(),
      ...metadataBytes,
      ...data,
    ];
  }

  static Future<MetadataExtractionResult?> extractMetadataFromFile(
      String path) async {
    return extractMetadata(File(path).readAsBytesSync());
  }

  static MetadataExtractionResult? extractMetadata(List<int> data) {
    try {
      final List<int> header = data.sublist(0, 2);

      final ByteData byteData =
          ByteData.sublistView(Uint8List.fromList(header));
      final int metadataLength = byteData.getInt16(0, Endian.little);

      final List<int> metadataBytes = data.sublist(2, metadataLength + 2);
      final List<int> payload = data.sublist(metadataLength + 2);

      return MetadataExtractionResult(
        metadata: NoteBackupMetadata.fromJsonString(utf8.decode(metadataBytes)),
        data: payload,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<List<int>> _encryptBytes(
      List<int> origin, String password) async {
    final keySalt = _generateNonce();
    final key = await _deriveKey(password, keySalt);

    final aes = AesGcm.with256bits();
    final ciphertext = await aes.encrypt(origin, secretKey: key);

    return [
      ...keySalt,
      ...ciphertext.nonce,
      ...ciphertext.mac.bytes,
      ...ciphertext.cipherText,
    ];
  }

  static Future<List<int>> _decryptBytes(
      List<int> origin, String password) async {
    final keySalt = origin.sublist(0, 16);
    final aesNonce = origin.sublist(16, 28);
    final macBytes = origin.sublist(28, 44);
    final payload = origin.sublist(44);

    final key = await _deriveKey(password, keySalt);

    final aes = AesGcm.with256bits();
    final plaintext = await aes.decrypt(
      SecretBox(
        payload,
        nonce: aesNonce,
        mac: Mac(macBytes),
      ),
      secretKey: key,
    );

    return plaintext;
  }

  static List<Map<String, dynamic>> _encodeTags(List<Tag> tags) {
    return tags
        .map((e) => e.toJson(serializer: const _TypeAwareValueSerializer()))
        .toList();
  }

  static List<Tag> _decodeTags(List<Map<String, dynamic>> tags) {
    return tags
        .map((e) =>
            Tag.fromJson(e, serializer: const _TypeAwareValueSerializer()))
        .toList();
  }

  static List<int> _generateNonce([int length = 16]) => List.generate(
        length,
        (index) => Random.secure().nextInt(255),
      );

  static Future<SecretKey> _deriveKey(String password, List<int> nonce) async {
    final kdf = Pbkdf2(
      bits: 256,
      iterations: 100000,
      macAlgorithm: Hmac.sha512(),
    );
    final key = await kdf.deriveKey(
      secretKey: SecretKey(password.codeUnits),
      nonce: nonce,
    );

    return key;
  }
}

class _BackupPayload {
  final SendPort progressPort;
  final SendPort returnPort;
  final List<Note> notes;
  final String password;
  final String outDir;
  final String baseDir;
  final String imagesDir;
  final int appVersion;
  final String name;
  final List<Tag> tags;

  const _BackupPayload({
    required this.progressPort,
    required this.returnPort,
    required this.notes,
    required this.password,
    required this.outDir,
    required this.baseDir,
    required this.imagesDir,
    required this.appVersion,
    required this.name,
    required this.tags,
  });
}

class MetadataExtractionResult {
  final NoteBackupMetadata metadata;
  final List<int> data;

  const MetadataExtractionResult({
    required this.metadata,
    required this.data,
  });

  @override
  String toString() {
    return metadata.toJsonString();
  }
}

class RestoreResult {
  final List<Note> notes;
  final List<Tag> tags;
  final RestoreResultStatus status;

  const RestoreResult({
    required this.notes,
    required this.tags,
    required this.status,
  });

  const RestoreResult.fromStatus(this.status)
      : notes = const [],
        tags = const [];

  factory RestoreResult.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawNotes = json['notes'] as List<dynamic>;
    final List<dynamic> rawTags = json['tags'] as List<dynamic>;
    final int status = json['status']! as int;

    final List<Map<String, dynamic>> notes =
        Utils.asList<Map<String, dynamic>>(rawNotes);
    final List<Map<String, dynamic>> tags =
        Utils.asList<Map<String, dynamic>>(rawTags);

    return RestoreResult(
      notes: notes
          .map(
            (n) =>
                Note.fromJson(n, serializer: const _TypeAwareValueSerializer()),
          )
          .toList(),
      tags: BackupDelegate._decodeTags(tags),
      status: RestoreResultStatus.values[status],
    );
  }

  factory RestoreResult.fromJsonString(String jsonString) {
    return RestoreResult.fromJson(
        json.decode(jsonString) as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['notes'] = notes
        .map((e) => e.toJson(serializer: const _TypeAwareValueSerializer()))
        .toList();
    json['tags'] = BackupDelegate._encodeTags(tags);
    json['status'] = status.index;

    return json;
  }

  String toJsonString() => json.encode(toJson());

  @override
  String toString() {
    return toJsonString();
  }
}

enum RestoreResultStatus {
  success,
  wrongPassword,
  wrongFormat,
  alreadyExists,
  unknown,
}

class NoteBackupMetadata {
  final String name;
  final DateTime createdAt;
  final int noteCount;
  final int appVersion;
  final List<Tag> tags;

  NoteBackupMetadata({
    required this.createdAt,
    required this.appVersion,
    required this.noteCount,
    this.tags = const <Tag>[],
    required this.name,
  });

  factory NoteBackupMetadata.fromJson(Map<String, dynamic> json) {
    final String name = json['name']! as String;
    final int noteCount = json['noteCount']! as int;
    final int createdAt = json['createdAt']! as int;
    final int appVersion = json['appVersion']! as int;
    final List<dynamic> tags = json['tags']! as List<dynamic>;

    return NoteBackupMetadata(
      name: name,
      noteCount: noteCount,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      appVersion: appVersion,
      tags: tags.map((t) => Tag.fromJson(t as Map<String, dynamic>)).toList(),
    );
  }

  factory NoteBackupMetadata.fromJsonString(String jsonString) {
    return NoteBackupMetadata.fromJson(
        json.decode(jsonString) as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['name'] = name;
    json['noteCount'] = noteCount;
    json['createdAt'] = createdAt.millisecondsSinceEpoch;
    json['appVersion'] = appVersion;
    json['tags'] = tags
        .map((e) => e.toJson(serializer: const _TypeAwareValueSerializer()))
        .toList();

    return json;
  }

  String toJsonString() => json.encode(toJson());

  @override
  String toString() {
    return toJsonString();
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

class ZipByteEncoder {
  late String zipPath;
  late OutputStream _output;
  late ZipEncoder _encoder;

  static const int store = 0;
  static const int gzip = 1;

  void zipDirectory(Directory dir, {String? filename, int? level}) {
    level ??= gzip;
    create(level: level);
    addDirectory(dir, includeDirName: false, level: level);
    close();
  }

  void create({int? level}) {
    _output = OutputStream();
    _encoder = ZipEncoder();
    _encoder.startEncode(_output, level: level);
  }

  void addDirectory(Directory dir, {bool includeDirName = true, int? level}) {
    final List<FileSystemEntity> files = dir.listSync(recursive: true);
    for (final FileSystemEntity file in files) {
      if (file is! File) {
        continue;
      }

      final f = file;
      final dirName = p.basename(dir.path);
      final relPath = p.relative(f.path, from: dir.path);
      addFile(f, includeDirName ? ('$dirName/$relPath') : relPath, level);
    }
  }

  void addFile(File file, [String? filename, int? level = gzip]) {
    final InputFileStream fileStream = InputFileStream.file(file);
    final ArchiveFile archiveFile = ArchiveFile.stream(
        filename ?? p.basename(file.path), file.lengthSync(), fileStream);

    if (level == store) {
      archiveFile.compress = false;
    }

    archiveFile.lastModTime = file.lastModifiedSync().millisecondsSinceEpoch;
    archiveFile.mode = file.statSync().mode;

    _encoder.addFile(archiveFile);
    fileStream.close();
  }

  void addArchiveFile(ArchiveFile file) {
    _encoder.addFile(file);
  }

  List<int> close() {
    _encoder.endEncode();
    return _output.getBytes();
  }
}
