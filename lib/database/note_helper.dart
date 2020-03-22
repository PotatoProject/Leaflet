import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:potato_notes/database/model/note.dart';
import 'package:sqflite/sqflite.dart';

class NoteHelper {
  NoteHelper._();

  static final NoteHelper db = NoteHelper._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'notes_database.db');

    return await openDatabase(
      path,
      version: 6,
      onCreate: (db, version) async {
        await db.execute('''
                CREATE TABLE notes(
                    id INTEGER PRIMARY KEY,
                    title TEXT,
                    content TEXT,
                    starred INTEGER DEFAULT 0,
                    creationDate INTEGER,
                    lastModifyDate INTEGER,
                    color INTEGER DEFAULT 0,
                    images TEXT,
                    list INTEGER DEFAULT 0,
                    listContent TEXT,
                    reminders TEXT,
                    hideContent INTEGER DEFAULT 0,
                    pin TEXT,
                    password TEXT,
                    usesBiometrics INTEGER DEFAULT 0,
                    deleted INTEGER DEFAULT 0,
                    archived INTEGER DEFAULT 0,
                    synced INTEGER DEFAULT 0,
                )
            ''');
      },
      onUpgrade: (db, from, to) async {
        if(from == 5) {
          await db
              .execute('ALTER TABLE notes RENAME COLUMN isStarred TO starred');
          await db
              .execute('ALTER TABLE notes RENAME COLUMN date TO creationDate');
          await db.execute('ALTER TABLE notes RENAME COLUMN imagePath TO images');
          await db.execute('ALTER TABLE notes RENAME COLUMN isList TO list');
          await db.execute(
              'ALTER TABLE notes RENAME COLUMN listParseString TO listContent');
          await db
              .execute('ALTER TABLE notes RENAME COLUMN isDeleted TO deleted');
          await db
              .execute('ALTER TABLE notes RENAME COLUMN isArchived TO archived');
          await db.execute(
              'ALTER TABLE notes ADD COLUMN lastModifyDate INTEGER DEFAULT 0');
          await db.execute(
              'ALTER TABLE notes ADD COLUMN usesBiometrics INTEGER DEFAULT 0');
          await db
              .execute('ALTER TABLE notes ADD COLUMN synced INTEGER DEFAULT 0');
        }
      },
    );
  }

  newNote(Note note) async {
    final db = await database;
    await db.insert("notes", note.toJson);
  }

  listNotes() async {
    final db = await database;
    final query = await db.query("notes");
    List<Note> notes = List.generate(query.length, (index) => Note.fromJson(query[index]));
    return notes;
  }
  
  updateNote(Note note) async {
		final db = await database;
		var res = await db.update("notes", note.toJson, where: "id = ?", whereArgs: [note.id]);

		return res;
	}

  deleteNote(int id) async {
    final db = await database;
    await db.delete("notes", where: "id = ?", whereArgs: [id]);
  }
}
