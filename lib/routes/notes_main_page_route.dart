import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/methods.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/routes/favourite_notes_route.dart';
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

    final appInfo = Provider.of<AppInfoProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
              decoration: BoxDecoration(
                color: isSelectorVisible ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).cardColor,
              ),
              padding: EdgeInsets.only(left: 20, right: 20),
              height: 70,
              child: isSelectorVisible ?
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () async {
                          selectionList = List<int>();
                          noteList.forEach((item) {
                            item.isSelected = false;
                          });
                          setState(() => isSelectorVisible = false);
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          selectionList.length.toString() + " selected",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          for (int i = 0; i < selectionList.length; i++)
                            await NoteHelper().delete(selectionList[i]);
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
                    "Notes",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 70.0),
            child: noteList.length != 0 ? ListView.builder(
              itemCount: appInfo.isGridView ? 1 : noteList.length,
              itemBuilder: (context, index) {
                if(appInfo.isGridView) {
                  return noteGridBuilder(context);
                } else {
                  int bIndex = (noteList.length - 1) - index; 
                  return noteListItem(context, bIndex, false, null);
                }
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
          selectionList = List<int>();
          noteList.forEach((item) {
            item.isSelected = false;
          });
          setState(() => isSelectorVisible = false);
        },
        child: Icon(Icons.add),
        tooltip: "Add new note",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomBar,
    );
  }

  Widget noteGridBuilder(BuildContext context) {
    List<Widget> columnOne = List<Widget>();
    List<Widget> columnTwo = List<Widget>();

    bool secondColumnFirst = false;

    if((noteList.length - 1).isEven) {
      secondColumnFirst = false;
    } else {
      secondColumnFirst = true;
    }


    for(int i = 0; i < noteList.length; i++) {
      int bIndex = (noteList.length - 1) - i;
      if(bIndex.isEven) {
        columnOne.add(noteListItem(context, bIndex, true,
            secondColumnFirst ? DismissDirection.startToEnd : DismissDirection.endToStart));
      } else {
        columnTwo.add(noteListItem(context, bIndex, true,
            secondColumnFirst ? DismissDirection.endToStart : DismissDirection.startToEnd));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            children: secondColumnFirst ? columnTwo : columnOne,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            children: secondColumnFirst ? columnOne : columnTwo,
          ),
        ),
      ],
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

  Future<List<Note>> _favouriteNotesCaller(BuildContext context, List<Note> noteList) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteNotesRoute(noteList)));

    List<Note> list = await NoteHelper().getNotes();
    return list;
  }

  Widget noteListItem(BuildContext context, int index, bool oneSideOnly, DismissDirection dismissDirection) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    Color cardColor = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).dividerColor
        : Theme.of(context).scaffoldBackgroundColor;

    double cardBrightness = Theme.of(context).brightness == Brightness.dark
        ? 0.5
        : 0.96;
    
    return GestureDetector(
      onTap: () {
        if(isSelectorVisible) {
          setState(() {
            noteList[index].isSelected = !noteList[index].isSelected;
            if(noteList[index].isSelected) {
              selectionList.add(noteList[index].id);
            } else {
              selectionList.remove(noteList[index].id);
              if(selectionList.length == 0) {
                isSelectorVisible = false;
              }
            }
          });
        } else {
          _editNoteCaller(context, noteList[index]);
        }
      },
      onLongPress: () {
        if(!isSelectorVisible)
          setState(() {
            isSelectorVisible = true;
            noteList[index].isSelected = true;
            selectionList.add(noteList[index].id);
          });
      },
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: noteList[index].isSelected ? Theme.of(context).accentColor : Colors.transparent, width: 1.5),
        ),
        color: HSLColor.fromColor(cardColor)
            .withLightness(cardBrightness)
            .toColor(),
        child: Dismissible(
          background: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Center(
              child: Icon(Icons.delete),
            ),
          ),
          direction: isSelectorVisible ? null : oneSideOnly ? dismissDirection : DismissDirection.horizontal,
          onDismissed: (direction) async {
            Note noteBackup = Note(
              id: noteList[index].id,
              title: noteList[index].title,
              content: noteList[index].content,
              isStarred: noteList[index].isStarred,
            );
            await NoteHelper().delete(noteList[index].id);
            List<Note> list = await NoteHelper().getNotes();
            setState(() => noteList = list);
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text("Note deleted"),
                behavior: SnackBarBehavior.floating,
                elevation: 0.0,
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () async {
                    await NoteHelper().insert(noteBackup);
                    List<Note> list = await NoteHelper().getNotes();
                    setState(() => noteList = list);
                  },
                ),
              ),
            );
          },
          key: Key(noteList[index].id.toString()),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Visibility(
                      visible: appInfo.devShowIdLabels,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Text("Note id: " + noteList[index].id.toString()),
                      ),
                    ),
                    Visibility(
                      visible: noteList[index].title == "" ? false : true,
                      child: Container(
                        width: 110,
                        child:Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            noteList[index].title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 110,
                      child: Text(
                        noteList[index].content,
                        overflow: TextOverflow.ellipsis,
                        //maxLines: 5,
                        textWidthBasis: TextWidthBasis.parent,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                              .withAlpha(0.7)
                              .toColor()
                        ),
                      ),
                    ),
                  ],
                )
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).textTheme.title.color,
                    opacity: 0.5,
                  ),
                  child: IconButton(
                    icon: noteList[index].isStarred == 1 ? Icon(Icons.star) : Icon(Icons.star_border),
                    onPressed: isSelectorVisible ? null : () async {
                      if(noteList[index].isStarred == 0) {
                          await NoteHelper().update(
                            Note(
                              id: noteList[index].id,
                              title: noteList[index].title,
                              content: noteList[index].content,
                              isStarred: 1,
                            )
                          );
                          List<Note> list = await NoteHelper().getNotes();
                          setState(() => noteList = list);
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Note starred"),
                              behavior: SnackBarBehavior.floating,
                              elevation: 0.0,
                              action: SnackBarAction(
                              label: "Undo",
                              onPressed: () async {
                                await NoteHelper().update(Note(
                                  id: noteList[index].id,
                                  title: noteList[index].title,
                                  content: noteList[index].content,
                                  isStarred: 0,
                                ));
                                List<Note> list = await NoteHelper().getNotes();
                                setState(() => noteList = list);
                              },
                            ),
                          ),
                        );
                      } else if(noteList[index].isStarred == 1) {
                        await NoteHelper().update(
                          Note(
                            id: noteList[index].id,
                            title: noteList[index].title,
                            content: noteList[index].content,
                            isStarred: 0,
                          )
                        );
                        List<Note> list = await NoteHelper().getNotes();
                        setState(() => noteList = list);
                        scaffoldKey.currentState.showSnackBar(
                         SnackBar(
                            content: Text("Note unstarred"),
                            behavior: SnackBarBehavior.floating,
                            elevation: 0.0,
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () async {
                                await NoteHelper().update(Note(
                                  id: noteList[index].id,
                                  title: noteList[index].title,
                                  content: noteList[index].content,
                                  isStarred: 1,
                                ));
                                List<Note> list = await NoteHelper().getNotes();
                                setState(() => noteList = list);
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _bottomBar {
    final appInfo = Provider.of<AppInfoProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      child: Builder(
        builder: (context) {
          return BottomAppBar(
            color: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            shape: CircularNotchedRectangle(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      _showSettingsMenu(context);
                    },
                  ),
                  Spacer(),
                  IconButton(
                    icon: appInfo.isGridView ? Icon(Icons.list) : Icon(Icons.grid_on),
                    onPressed: () {
                      appInfo.isGridView = !appInfo.isGridView;
                    },
                  ),
                  Spacer(flex: 5),
                  IconButton(
                    icon: Icon(Icons.stars),
                    onPressed: () async {
                      List<Note> list = await NoteHelper().getFavouriteNotes();

                      _favouriteNotesCaller(context, list).then((returnList) => setState(() => noteList = returnList));
                    },
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.code),
                    onPressed: () => launchUrl("https://github.com/HrX03/PotatoNotes"),
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Future<void> _showSettingsMenu(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    return showModalBottomSheet<void>(
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 70),
              child: Text(
                "Themes",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.brightness_5),
              title: Text('App theme'),
              trailing: DropdownButton(
                value: appInfo.themeMode,
                items: <DropdownMenuItem>[
                  DropdownMenuItem(
                    child: Text("Light"),
                    value: 0,
                  ),
                  DropdownMenuItem(
                    child: Text("Dark"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("Black"),
                    value: 2,
                  ),
                ],
                onChanged: (newValue) {
                  appInfo.themeMode = newValue;
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              trailing: CircleColor(
                color: Theme.of(context).accentColor,
                circleSize: 30.0,
              ),
              title: Text('Accent color'),
              onTap: () => showDialog(
                context: context,
                builder: (context) {
                  Color currentColor = Theme.of(context).accentColor;
                  return AlertDialog(
                    title: Text("Accent color selector"),
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
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 70),
              child: Text(
                "Developer options",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                ),
              ),
            ),
            SwitchListTile(
              activeColor: Theme.of(context).accentColor,
              secondary: Icon(Icons.label),
              title: Text('Show id labels'),
              value: appInfo.devShowIdLabels,
              onChanged: (value) => appInfo.devShowIdLabels = value,
            ),
          ],
        );
      }
    );
  }
}