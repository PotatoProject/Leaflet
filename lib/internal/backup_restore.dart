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
import 'package:path_provider/path_provider.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/data/model/tag_list.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';

class BackupRestore {
  static Future<void> saveNote(Note note, String password) async {
    final String outputDir = await _getOutputDir();
    final Map<String, dynamic> payload = {
      'note': note.toJson(serializer: const _TypeAwareValueSerializer()),
      'password': password,
      'buildNumber': appInfo.packageInfo.buildNumberInt,
      'baseDir': appInfo.tempDirectory.path,
      'outputDir': outputDir,
    };

    final String filePath = await compute(_rawSaveNote, json.encode(payload));

    if (UniversalPlatform.isIOS) {
      Share.shareFiles([filePath]);
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
    final String outputDir = data['outputDir']! as String;

    final Directory noteDir = Directory(p.join(baseDir, "${note.id}-export"));
    await _createNoteFolderStructure(
      note: note,
      baseDir: noteDir,
      tempDir: baseDir,
    );
    final Directory outDir = Directory(outputDir);
    if (!await outDir.exists()) await outDir.create();
    final ZipByteEncoder encoder = ZipByteEncoder()
      ..create()
      ..addDirectory(noteDir, includeDirName: false);
    final List<int> fileBytes = encoder.close();
    await noteDir.delete(recursive: true);
    final _NoteMetadata metadata = _NoteMetadata(
      createdAt: DateTime.now(),
      appVersion: buildNumber,
      noteCount: 1,
    );
    final String formattedDate =
        DateFormat("dd_MM_yyyy-HH_mm_ss").format(DateTime.now());
    final String filePath = p.join(outputDir, "note-$formattedDate.note");
    File(filePath).writeAsBytes(
      _combineMetadata(
        metadata,
        await _encryptBytes(fileBytes, password),
      ),
    );
    return filePath;
  }

  static Future<String> createBackup({
    required List<Note> notes,
    required String password,
    String? name,
    ValueChanged<int>? onProgress,
  }) async {
    final ReceivePort progressPort = ReceivePort();
    final ReceivePort returnPort = ReceivePort();
    final String outDir = await _getOutputDir();
    final _BackupPayload payload = _BackupPayload(
      progressPort: progressPort.sendPort,
      returnPort: returnPort.sendPort,
      notes: notes,
      password: password,
      outDir: outDir,
      baseDir: appInfo.tempDirectory.path,
      appVersion: appInfo.packageInfo.buildNumberInt,
      name: name,
    );
    await Isolate.spawn(_rawCreateBackup, payload);
    progressPort.listen((message) {
      onProgress?.call(message as int);
    });

    final String finalBackupName = await returnPort.first as String;
    return p.join(outDir, 'backup-$finalBackupName.backup');
  }

  static Future<void> _rawCreateBackup(_BackupPayload payload) async {
    final SendPort progressPort = payload.progressPort;
    final List<Note> notes = payload.notes;
    final String password = payload.password;
    final String outDir = payload.outDir;
    final String tempDir = payload.baseDir;
    final int appVersion = payload.appVersion;
    final String? name = payload.name;

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
        tempDir: tempDir,
      );
      progressPort.send(i + 1);
    }
    final String _name = name ?? formattedDate;
    final _NoteMetadata metadata = _NoteMetadata(
      noteCount: notes.length,
      name: _name,
      createdAt: now,
      appVersion: appVersion,
    );

