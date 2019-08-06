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
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                int bIndex = (noteList.length - 1) - index; 
                return _noteListItem(context, bIndex);
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

  void _addNoteCaller(BuildContext context) async {
    final Note emptyNote = Note(id: null, title: "", content: "");
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyNotesRoute(emptyNote)));

    if (result != null) setState(() => noteList = result);
  }

  void _editNoteCaller(BuildContext context, Note note) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyNotesRoute(note)));

    if (result != null) setState(() => noteList = result);
  }

  Widget _noteListItem(BuildContext context, int index) {
    Color borderCardColor = HSLColor.fromColor(Theme.of(context).textTheme.title.color)
        .withAlpha(0.2)
        .toColor();
    
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
          direction: isSelectorVisible ? null : DismissDirection.startToEnd,
          background: Container(
            padding: EdgeInsets.only(left: 30),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.delete),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Delete note",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onDismissed: (direction) async {
            Note noteBackup = Note(
              id: noteList[index].id,
            title: noteList[index].title,
              content: noteList[index].content,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          noteList[index].title,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      noteList[index].content,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                            .withAlpha(0.7)
                            .toColor()
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _bottomBar {
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
                  Spacer(flex: 3),
                  IconButton(
                    icon: new Icon(Icons.code),
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
            SwitchListTile(
              activeColor: Theme.of(context).accentColor,
              secondary: Icon(Icons.brightness_5),
              title: Text('Dark theme'),
              value: appInfo.isDark,
              onChanged: (value) => appInfo.isDark = value,
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