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

  Future<List<Note>> getNotes() async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (i) {
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
        pin: maps[i]['pin'],
        password: maps[i]['password'],
      );
    });
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
              pin INTEGER,
              password TEXT
            )
          """,
        );
      },
      version: 4,
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
          pin INTEGER,
          password TEXT
        )
      """);
    db.execute("INSERT INTO main.notes SELECT * FROM backup.notes");
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
  final int pin;
  final String password;

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
    };
  }

  Note copyWith({
    int localIsStarred,
    int localColor,
    int localIsList,
    int localHideContent,
  }) {
    return Note(
      id: this.id,
      title: this.title,
      content: this.content,
      isStarred: localIsStarred ?? this.isStarred,
      date: this.date,
      color: localColor ?? this.color,
      imagePath: this.imagePath,
      isList: localIsList ?? this.isList,
      listParseString: this.listParseString,
      reminders: this.reminders,
      hideContent: localHideContent ?? this.hideContent,
      pin: this.pin,
      password: this.password,
    );
  }
}

class ListPair {
  int checkValue = 0;
  String title = "";

  ListPair({this.checkValue, this.title});
}
