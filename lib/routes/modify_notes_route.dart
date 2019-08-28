import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'package:potato_notes/internal/note_helper.dart';

import 'package:back_button_interceptor/back_button_interceptor.dart';

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
  int noteIsStarred = 0;
  int noteDate = 0;
  int noteColor;

  _ModifyNotesState(Note note) {
    this.noteId = note.id;
    this.noteTitle = note.title;
    this.noteContent = note.content;
    this.noteIsStarred = note.isStarred;
    this.noteDate = note.date;
    this.noteColor = note.color;
  }

  NoteHelper noteHelper = new NoteHelper();
  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(saveAndPop);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(saveAndPop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: noteTitle);
    TextEditingController contentController = TextEditingController(text: noteContent);

    titleController.selection = TextSelection.collapsed(offset: noteTitle.length);
    contentController.selection = TextSelection.collapsed(offset: noteContent.length);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
              height: 70,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        saveAndPop(true);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Center(
                        child: Text(
                          noteId == null ? "Add new note" : "Update note",
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 70, left: 20, right: 20),
            child: ListView(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Title', border: InputBorder.none),
                  onChanged: (text) {
                    noteTitle = text;
                  },
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(hintText: 'Content', border: InputBorder.none),
                  onChanged: (text) {
                    noteContent = text;
                  },
                  maxLines: 32,
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        child: Builder(
          builder: (context) {
            Color noNoteCircleColor = HSLColor.fromColor(Theme.of(context).textTheme.title.color)
              .withAlpha(0.4)
              .toColor();
            
            List<ColorSwatch<dynamic>> colors = <ColorSwatch>[
              Colors.red,
              Colors.pink,
              Colors.purple,
              Colors.deepPurple,
              Colors.indigo,
              Colors.blue,
              Colors.lightBlue,
              Colors.cyan,
              Colors.teal,
              Colors.green,
              Colors.lightGreen,
              Colors.lime,
              Colors.yellow,
              Colors.amber,
              Colors.orange,
              Colors.deepOrange,
              Colors.brown,
              Colors.grey,
              Colors.blueGrey,
              MaterialColor(0x00000000, {500: Colors.transparent}),
            ];

            return BottomAppBar(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: CircularNotchedRectangle(),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    IconButton(
                      icon: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: noteColor == null ? noNoteCircleColor : Color(noteColor),
                        ),
                        width: 32.0,
                        height: 32.0,
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          Color currentColor = noteColor == null ? Colors.transparent : Color(noteColor);
                          return AlertDialog(
                            title: Text("Note color selector"),
                            content: MaterialColorPicker(
                              colors: colors,
                              allowShades: false,
                              circleSize: 70.0,
                              onMainColorChange: (color) {
                                currentColor = color;
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
                                  if(currentColor.toString() == "MaterialColor(primary value: Color(0x00000000))"
                                      || currentColor.toString() == "Color(0x00000000)") {
                                    setState(() => noteColor = null);
                                  } else {
                                    setState(() => noteColor = currentColor.value);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Future<int> noteIdSearcher() async {
    List<Note> noteList = await NoteHelper().getNotes();
    List<int> noteIdList = List<int>();
    
    noteList.forEach((item) {
      noteIdList.add(item.id);
    });

    if(noteIdList.length > 0) {
      return noteIdList[noteIdList.length - 1] + 1;
    } else return 1;
  }

  bool saveAndPop(bool stopDefaultButtonEvent) {
    if (noteContent != "") {
      asyncExecutor();
    } else {
      Navigator.pop(context);
    }
    return true;
  }

  void asyncExecutor() async {
    List<Note> noteList = await noteHelper.getNotes();
    int id = noteId == null ? await noteIdSearcher() : noteId;
    noteDate = DateTime.now().millisecondsSinceEpoch;

    await noteHelper.insert(Note(
      id: id,
      title: noteTitle,
      content: noteContent,
      isStarred: noteIsStarred,
      date: noteDate,
      color: noteColor,
    ));
    noteList = await noteHelper.getNotes();
    Navigator.pop(context, noteList);
  }
}