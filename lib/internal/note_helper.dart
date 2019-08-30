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

  bool isSelected  = false;

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
    };
  }
}

class ListPair {
  int checkValue = 0;
  String title = "";
  
  ListPair({this.checkValue, this.title});
}