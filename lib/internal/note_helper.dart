import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:potato_notes/main.dart';
import 'package:sqflite/sqflite.dart';

class NoteHelper {
  static Future<void> insert(Note note) async {
    final Database db = await database;

    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Note>> getNotes(
      SortMode sort, NotesReturnMode returnMode) async {
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
        pin:
            maps[i]['pin'] == null ? maps[i]['pin'] : maps[i]['pin'].toString(),
        password: maps[i]['password'],
        isDeleted: maps[i]['isDeleted'] ?? 0,
        isArchived: maps[i]['isArchived'] ?? 0,
      );
    });

    list.sort((a, b) {
      if (sort == SortMode.ID) {
        return a.id.compareTo(b.id);
      } else if (sort == SortMode.DATE) {
        return a.date.compareTo(b.date);
      } else {
        return a.id.compareTo(b.id);
      }
    });

    if (returnMode == NotesReturnMode.NORMAL) {
      list.removeWhere((note) => note.isArchived == 1 || note.isDeleted == 1);
    } else if (returnMode == NotesReturnMode.DELETED) {
      list.removeWhere((note) => note.isDeleted == 0);
    } else if (returnMode == NotesReturnMode.ARCHIVED) {
      list.removeWhere((note) => note.isArchived == 0 || note.isDeleted == 1);
    }

    return list;
  }

  static Future<void> delete(int id) async {
    final db = await database;

    await db.delete(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<void> update(Note note) async {
    final db = await database;

    await db.update(
      'notes',
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  static Future<void> backupDatabaseToPath(String path) async {
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

  static Future<void> restoreDatabaseToPath(String path) async {
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

  static Future<int> validateDatabase(String path) async {
    int status = 0;

    if (!path.endsWith(".db")) {
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

  static Future<void> recreateDB() async {
    final db = await database;

    db.execute("ALTER TABLE notes RENAME TO notesold");
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
        INSERT INTO notes SELECT * FROM notesold
      """);

    db.execute("DROP TABLE notesold");
  }
}

class OnlineNoteHelper {
  static Future<void> save(Note note) async {
    await post("https://sync.potatoproject.co/api/notes/save",
        body: note.readyForRequest,
        headers: {"Authorization": appInfo.userToken});
  }

  static Future<void> delete(int id) async {
    await post("https://sync.potatoproject.co/api/notes/delete",
        body: id, headers: {"Authorization": appInfo.userToken});
  }

  static Future<List<Note>> getNotes(
      SortMode sort, NotesReturnMode returnMode) async {
    Response parsedNoteList = await get(
        "https://sync.potatoproject.co/api/notes/list",
        headers: {"Authorization": appInfo.userToken});

    List<Note> list = await Note.fromRequest(
        json.decode(parsedNoteList.body)["notes"], false);

    list.sort((a, b) {
      if (sort == SortMode.ID) {
        return a.id.compareTo(b.id);
      } else if (sort == SortMode.DATE) {
        return a.date.compareTo(b.date);
      } else {
        return a.id.compareTo(b.id);
      }
    });

    if (returnMode == NotesReturnMode.NORMAL) {
      list.removeWhere((note) => note.isArchived == 1 || note.isDeleted == 1);
    } else if (returnMode == NotesReturnMode.DELETED) {
      list.removeWhere((note) => note.isDeleted == 0);
    } else if (returnMode == NotesReturnMode.ARCHIVED) {
      list.removeWhere((note) => note.isArchived == 0 || note.isDeleted == 1);
    }

    return list;
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

  String get readyForRequest {
    String content = this.content.replaceAll('\n', '\\n');

    return "{" +
        '"note_id": ${this.id}, ' +
        '"title": "${this.title}", ' +
        '"content": "$content", ' +
        '"is_starred": ${this.isStarred == 1}, ' +
        '"date": "${DateTime.fromMillisecondsSinceEpoch(this.date).toUtc().toIso8601String()}", ' +
        '"color": ${this.color}, ' +
        '"image_url":' +
        (this.imagePath == null ? 'null' : '"${this.imagePath}"') +
        ', ' +
        '"is_list": ${this.isList == 1}, ' +
        '"list_parse_string":' +
        (this.listParseString == null ? 'null' : '"${this.listParseString}"') +
        ', ' +
        '"reminders":' +
        (this.reminders == null ? 'null' : '"${this.reminders}"') +
        ', ' +
        '"hide_content": ${this.hideContent == 1}, ' +
        '"pin":' +
        (this.pin == null ? 'null' : '"${this.pin}"') +
        ', ' +
        '"password":' +
        (this.password == null ? 'null' : '"${this.password}"') +
        ', ' +
        '"is_deleted": ${this.isDeleted == 1}, ' +
        '"is_archived": ${this.isArchived == 1}' +
        "}";
  }

  static Future<List<Note>> fromRequest(
      List<dynamic> list, bool generateNewIds) async {
    Future<int> noteIdSearcher() async {
      List<Note> noteList =
          await NoteHelper.getNotes(SortMode.ID, NotesReturnMode.ALL);
      List<int> noteIdList = List<int>();

      noteList.forEach((item) {
        noteIdList.add(item.id);
      });

      if (noteIdList.length > 0) {
        return noteIdList[noteIdList.length - 1] + 1;
      } else
        return 1;
    }

    List<Note> returnList = [];

    for (int i = 0; list == null ? false : i < list?.length ?? 0; i++) {
      returnList.add(Note(
        id: generateNewIds ? await noteIdSearcher() : list[i]["note_id"],
        title: list[i]["title"],
        content: list[i]["content"],
        isStarred: list[i]["is_starred"] ? 1 : 0,
        date: DateTime.parse(list[i]["date"]).millisecondsSinceEpoch,
        color: list[i]["color"] == 0 ? null : list[i]["color"],
        imagePath: list[i]["image_url"] == "" || list[i]["image_url"] == "null"
            ? null
            : list[i]["image_url"],
        isList: list[i]["is_list"] ? 1 : 0,
        listParseString: list[i]["list_parse_string"] == ""
            ? null
            : list[i]["list_parse_string"],
        reminders: list[i]["reminders"] == "" || list[i]["reminders"] == "null"
            ? null
            : list[i]["reminders"],
        hideContent: list[i]["hide_content"] ?? false ? 1 : 0,
        pin: list[i]["pin"] == "" || list[i]["pin"] == "null"
            ? null
            : list[i]["pin"],
        password: list[i]["password"] == "" || list[i]["password"] == "null"
            ? null
            : list[i]["password"],
        isDeleted: list[i]["is_deleted"] ? 1 : 0,
        isArchived: list[i]["is_archived"] ? 1 : 0,
      ));
    }

    return returnList;
  }
}

class ListPair {
  int checkValue = 0;
  String title = "";

  ListPair({this.checkValue, this.title});
}

enum SortMode { ID, DATE }

enum NotesReturnMode {
  ALL,
  NORMAL,
  DELETED,
  ARCHIVED,
}
