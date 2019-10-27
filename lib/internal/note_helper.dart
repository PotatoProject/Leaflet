import 'dart:async';

import 'package:potato_notes/main.dart';
import 'package:sqflite/sqflite.dart';

class NoteHelper {
  Future<void> insert(Note note) async {
    final Database db = await database;

    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotes(SortMode sort, NotesReturnMode returnMode) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query('notes');

    List<Note> list = List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        isStarred: maps[i]['isStarred'],
        date: maps[i]['date'],
        color: maps[i]['color'],
        imagePath: maps[i]['imagePath'],
        isList: maps[i]['isList'],
        listParseString: maps[i]['listParseString'],
        reminders: maps[i]['reminders'],
        hideContent: maps[i]['hideContent'],
        pin: maps[i]['pin'] == null ? maps[i]['pin'] : maps[i]['pin'].toString(),
        password: maps[i]['password'],
        isDeleted: maps[i]['isDeleted'] ?? 0,
        isArchived: maps[i]['isArchived'] ?? 0,
      );
    });

    list.sort((a, b) {
      if(sort == SortMode.ID) {
        return a.id.compareTo(b.id);
      } else if(sort == SortMode.DATE) {
        return a.date.compareTo(b.date);
      } else {
        return a.id.compareTo(b.id);
      }
    });

    if(returnMode == NotesReturnMode.NORMAL) {
      list.removeWhere((note) => note.isArchived == 1 || note.isDeleted == 1);
    } else if(returnMode == NotesReturnMode.DELETED) {
      list.removeWhere((note) => note.isDeleted == 0);
    } else if(returnMode == NotesReturnMode.ARCHIVED) {
      list.removeWhere((note) => note.isArchived == 0 || note.isDeleted == 1);
    }

    return list;
  }

  Future<void> delete(int id) async {
    final db = await database;

    await db.delete(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> update(Note note) async {
    final db = await database;

    await db.update(
      'notes',
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  Future<void> backupDatabaseToPath(String path) async {
    final db = await database;

    await openDatabase(
      path,
      onOpen: (db) {
        return db.execute(
          """
            CREATE TABLE notes(
              id INTEGER PRIMARY KEY,
              title TEXT,
              content TEXT,
              isStarred INTEGER,
              date INTEGER,
              color INTEGER,
              imagePath TEXT,
              isList INTEGER,
              listParseString TEXT,
              reminders TEXT,
              hideContent INTEGER,
              pin TEXT,
              password TEXT,
              isDeleted INTEGER,
              isArchived INTEGER
            )
          """,
        );
      },
      version: 5,
    );

    db.execute("ATTACH DATABASE '" + path + "' AS backup");
    db.execute("INSERT INTO backup.notes SELECT * FROM main.notes");
    db.execute("DETACH backup");
  }

  Future<void> restoreDatabaseToPath(String path) async {
    final db = await database;

    db.execute("ATTACH DATABASE '" + path + "' AS backup").catchError((error) {
      db.execute("DETACH backup");
      return;
    });
    db.execute("DROP TABLE main.notes");
    db.execute("""
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY,
          title TEXT,
          content TEXT,
          isStarred INTEGER,
          date INTEGER,
          color INTEGER,
          imagePath TEXT,
          isList INTEGER,
          listParseString TEXT,
          reminders TEXT,
          hideContent INTEGER,
          pin TEXT,
          password TEXT,
          isDeleted INTEGER,
          isArchived INTEGER
        )
      """);
    db.execute("""
      INSERT INTO main.notes(
        id,
        title,
        content,
        isStarred,
        date,
        color,
        imagePath,
        isList,
        listParseString,
        reminders,
        hideContent,
        pin,
        password,
        isDeleted,
        isArchived
      ) SELECT * FROM backup.notes
    """);
    db.execute("DETACH backup");
  }

  Future<int> validateDatabase(String path) async {
    int status = 0;

    if (!path.endsWith(".db")) {
      print("lol");
      return 1;
    }

    try {
      Database db = await openReadOnlyDatabase(path);
      await db.rawQuery("SELECT * FROM notes");
    } on Exception catch (e) {
      print(e);
      status = 1;
    }

    return status;
  }

  Future<void> recreateDB() async {
    final db = await database;

    db.execute("ALTER TABLE notes RENAME TO notesold");
    db.execute(
      """
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY,
          title TEXT,
          content TEXT,
          isStarred INTEGER,
          date INTEGER,
          color INTEGER,
          imagePath TEXT,
          isList INTEGER,
          listParseString TEXT,
          reminders TEXT,
          hideContent INTEGER,
          pin TEXT,
          password TEXT,
          isDeleted INTEGER,
          isArchived INTEGER
        )
      """
    );

    db.execute(
      """
        INSERT INTO notes SELECT * FROM notesold
      """
    );

    db.execute("DROP TABLE notesold");
  }
}

class Note {
  final int id;
  final String title;
  final String content;
  final int isStarred;
  final int date;
  final int color;
  final String imagePath;
  final int isList;
  final String listParseString;
  final String reminders;
  final int hideContent;
  final String pin;
  final String password;
  final int isDeleted;
  final int isArchived;

  bool isSelected = false;

  Note({
    this.id,
    this.title,
    this.content,
    this.isStarred,
    this.date,
    this.color,
    this.imagePath,
    this.isList,
    this.listParseString,
    this.reminders,
    this.hideContent,
    this.pin,
    this.password,
    this.isDeleted,
    this.isArchived,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isStarred': isStarred,
      'date': date,
      'color': color,
      'imagePath': imagePath,
      'isList': isList,
      'listParseString': listParseString,
      'reminders': reminders,
      'hideContent': hideContent,
      'pin': pin,
      'password': password,
      'isDeleted': isDeleted,
      'isArchived': isArchived,
    };
  }

  Note copyWith({
    int isStarred,
    int color,
    int isList,
    int hideContent,
    int isDeleted,
    int isArchived,
  }) {
    return Note(
      id: this.id,
      title: this.title,
      content: this.content,
      isStarred: isStarred ?? this.isStarred,
      date: this.date,
      color: color == 0 ? null : color == null ? this.color : color,
      imagePath: this.imagePath,
      isList: isList ?? this.isList,
      listParseString: this.listParseString,
      reminders: this.reminders,
      hideContent: hideContent ?? this.hideContent,
      pin: this.pin,
      password: this.password,
      isDeleted: isDeleted ?? this.isDeleted,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}

class ListPair {
  int checkValue = 0;
  String title = "";

  ListPair({this.checkValue, this.title});
}

enum SortMode {
  ID,
  DATE
}

enum NotesReturnMode {
  ALL,
  NORMAL,
  DELETED,
  ARCHIVED,
}