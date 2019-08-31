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
import 'package:potato_notes/internal/search_filters.dart';
import 'package:potato_notes/routes/notes_main_page_route.dart';
import 'package:potato_notes/ui/no_glow_scroll_behavior.dart';
import 'package:potato_notes/ui/themes.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'internal/methods.dart';

Future<Database> database;
AppInfoProvider appInfo;
SearchFiltersProvider searchFilters;

void main() async {

  database = openDatabase(
    join(await getDatabasesPath(), 'notes_database.db'),
    onCreate: (db, version) {
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
            reminders TEXT
          )
        """,
      );
    },
    onOpen: (db) {
      List<String> columnsToAdd = [
        "ALTER TABLE notes ADD COLUMN id INTEGER PRIMARY KEY",
        "ALTER TABLE notes ADD COLUMN title TEXT",
        "ALTER TABLE notes ADD COLUMN content TEXT",
        "ALTER TABLE notes ADD COLUMN isStarred INTEGER",
        "ALTER TABLE notes ADD COLUMN date INTEGER",
        "ALTER TABLE notes ADD COLUMN color INTEGER",
        "ALTER TABLE notes ADD COLUMN imagePath TEXT",
        "ALTER TABLE notes ADD COLUMN isList INTEGER",
        "ALTER TABLE notes ADD COLUMN listParseString TEXT",
        "ALTER TABLE notes ADD COLUMN reminders TEXT"
      ];

      for(int i = 0; i < columnsToAdd.length; i++) {
        db.execute(
          columnsToAdd[i]
        ).catchError((error) {
          //do nothing
        });
      }
    },
    version: 4,
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
        ChangeNotifierProvider<SearchFiltersProvider>.value(
          value: SearchFiltersProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          appInfo = Provider.of<AppInfoProvider>(context);
          searchFilters = Provider.of<SearchFiltersProvider>(context);

          if(appInfo.themeMode == 0) {
            changeSystemBarsColors(CustomThemes.light(appInfo).scaffoldBackgroundColor,
                Brightness.dark);
          } else if(appInfo.themeMode == 1) {
            changeSystemBarsColors(CustomThemes.dark(appInfo).scaffoldBackgroundColor,
                Brightness.light);
          } else {
            changeSystemBarsColors(CustomThemes.black(appInfo).scaffoldBackgroundColor,
                Brightness.light);
          }

          return MaterialApp(
            builder: (context, child) => ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: child,
            ),
            home: NotesMainPageRoute(noteList),
            debugShowCheckedModeBanner: false,
            theme: appInfo.themeMode == 0 ? CustomThemes.light(appInfo) : appInfo.themeMode == 1 ?
                CustomThemes.dark(appInfo) : CustomThemes.black(appInfo),
            title: 'Notes',
          );
        }
      ),
    );
  }
}