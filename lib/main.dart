// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/routes/notes_main_page_route.dart';
import 'package:potato_notes/ui/no_glow_scroll_behavior.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

Future<Database> database;

void main() async {
  database = openDatabase(
    join(await getDatabasesPath(), 'notes_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT)",
      );
    },
    version: 1,
  );

  List<Note> noteList = await NoteHelper().getNotes();

  runApp(NotesRoot(noteList));
}

class NotesRoot extends StatelessWidget {
  List<Note> noteList = List<Note>();

  NotesRoot(List<Note> list) {
    this.noteList = list;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppInfoProvider>.value(
          value: AppInfoProvider(),
        ),
      ],
      child:  Builder(
        builder: (context) {
          final appInfo = Provider.of<AppInfoProvider>(context);
          return MaterialApp(
            builder: (context, child) => ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: child,
            ),
            home: NotesMainPageRoute(noteList),
            debugShowCheckedModeBanner: false,
            theme: appInfo.isDark
                ? ThemeData.dark().copyWith(
                    accentColor: appInfo.mainColor,
                    cursorColor: appInfo.mainColor,
                    textSelectionHandleColor: appInfo.mainColor)
                : ThemeData.light().copyWith(
                    accentColor: appInfo.mainColor,
                    cursorColor: appInfo.mainColor,
                    textSelectionHandleColor: appInfo.mainColor),
            title: 'Notes',
          );
        }
      ),
    );
  }
}