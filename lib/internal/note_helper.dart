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
      );
    });
  }

  Future<List<Note>> getFavouriteNotes() async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query('notes');
    List<Note> initialList = List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        isStarred: maps[i]['isStarred'],
      );
    });
    List<Note> favouriteList = List<Note>();

    initialList.forEach((item) {
      if(item.isStarred == 1)
        favouriteList.add(item);
    });
    
    return favouriteList;
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
  bool isSelected  = false;

  Note({this.id, this.title, this.content, this.isStarred});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isStarred': isStarred
    };
  }
}