import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/methods.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/routes/modify_notes_route.dart';

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

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

  List<int> selectionList = List<int>();
  bool isSelectorVisible = false;

  @override
  Widget build(BuildContext context) {
    Brightness systemBarsIconBrightness = Theme.of(context).brightness == Brightness.dark ?
        Brightness.light :
        Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: systemBarsIconBrightness,
      statusBarColor: isSelectorVisible ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).cardColor,
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                color: isSelectorVisible ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).cardColor,
              ),
              padding: EdgeInsets.only(left: 30, right: 20),
              height: 70,
              child: isSelectorVisible ?
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        selectionList.length.toString() + " selected",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          for (int i = 0; i < selectionList.length; i++)
                            await NoteHelper().delete(noteList[i].id);
                          selectionList = List<int>();
                          List<Note> list = await NoteHelper().getNotes();
                          setState(() {
                            noteList = list;
                            isSelectorVisible = false;
                          });
                        },
                      ),
                    ),
                  ],
                ) :
                Center(
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
                return _noteList(context, index);
              },
            ) : Center(
              child: Text("No notes added... yet"),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0.0,
        onPressed: () {
          _addNoteCaller(context);
          setState(() => isSelectorVisible = false);
        },
        child: Icon(Icons.add),
        tooltip: "Add new note",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomBar,
    );
  }

  void _addNoteCaller(BuildContext context) async {
    final Note emptyNote = Note(id: null, title: "", content: "");
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyNotesRoute(emptyNote)));

    if (result != null) setState(() => noteList = result);
  }

  void _editNoteCaller(BuildContext context, Note note) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyNotesRoute(note)));

    if (result != null) setState(() => noteList = result);
  }

  Widget _noteList(BuildContext context, int index) {
    Color borderCardColor = HSLColor.fromColor(Theme.of(context).textTheme.title.color)
        .withAlpha(0.2)
        .toColor();

    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: borderCardColor, width: 1.0),
      ),
      child: Row(
        children: <Widget>[
          Visibility(
            visible: isSelectorVisible,
            child: Checkbox(
              value: noteList[index].isSelected,
              onChanged: (value) {
                setState(() => noteList[index].isSelected = value);
                if (value == true) {
                  setState(() => selectionList.add(noteList[index].id));
                } else {
                  setState(() => selectionList.remove(noteList[index].id));
                }
              },
              activeColor: Theme.of(context).accentColor,
              checkColor: Theme.of(context).cardColor,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 14.0, bottom: isSelectorVisible ? 14.0 : 0.0, left: 20.0, right: 20.0),
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
              Visibility(
                visible: !isSelectorVisible,
                child: ButtonTheme.bar(
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get _bottomBar {
    return ClipRRect(
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
                Spacer(),
                IconButton(
                  icon: Icon(Icons.select_all),
                  onPressed: () {
                    setState(() => isSelectorVisible = !isSelectorVisible);
                  }
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
    );
  }
}