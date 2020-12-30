import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/image_helper.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:sqflite/sqflite.dart';

class MigrationTask {
  static Future<String> get v1DatabasePath async =>
      join(await getDatabasesPath(), 'notes_database.db');

  static Future<bool> get migrationAvailable async =>
      await File(await v1DatabasePath).exists();

  static Stream<double> migrate() async* {
    Database db = await openDatabase(await v1DatabasePath);

    List<Map<String, dynamic>> rawV1Notes = await db.query('notes');

    List<NoteV1Model> v1Notes = List.generate(rawV1Notes.length, (index) {
      return NoteV1Model(
        id: rawV1Notes[index]['id'],
        title: rawV1Notes[index]['title'],
        content: rawV1Notes[index]['content'],
        isStarred: rawV1Notes[index]['isStarred'],
        date: rawV1Notes[index]['date'],
        color: rawV1Notes[index]['color'],
        imagePath: rawV1Notes[index]['imagePath'],
        isList: rawV1Notes[index]['isList'],
        listParseString: rawV1Notes[index]['listParseString'],
        reminders: rawV1Notes[index]['reminders'],
        hideContent: rawV1Notes[index]['hideContent'],
        pin: rawV1Notes[index]['pin'] == null
            ? rawV1Notes[index]['pin']
            : rawV1Notes[index]['pin'].toString(),
        password: rawV1Notes[index]['password'],
        isDeleted: rawV1Notes[index]['isDeleted'] ?? 0,
        isArchived: rawV1Notes[index]['isArchived'] ?? 0,
      );
    });

    int notesAmount = v1Notes.length;

    for (int index = 0; index < v1Notes.length; index++) {
      NoteV1Model v1Note = v1Notes[index];
      List<ListItem> listItems = [];
      List<String> rawListItems = v1Note.listParseString?.split("\'..\'") ?? [];

      for (int i = 0; i < rawListItems.length; i++) {
        String rawListItem = rawListItems[i];
        List<String> listItem = rawListItem.split("\',,\'");

        listItems.add(
          ListItem(
            i,
            listItem[1],
            int.parse(listItem[0]) == 1,
          ),
        );
      }

      SavedImage? savedImage;
      if (v1Note.imagePath != null) {
        final response = await get(v1Note.imagePath);
        final file = File(join(appInfo.tempDirectory.path, "id.jpg"))..create();
        await file.writeAsBytes(response.bodyBytes);
        savedImage = await ImageHelper.copyToCache(file);
      }

      Note note = Note(
        id: Utils.generateId(),
        title: v1Note.title ?? "",
        content:
            v1Note.content != null && v1Note.isList == 0 ? v1Note.content : "",
        starred: v1Note.isStarred == 1,
        creationDate: DateTime.fromMillisecondsSinceEpoch(v1Note.date),
        lastModifyDate: DateTime.now(),
        color: v1Note.color,
        images: savedImage != null ? [savedImage] : [],
        list: v1Note.isList == 1,
        listContent: listItems,
        reminders: [],
        tags: [],
        hideContent: v1Note.hideContent == 1,
        lockNote: false,
        usesBiometrics: false,
        deleted: v1Note.isDeleted == 1,
        archived: v1Note.isArchived == 1,
        synced: false,
      );

      await helper.saveNote(note);

      yield index / notesAmount;
    }

    db.close();
  }
}

class NoteV1Model {
  final int? id;
  final String? title;
  final String? content;
  final int? isStarred;
  final int date;
  final int color;
  final String? imagePath;
  final int? isList;
  final String? listParseString;
  final String? reminders;
  final int? hideContent;
  final String? pin;
  final String? password;
  final int? isDeleted;
  final int? isArchived;

  NoteV1Model({
    this.id,
    this.title,
    this.content,
    this.isStarred,
    required this.date,
    this.color = 0,
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
}
