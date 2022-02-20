// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:potato_notes/data/dao/folder_helper.dart';
import 'package:potato_notes/data/dao/image_helper.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/data/model/id_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

part 'database.g.dart';

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  BoolColumn get starred => boolean().withDefault(const Constant(false))();
  DateTimeColumn get creationDate => dateTime()();
  IntColumn get color => integer().withDefault(const Constant(0))();
  TextColumn get images => text().map(const IdListConverter())();
  BoolColumn get list => boolean().withDefault(const Constant(false))();
  TextColumn get listContent => text().map(const ListContentConverter())();
  TextColumn get reminders => text().map(const ReminderListConverter())();
  TextColumn get tags => text().map(const IdListConverter())();
  BoolColumn get hideContent => boolean().withDefault(const Constant(false))();
  BoolColumn get lockNote => boolean().withDefault(const Constant(false))();
  BoolColumn get usesBiometrics =>
      boolean().withDefault(const Constant(false))();
  TextColumn get folder => text().withDefault(const Constant('default'))();
  DateTimeColumn get lastChanged => dateTime()();
  DateTimeColumn get lastSynced => dateTime().nullable()();

  @Deprecated("Prefer 'folder'")
  BoolColumn get deleted =>
      boolean().nullable().withDefault(const Constant(false))();

  @Deprecated("Prefer 'folder'")
  BoolColumn get archived =>
      boolean().nullable().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get lastChanged => dateTime()();
  DateTimeColumn get lastSynced => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Folders extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get icon => integer().withDefault(const Constant(0))();
  IntColumn get color => integer().withDefault(const Constant(0))();
  BoolColumn get readOnly => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastChanged => dateTime()();
  DateTimeColumn get lastSynced => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class NoteImages extends Table {
  TextColumn get id => text()();
  TextColumn get hash => text().nullable()();
  TextColumn get blurHash => text().nullable()();
  TextColumn get type => text()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastChanged => dateTime()();
  DateTimeColumn get lastSynced => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String? get tableName => 'images';
}

@DriftDatabase(
  tables: [Notes, Tags, Folders, NoteImages],
  daos: [NoteHelper, TagHelper, FolderHelper, ImageHelper],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, previous, current) async {
          if (previous < 7) {
            await migrator.recreateAllViews();
            await migrator.createAll();
            await migrator.renameColumn(
              notes,
              'last_modify_date',
              notes.lastChanged,
            );
            await migrator.renameColumn(
              tags,
              'last_modify_date',
              tags.lastChanged,
            );
            migrator.addColumn(notes, notes.folder);
            migrator.addColumn(notes, notes.lastSynced);
            await migrator.alterTable(TableMigration(notes));
          }
        },
        beforeOpen: (details) async {
          if (details.hadUpgrade && (details.versionBefore ?? 0) < 7) {
            // Images
            await _migrateImagesFromV6();

            // Folders
            await _migrateNotesToFoldersV6();
          }
        },
      );

  Future<void> _migrateImagesFromV6() async {
    final List<Note> dbNotes = await noteHelper.listNotes(BuiltInFolders.all);
    final Map<Note, List<String>> notesWithImages = {};

    final Set<SavedImage> oldImages = {};
    for (final Note note in dbNotes) {
      final List<SavedImage> savedImages = note.images
          .map(
            (e) => SavedImage.fromJson(
              Utils.asMap<String, dynamic>(
                jsonDecode(e),
              ),
            ),
          )
          .toList();

      oldImages.addAll(savedImages);
      notesWithImages[note] = savedImages.map((e) => e.path).toList();
      note.images.clear();
    }

    for (final SavedImage oldImage in oldImages) {
      imageHelper.saveImage(
        NoteImage(
          id: oldImage.id,
          hash: oldImage.hash,
          blurHash: oldImage.blurHash,
          type: oldImage.fileExtension!,
          width: oldImage.width!.round(),
          height: oldImage.height!.round(),
          uploaded: oldImage.uploaded,
          lastChanged: DateTime.now(),
        ),
      );

      for (final noteWithImage in notesWithImages.entries) {
        if (noteWithImage.value.contains(oldImage.path)) {
          noteWithImage.key.images.add(oldImage.id);
        }
      }
    }

    for (final Note note in notesWithImages.keys) {
      await noteHelper.saveNote(note);
    }
  }

  Future<void> _migrateNotesToFoldersV6() async {
    final List<Note> dbNotes = await noteHelper.listNotes(BuiltInFolders.all);
    final List<Folder> dbFolders = await folderHelper.listFolders();
    final List<Note> newNotes = [];

    for (final Note note in dbNotes) {
      if (note.archived!) {
        if (!dbFolders.contains(BuiltInFolders.archive)) {
          await folderHelper.saveFolder(BuiltInFolders.archive);
        }

        newNotes.add(note.copyWith(folder: BuiltInFolders.archive.id));
      } else if (note.deleted!) {
        newNotes.add(note.copyWith(folder: BuiltInFolders.trash.id));
      } else {
        newNotes.add(note);
      }
    }

    for (final Note note in newNotes) {
      await noteHelper.saveNote(note);
    }
  }
}
