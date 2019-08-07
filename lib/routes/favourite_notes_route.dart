import 'package:flutter/material.dart';

import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/routes/modify_notes_route.dart';

import 'package:provider/provider.dart';

class FavouriteNotesRoute extends StatefulWidget {
  List<Note> noteList = List<Note>();
  FavouriteNotesRoute(List<Note> noteList) {
    this.noteList = noteList;
  }

  @override
  _FavouriteNotesState createState() => new _FavouriteNotesState(noteList);
}

class _FavouriteNotesState extends State<FavouriteNotesRoute> {
  List<Note> noteList = List<Note>();

  _FavouriteNotesState(List<Note> noteList) {
    this.noteList = noteList;
  }

  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<int> selectionList = List<int>();
  bool isSelectorVisible = false;

  @override
  Widget build(BuildContext context) {
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
                            await NoteHelper().delete(noteList[i].id);
                          selectionList = List<int>();
                          List<Note> list = await NoteHelper().getFavouriteNotes();
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
                    "Favourite notes",
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
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        child: Builder(
          builder: (context) {
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
                      icon: Icon(Icons.arrow_back),
                      onPressed: () async {
                        List<Note> list = await NoteHelper().getFavouriteNotes();
                        Navigator.pop(context, list);
                      },
                    ),
                    Spacer(flex: 5),
                  ],
                ),
              ),
            );
          }
        ),
      ),
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
            List<Note> list = await NoteHelper().getFavouriteNotes();
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
                    List<Note> list = await NoteHelper().getFavouriteNotes();
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
                          List<Note> list = await NoteHelper().getFavouriteNotes();
                          setState(() => noteList = list);
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Note starred"),
                              behavior: SnackBarBehavior.floating,
                              elevation: 0.0,
                              action: SnackBarAction(
                              label: "Undo",
                              onPressed: () async {
                                List<Note> list = await NoteHelper().getFavouriteNotes();
                                await NoteHelper().update(Note(
                                  id: list[index].id,
                                  title: list[index].title,
                                  content: list[index].content,
                                  isStarred: 0,
                                ));
                                list = await NoteHelper().getFavouriteNotes();
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
                        List<Note> list = await NoteHelper().getFavouriteNotes();
                        setState(() => noteList = list);
                        scaffoldKey.currentState.showSnackBar(
                         SnackBar(
                            content: Text("Note unstarred"),
                            behavior: SnackBarBehavior.floating,
                            elevation: 0.0,
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () async {
                                List<Note> list = await NoteHelper().getNotes();
                                await NoteHelper().update(Note(
                                  id: list[index].id,
                                  title: list[index].title,
                                  content: list[index].content,
                                  isStarred: 1,
                                ));
                                list = await NoteHelper().getFavouriteNotes();
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

  void _editNoteCaller(BuildContext context, Note note) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyNotesRoute(note)));

    if (result != null) setState(() => noteList = result);
  }
}