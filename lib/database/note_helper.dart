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
    String documentsDir = await getDatabasesPath();
    String path = join(documentsDir, 'notes_database.db');

    Future<void> _createTable(Database db, String name) async {
      db.execute('''
          CREATE TABLE $name(
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
            synced INTEGER DEFAULT 0
          )
      ''');
    }

    return await openDatabase(
      path,
      version: 6,
      onCreate: (db, version) async {
        await _createTable(db, "notes");
      },
      onUpgrade: (db, from, to) async {
        if (from == 5) {
          await _createTable(db, "notes_temp");
          await db.execute('''
              INSERT INTO notes_temp(
                id, title, content, starred, creationDate, color,
                images, list, listContent, reminders, hideContent, pin,
                password, deleted, archived
              )
              SELECT id, title, content, isStarred, date, color,
                imagePath, isList, listParseString, reminders, hideContent, pin,
                password, isDeleted, isArchived
              FROM notes;
          ''');
          await db.execute('DROP TABLE notes');
          await db.execute('ALTER TABLE notes_temp RENAME TO notes');
        }
      },
    );
  }

  newNote(Note note) async {
    final db = await database;
    await db.insert(
      "notes", note.toJson,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  listNotes() async {
    final db = await database;
    final query = await db.query("notes");
    List<Note> notes =
        List.generate(query.length, (index) => Note.fromJson(query[index]));
    return notes;
  }

  updateNote(Note note) async {
    final db = await database;
    var res = await db
        .update("notes", note.toJson, where: "id = ?", whereArgs: [note.id]);

    return res;
  }

  deleteNote(int id) async {
    final db = await database;
    await db.delete("notes", where: "id = ?", whereArgs: [id]);
  }
}