    final ZipByteEncoder encoder = ZipByteEncoder()
      ..create()
      ..addDirectory(baseDir, includeDirName: false)
      ..close();
    final List<int> fileBytes = encoder.close();
    await baseDir.delete(recursive: true);
    File(p.join(outDir, "backup-$_name.backup")).writeAsBytes(
      _combineMetadata(
        metadata,
        await _encryptBytes(fileBytes, password),
      ),
    );
    payload.returnPort.send(_name);
  }

  static Future<void> _createNoteFolderStructure({
    required Note note,
    required Directory baseDir,
    required String tempDir,
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
        await File(p.join(tempDir, "${image.id}${image.fileExtension}")).copy(
          p.join(imagesDirectory.path, "${image.id}${image.fileExtension}"),
        );
      }
    }
  }

  static Future<bool> restoreNote(String path, String password) async {
    final Map<String, dynamic> payload = {
      'path': path,
      'password': password,
      'baseDir': appInfo.tempDirectory.path,
    };

    final String rawNote = await compute(_rawRestoreNote, json.encode(payload));

    if (rawNote != "null") {
      final Note note = Note.fromJson(
        json.decode(rawNote) as Map<String, dynamic>,
        serializer: const _TypeAwareValueSerializer(),
      );
      if (!await helper.noteExists(note)) {
        await helper.saveNote(note);
        return true;
      }
    }
    return false;
  }

  static Future<String> _rawRestoreNote(String payload) async {
    final Map<String, dynamic> data =
        json.decode(payload) as Map<String, dynamic>;

    final String path = data['path']! as String;
    final String password = data['password']! as String;
    final String baseDir = data['baseDir']! as String;

    final File zipFile = File(path);
    final List<int> fileBytes = await zipFile.readAsBytes();
    final _MetadataExtractionResult extractionResult =
        _extractMetadata(fileBytes);
    final List<int> decryptedBytes =
        await _decryptBytes(extractionResult.data, password);
    final List<ArchiveFile> files =
        ZipDecoder().decodeBytes(decryptedBytes).files;
    Note? returnNote;

    for (final ArchiveFile file in files) {
      if (file.isFile) {
        if (file.name == "note.data") {
          final String content = utf8.decode(file.content as List<int>);
          final Map<String, dynamic> decodedContent =
              Utils.asMap<String, dynamic>(json.decode(content));
          final Map<String, dynamic> noteJson =
              Utils.asMap<String, dynamic>(decodedContent);
          final Note note = Note.fromJson(
            noteJson,
            serializer: const _TypeAwareValueSerializer(),
          );
          returnNote = note;
        } else if (file.name.startsWith("images/")) {
          final File image = File(
            p.join(
              baseDir,
              file.name.replaceAll("images/", ""),
            ),
          );
          await image.writeAsBytes(file.content as List<int>);
        }
      }
    }

    return returnNote?.toJsonString(
          serializer: const _TypeAwareValueSerializer(),
        ) ??
        "null";
  }

  static Future<String> _getOutputDir() async {
    if (UniversalPlatform.isAndroid) {
      final List<Directory>? directories =
          await getExternalStorageDirectories(type: StorageDirectory.documents);
      return p.join(directories!.first.path, "LeafletBackups");
    }
    return p.join(
        (await getApplicationDocumentsDirectory()).path, "LeafletBackups");
  }

  static List<int> _combineMetadata(_NoteMetadata metadata, List<int> data) {
    final List<int> metadataBytes = metadata.toJsonString().codeUnits;

    final ByteData byteData = ByteData(2);
    byteData.setInt16(0, metadataBytes.length, Endian.little);

    return [
      ...byteData.buffer.asUint8List(),
      ...metadataBytes,
      ...data,
    ];
  }

  static _MetadataExtractionResult _extractMetadata(List<int> data) {
    final List<int> header = data.sublist(0, 2);

    final ByteData byteData = ByteData.sublistView(Uint8List.fromList(header));
    final int metadataLength = byteData.getInt16(0, Endian.little);

    final List<int> metadataBytes = data.sublist(2, metadataLength + 2);
    final List<int> payload = data.sublist(metadataLength + 2);

    return _MetadataExtractionResult(
      _NoteMetadata.fromJsonString(utf8.decode(metadataBytes)),
      payload,
    );
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
  final int appVersion;
  final String? name;

  const _BackupPayload({
    required this.progressPort,
    required this.returnPort,
    required this.notes,
    required this.password,
    required this.outDir,
    required this.baseDir,
    required this.appVersion,
    this.name,
  });
}

class _MetadataExtractionResult {
  final _NoteMetadata metadata;
  final List<int> data;

  const _MetadataExtractionResult(this.metadata, this.data);

  @override
  String toString() {
    return metadata.toJsonString();
  }
}

class _NoteMetadata {
  final String? name;
  final DateTime createdAt;
  final int noteCount;
  final int appVersion;

  _NoteMetadata({
    required this.createdAt,
    required this.appVersion,
    required this.noteCount,
    this.name,
  });

  factory _NoteMetadata.fromJson(Map<String, dynamic> json) {
    final String? name = json['name'] as String?;
    final int? noteCount = json['noteCount'] as int?;
    final int? createdAt = json['createdAt'] as int?;
    final int? appVersion = json['appVersion'] as int?;

    if (createdAt == null || appVersion == null || noteCount == null) {
      throw ArgumentError.notNull();
    }

    return _NoteMetadata(
      name: name,
      noteCount: noteCount,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      appVersion: appVersion,
    );
  }

  factory _NoteMetadata.fromJsonString(String jsonString) {
    return _NoteMetadata.fromJson(
        json.decode(jsonString) as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'noteCount': noteCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'appVersion': appVersion,
    };
  }

  String toJsonString() => json.encode(toJson());
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
