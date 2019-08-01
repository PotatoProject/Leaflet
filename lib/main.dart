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

import 'package:potato_notes/internal/methods.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/ui/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

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
            initialRoute: '/',
            routes: {
              '/': (context) => NotesMainPageRoute(noteList),
              '/addnote': (context) => ModifyNotesRoute(new Note(id: null, title: "", content: "")),
            },
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

  Note({this.id, this.title, this.content});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}

class NotesMainPageRoute extends StatefulWidget {
  List<Note> noteList = List<Note>();
  NotesMainPageRoute(List<Note> list) {
    this.noteList = list;
  }

  @override
  _NotesMainPageState createState() => new _NotesMainPageState(noteList);
}

class _NotesMainPageState extends State<NotesMainPageRoute> {
  List<Note> noteList = List<Note>();

  _NotesMainPageState(List<Note> list) {
    this.noteList = list;
  }

  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Brightness systemBarsIconBrightness = Theme.of(context).brightness == Brightness.dark ?
        Brightness.light :
        Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: systemBarsIconBrightness,
      statusBarColor: Theme.of(context).cardColor,
      statusBarIconBrightness: systemBarsIconBrightness,
    ));
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
              height: 70,
              child: Center(
                child: Text(
                  "Potato Notes",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 70.0),
            child: noteList.length != 0 ? ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                return NoteList(context, index);
              },
            ) : Center(
              child: Text("No notes added... yet"),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0.0,
        onPressed: () {
          _addNoteCaller(context);
        },
        icon: Icon(Icons.add),
        label: Text("Add new note"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child: Builder(
          builder: (context) {
            final appInfo = Provider.of<AppInfoProvider>(context);
            return BottomAppBar(
              color: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                child: Center(
                                  child: Container(
                                    width: 140,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: Theme.of(context).textTheme.title.color.withAlpha(120),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: Center(
                                  child: Text(
                                    "Settings",
                                    style: TextStyle(
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                              ),
                              SwitchListTile(
                                activeColor: Theme.of(context).accentColor,
                                secondary: Icon(Icons.brightness_5),
                                title: Text('Dark theme'),
                                value: appInfo.isDark,
                                onChanged: (value) => appInfo.isDark = value,
                              ),
                              ListTile(
                                leading: IconTheme(
                                  data: IconThemeData(color: Theme.of(context).accentColor),
                                  child: Icon(Icons.brightness_1),
                                ),
                                title: Text('Main app color'),
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    Color currentColor = Theme.of(context).accentColor;
                                    return AlertDialog(
                                      title: Text("Main color selector"),
                                      content: MaterialColorPicker(
                                        circleSize: 70.0,
                                        allowShades: true,
                                        onColorChange: (color) {
                                          currentColor = color;
                                        },
                                        onMainColorChange: (ColorSwatch color) {
                                          // Handle main color changes
                                        },
                                        selectedColor: currentColor,
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(color: Theme.of(context).accentColor),
                                          ),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                        FlatButton(
                                          child: Text(
                                            "Confirm",
                                            style: TextStyle(color: Theme.of(context).accentColor),
                                          ),
                                          onPressed: () {
                                            appInfo.mainColor = currentColor;
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                ),
                              ),
                            ],
                          );
                        }
                      );
                    },
                  ),
                  Spacer(flex: 5),
                  IconButton(
                    icon: new Icon(Icons.code),
                    onPressed: () => launchUrl("https://github.com/HrX03/PotatoNotes"),
                  ),
                  Spacer(),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  void _addNoteCaller(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/addnote');

    if (result != null) setState(() => noteList = result);
  }

  void _editNoteCaller(BuildContext context, Note note) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyNotesRoute(note)));

    if (result != null) setState(() => noteList = result);
  }

  Widget NoteList(BuildContext context, int index) {
    Color borderCardColor = HSLColor.fromColor(Theme.of(context).textTheme.title.color)
        .withAlpha(0.2)
        .toColor();
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: borderCardColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 14.0, bottom: 0.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: noteList[index].title == "" ? false : true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      noteList[index].title,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Text(
                  noteList[index].content,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () => _editNoteCaller(context, noteList[index]),
                ),
                FlatButton(
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete note"),
                          content: Text(
                              "Are you sure you want to delete this note?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                "No",
                                style: TextStyle(color: Theme.of(context).accentColor),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            FlatButton(
                              child: Text(
                                "Yes",
                                style: TextStyle(color: Theme.of(context).accentColor),
                              ),
                              onPressed: () async {
                                await NoteHelper().delete(noteList[index].id);
                                List<Note> list =
                                    await NoteHelper().getNotes();
                                setState(() => noteList = list);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ModifyNotesRoute extends StatefulWidget {
  Note note = Note();
  ModifyNotesRoute(Note note) {
    this.note = note;
  }

  @override
  _ModifyNotesState createState() => new _ModifyNotesState(note);
}

class _ModifyNotesState extends State<ModifyNotesRoute> {
  int noteId;
  String noteTitle = "";
  String noteContent = "";

  _ModifyNotesState(Note note) {
    this.noteId = note.id;
    this.noteTitle = note.title;
    this.noteContent = note.content;
  }

  NoteHelper noteHelper = new NoteHelper();
  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: noteTitle);
    TextEditingController contentController = TextEditingController(text: noteContent);

    titleController.selection = TextSelection.collapsed(offset: noteTitle.length);
    contentController.selection = TextSelection.collapsed(offset: noteContent.length);

    Color cardColor = Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).dividerColor
          : Theme.of(context).scaffoldBackgroundColor;

    double cardBrightness = Theme.of(context).brightness == Brightness.dark
          ? 0.5
          : 0.96;

    Color borderCardColor = HSLColor.fromColor(Theme.of(context).textTheme.title.color)
        .withAlpha(0.2)
        .toColor();

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
              height: 70,
              child: Center(
                child: Text(
                  noteId == null ? "Add new note" : "Update note",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 90.0),
            child: ListView(
              children: <Widget>[
                Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
                        child: Text(
                          "Title",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        color: HSLColor.fromColor(cardColor)
                            .withLightness(cardBrightness)
                            .toColor(),
                        child: Padding(
                          padding: EdgeInsets.only(top: 6.0, bottom: 6.0, left: 10.0, right: 10.0),
                          child: TextField(
                            controller: titleController,
                            decoration: InputDecoration(hintText: 'Note title', border: InputBorder.none),
                            onChanged: (text) {
                              noteTitle = text;
                            },
                            maxLength: 60,
                          ),
                        ),
                      ),
                    ],
                  )
                ),
                Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
                        child: Text(
                          "Content",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        color: HSLColor.fromColor(cardColor)
                            .withLightness(cardBrightness)
                            .toColor(),
                        child: Padding(
                          padding: EdgeInsets.only(top: 6.0, bottom: 6.0, left: 10.0, right: 10.0),
                          child: TextField(
                            controller: contentController,
                            decoration: InputDecoration(hintText: 'Note content', border: InputBorder.none),
                            onChanged: (text) {
                              noteContent = text;
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: 9,
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () async {
          if (noteContent != "") {
            List<Note> noteList = await noteHelper.getNotes();
            int id = noteId == null ? noteList.length : noteId;
            await noteHelper.insert(Note(
                id: id, title: noteTitle, content: noteContent));
            noteList = await noteHelper.getNotes();
            Navigator.pop(context, noteList);
          } else {
            scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text(noteId == null ?
                  "Can't add a note with empty content" :
                  "Can't update a note with empty content"),
            ));
          }
        },
        icon: Icon(Icons.done),
        label: Text("Done"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child: Builder(
          builder: (context) {
            return BottomAppBar(
              color: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Spacer(flex: 5),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}