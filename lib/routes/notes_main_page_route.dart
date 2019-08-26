import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/methods.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/internal/search_filters.dart';
import 'package:potato_notes/routes/easteregg_route.dart';
import 'package:potato_notes/routes/modify_notes_route.dart';
import 'package:potato_notes/routes/search_notes_route.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

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

  AppInfoProvider appInfo;

  @override
  void initState() {
    super.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher_fg');
    IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    InitializationSettings initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS
    );

    Future onNotificationClicked(String payload) async {
      await FlutterLocalNotificationsPlugin().cancel(int.parse(payload));
      appInfo.notificationsIdList.remove(payload);
    } 

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onNotificationClicked);

    initializeNotifications();
  }

  void initializeNotifications() async {
    final appInfo = Provider.of<AppInfoProvider>(context);

    for(int i = 0; i < appInfo.notificationsIdList.length; i++) {
      int index = int.parse(appInfo.notificationsIdList[i]);
      await FlutterLocalNotificationsPlugin().show(
        index, noteList[index].title != "" ? noteList[index].title : "Pinned note",
        noteList[index].content, NotificationDetails(
          AndroidNotificationDetails(
            '0', 'note_pinned_notifications', 'idk',
            priority: Priority.High, playSound: true, importance: Importance.High,
            ongoing: true,
          ),
          IOSNotificationDetails()
        ), payload: index.toString()
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    appInfo = Provider.of<AppInfoProvider>(context);
    
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
              padding: EdgeInsets.only(left: isSelectorVisible ? 10 : 20, right: 10),
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
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          selectionList.length.toString(),
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
                Row(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Notes",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.select_all),
                      onPressed: () {
                        setState(() => isSelectorVisible = true);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => _searchNoteCaller(context, noteList),
                    ),
                    IconButton(
                      iconSize: 24.0,
                      onPressed: () => showUserSettingsScrollableBottomSheet(context),
                      icon: CircleAvatar(
                        backgroundColor: appInfo.mainColor,
                        child: appInfo.userImagePath == null ?
                          Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 28.0,
                          ) :
                          null,
                        backgroundImage: appInfo.userImagePath == null ? 
                          null:
                          FileImage(File(appInfo.userImagePath)),
                      ),
                    ),
                  ],
                ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 94.0),
            child: noteList.length == 0 ?
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.close,
                      size: 50.0,
                      color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                          .withAlpha(0.4)
                          .toColor()
                    ),
                    Text(
                      "No notes added... yet",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                          .withAlpha(0.4)
                          .toColor(),
                      ),
                    ),
                  ],
                ),
              ) :
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: noteListBuilder(context),
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
        child: Icon(Icons.edit),
        tooltip: "Add new note",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomBar,
    );
  }

  List<Widget> noteListBuilder(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    if(!appInfo.isGridView) {
      List<Widget> pinnedNotes = List<Widget>();
      List<Widget> normalNotes = List<Widget>();

      pinnedNotes.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.star,
                size: 12.0,
                color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                  .withAlpha(0.4)
                  .toColor(),
              ),
              Text(
                "  Starred notes",
                style: TextStyle(
                  fontSize: 14.0,
                  color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                    .withAlpha(0.4)
                    .toColor()
                ),
              ),
            ],
          )
        ),  
      );

      for(int i = 0; i < noteList.length; i++) {
        int bIndex = (noteList.length - 1) - i;
        if(noteList[bIndex].isStarred == 1) {
          pinnedNotes.add(
            noteListItem(context, bIndex, false)
          );
        }
      }

      for(int i = 0; i < noteList.length; i++) {
        int bIndex = (noteList.length - 1) - i;
        if(noteList[bIndex].isStarred == 0) {
          normalNotes.add(
            noteListItem(context, bIndex, false)
          );
        }
      }

      pinnedNotes.add(
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 100, right: 100),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                .withAlpha(0.2)
                .toColor(),
            ),
            width: MediaQuery.of(context).size.width - 200,
            height: 2,
          ),
        ),
      );

      return <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            pinnedNotes.length > 2 ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: pinnedNotes,
              ) :
              Container(),
            normalNotes.length > 0 ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: normalNotes,
              ) :
              Container(),
          ],
        ),
      ];
    } else {
      List<int> pinnedIndexes = List<int>();
      List<int> normalIndexes = List<int>();
      List<Widget> pinnedWidgets = List<Widget>();
      List<Widget> normalWidgets = List<Widget>();

      pinnedWidgets.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.star,
                size: 12.0,
                color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                  .withAlpha(0.4)
                  .toColor(),
              ),
              Text(
                "  Starred notes",
                style: TextStyle(
                  fontSize: 14.0,
                  color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                    .withAlpha(0.4)
                    .toColor()
                ),
              ),
            ],
          )
        ),  
      );

      for(int i = 0; i < noteList.length; i++) {
        if(noteList[i].isStarred == 1) {
          pinnedIndexes.add(i);
        }
      }

      for(int i = 0; i < noteList.length; i++) {
        if(noteList[i].isStarred == 0) {
          normalIndexes.add(i);
        }
      }

      Widget pinnedGrid = noteGridBuilder(context, pinnedIndexes);
      Widget normalGrid = noteGridBuilder(context, normalIndexes);

      if(pinnedGrid != null)
        pinnedWidgets.add(pinnedGrid);
      
      if(normalGrid != null)
        normalWidgets.add(normalGrid);

      pinnedWidgets.add(
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 100, right: 100),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                .withAlpha(0.2)
                .toColor(),
            ),
            width: MediaQuery.of(context).size.width - 200,
            height: 2,
          ),
        ),
      );

      return <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            pinnedWidgets.length > 2 ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: pinnedWidgets,
              ) :
              Container(),
            normalWidgets.length > 0 ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: normalWidgets,
              ) :
              Container(),
          ],
        ),
      ];
    }
  }

  Widget noteGridBuilder(BuildContext context, List<int> indexes) {
    List<Widget> columnOne = List<Widget>();
    List<Widget> columnTwo = List<Widget>();

    bool secondColumnFirst = false;
    
    if((indexes.length - 1).isEven) {
      secondColumnFirst = false;
    } else {
      secondColumnFirst = true;
    }

    for(int i = 0; i < indexes.length; i++) {
      int bIndex = (indexes.length - 1) - i;
      if(bIndex.isEven) {
        columnOne.add(noteListItem(context, indexes[bIndex], true));
      } else {
        columnTwo.add(noteListItem(context, indexes[bIndex], true));
      }
    }

    if(indexes.length > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width/2-20,
            child: Column(
              children: secondColumnFirst ? columnTwo : columnOne,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width/2-20,
            child: Column(
              children: secondColumnFirst ? columnOne : columnTwo,
            ),
          ),
        ],
      );
    } else return null;
  }

  void _addNoteCaller(BuildContext context) async {
    final Note emptyNote = Note(id: null, title: "", content: "", isStarred: 0, date: 0, color: null);
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyNotesRoute(emptyNote)));

    if (result != null) setState(() => noteList = result);
  }

  void _editNoteCaller(BuildContext context, Note note) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyNotesRoute(note)));

    if (result != null) setState(() => noteList = result);
  }

  void _searchNoteCaller(BuildContext context, List<Note> noteList) async {
    SearchFiltersProvider searchFilters = Provider.of<SearchFiltersProvider>(context);

    searchFilters.color = null;
    searchFilters.date = null;
    searchFilters.caseSensitive = false;
    
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchNotesRoute(noteList)));

    if (result != null) setState(() => noteList = result);
  }

  Widget noteListItem(BuildContext context, int index, bool oneSideOnly) {
    final appInfo = Provider.of<AppInfoProvider>(context);
    
    double getAlphaFromTheme() {
      if(appInfo.themeMode == 0) {
        return 0.1;
      } else if (appInfo.themeMode == 1) {
        return 0.2;
      } else if (appInfo.themeMode == 2) {
        return 0.3;
      }
    }

    Color cardColor = Theme.of(context).textTheme.title.color;

    double cardBrightness = getAlphaFromTheme();
    
    Color borderColor = HSLColor.fromColor(cardColor)
        .withAlpha(cardBrightness)
        .toColor();
    
    Color getTextColorFromNoteColor(int index, bool isContent) {
      double noteColorBrightness = Color(noteList[index].color).computeLuminance();
      Color contentWhite = HSLColor.fromColor(Colors.white)
        .withAlpha(0.7)
        .toColor();
      Color contentBlack = HSLColor.fromColor(Colors.black)
        .withAlpha(0.7)
        .toColor();
      
      if(noteColorBrightness > 0.5) {
        return isContent ? contentBlack : Colors.black;
      } else {
        return isContent ? contentWhite : Colors.white;
      }
    }
    
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
      onDoubleTap: isSelectorVisible ?
          null :
          appInfo.isQuickStarredGestureOn ?
            () => toggleStarNote(index) :
            null,
      onLongPress: () {
        if(!isSelectorVisible)
          showNoteSettingsScrollableBottomSheet(context, index);
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: noteList[index].isSelected ? Theme.of(context).accentColor : noteList[index].color != null ? Colors.transparent : borderColor, width: 1.5),
        ),
        color: noteList[index].color == null ? Theme.of(context).cardColor : Color(noteList[index].color),
        child:  Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Visibility(
                    visible: appInfo.devShowIdLabels,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        "Note id: " + noteList[index].id.toString(),
                        style: TextStyle(
                          color: noteList[index].color == null ? null : getTextColorFromNoteColor(index, false),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: noteList[index].title == "" ? false : true,
                    child: Container(
                      width: noteList[index].isStarred == 1 ?
                        oneSideOnly ? 
                          MediaQuery.of(context).size.width/2-88 :
                          MediaQuery.of(context).size.width-108 :
                        oneSideOnly ?
                          MediaQuery.of(context).size.width/2-74 :
                          MediaQuery.of(context).size.width-94,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          noteList[index].title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: TextStyle(
                            color: noteList[index].color == null ? null : getTextColorFromNoteColor(index, false),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: noteList[index].isStarred == 1 ?
                      oneSideOnly ? 
                        MediaQuery.of(context).size.width/2-88 :
                        MediaQuery.of(context).size.width-108 :
                      oneSideOnly ?
                        MediaQuery.of(context).size.width/2-74 :
                        MediaQuery.of(context).size.width-94,
                    child: Text(
                      noteList[index].content,
                      overflow: TextOverflow.ellipsis,
                      textWidthBasis: TextWidthBasis.parent,
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: noteList[index].color == null ?
                            Theme.of(context).textTheme.title.color :
                            getTextColorFromNoteColor(index, true),
                      ),
                    ),
                  ),
                ],
              )
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top: 6, right: 6),
              child: Visibility(
                visible: noteList[index].isStarred == 1,
                child: Icon(
                  Icons.star,
                  size: 14,
                  color: noteList[index].color == null ? null : HSLColor.fromColor(getTextColorFromNoteColor(index, false))
                    .withAlpha(0.4)
                    .toColor(),
                ),
              )
            ),
          ],
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
                      showSettingsScrollableBottomSheet(context);
                    },
                  ),
                  Spacer(flex: 3),
                  IconButton(
                    icon: appInfo.isGridView ? Icon(Icons.list) : Icon(Icons.grid_on),
                    onPressed: () {
                      appInfo.isGridView = !appInfo.isGridView;
                    },
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

  void showAboutDialog() {
    final appInfo = Provider.of<AppInfoProvider>(context);
    int easterEggCounter = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: EdgeInsets.fromLTRB(8, 24, 8, 10),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  onTap: () {
                    if(easterEggCounter == 9) {
                      easterEggCounter = 0;
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EasterEggRoute()));
                    } else easterEggCounter++;
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                      fit: BoxFit.fill,
                        image: AssetImage('assets/notes_round.png'),
                      ),
                    )
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "PotatoNotes",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 29, right: 29),
                child: Text("Developed and mantained by HrX03"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 29, right: 29),
                child: Text("App icon, design and app branding by RshBfn")
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 30, 24, 4),
                child: Row(
                  children: <Widget>[
                    Text(
                      "PotatoProject 2019",
                      style: TextStyle(
                        color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                            .withAlpha(0.5)
                            .toColor(),
                        fontSize: 14
                      ),
                    ),
                    Spacer(),
                    Text(
                      "v0.3.0-2",
                      style: TextStyle(
                        color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                            .withAlpha(0.5)
                            .toColor(),
                        fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.pop(context),
                    textColor: appInfo.mainColor,
                    hoverColor: appInfo.mainColor,
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  void toggleStarNote(int index) async {
    if(noteList[index].isStarred == 0) {
      await NoteHelper().update(
        Note(
          id: noteList[index].id,
          title: noteList[index].title,
          content: noteList[index].content,
          isStarred: 1,
          date: noteList[index].date,
          color: noteList[index].color,
        )
      );
      List<Note> list = await NoteHelper().getNotes();
      setState(() => noteList = list);
    } else if(noteList[index].isStarred == 1) {
      await NoteHelper().update(
        Note(
          id: noteList[index].id,
          title: noteList[index].title,
          content: noteList[index].content,
          isStarred: 0,
          date: noteList[index].date,
          color: noteList[index].color,
        )
      );
      List<Note> list = await NoteHelper().getNotes();
      setState(() => noteList = list);
    }
  }

  void showSettingsScrollableBottomSheet(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 68),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                        underline: Container(),
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
                        circleSize: 24.0,
                        elevation: 0,
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
                                textColor: appInfo.mainColor,
                                hoverColor: appInfo.mainColor,
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
                                textColor: appInfo.mainColor,
                                hoverColor: appInfo.mainColor,
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 70),
                      child: Text(
                        "Gestures",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    SwitchListTile(
                      activeColor: Theme.of(context).accentColor,
                      secondary: Icon(Icons.star),
                      title: Text('Quick starred gesture'),
                      subtitle: Text("If enabled, you can just double tap on a note to star it"),
                      value: appInfo.isQuickStarredGestureOn,
                      onChanged: (value) => appInfo.isQuickStarredGestureOn = value,
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
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 70),
                      child: Text(
                        "About",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text("About PotatoNotes"),
                      onTap: () => showAboutDialog(),
                    ),
                    ListTile(
                      leading: Icon(Icons.code),
                      title: Text("PotatoNotes source code"),
                      onTap: () => launchUrl("https://github.com/HrX03/PotatoNotes"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  void showUserSettingsScrollableBottomSheet(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        TextEditingController userNameController = TextEditingController(text: appInfo.userName);

        return Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "User info",
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 68),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              image: appInfo.userImagePath == null ?
                                null :
                                DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(appInfo.userImagePath)),
                                ),
                              borderRadius: BorderRadius.all(Radius.circular(150)),
                              color: appInfo.mainColor,
                            ),
                            child: appInfo.userImagePath == null ?
                              Center(
                                child: Icon(
                                  Icons.account_circle,
                                  size: 145,
                                  color: Colors.white,
                                ),
                              ) :
                              null,
                          ),
                        ),
                        onTap: () async {
                          File image = await ImagePicker.pickImage(source: ImageSource.gallery);
                          if(image != null)
                            appInfo.userImagePath = image.path;
                        },
                        borderRadius: BorderRadius.all(Radius.circular(150)),
                      ),
                    ),
                    Center(
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                          child: Text(
                            appInfo.userName,
                              style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            double getAlphaFromTheme() {
                              if(appInfo.themeMode == 0) {
                                return 0.1;
                              } else if (appInfo.themeMode == 1) {
                                return 0.2;
                              } else if (appInfo.themeMode == 2) {
                                return 0.3;
                              }
                            }

                            String currentName = appInfo.userName;
                            Color cardColor = Theme.of(context).textTheme.title.color;

                            double cardBrightness = getAlphaFromTheme();

                            Color borderColor = HSLColor.fromColor(cardColor)
                                .withAlpha(cardBrightness)
                                .toColor();
                            return AlertDialog(
                              title: Text("Change username"),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                              ),
                              content: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(color:  borderColor, width: 1.5),
                                ),
                                color: Theme.of(context).cardColor,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                  child: TextField(
                                    controller: userNameController,
                                    onChanged: (value) => currentName = value,
                                    maxLines: 1,
                                    decoration: InputDecoration(border: InputBorder.none),
                                  ),
                                )
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                  textColor: appInfo.mainColor,
                                  hoverColor: appInfo.mainColor,
                                ),
                                FlatButton(
                                  child: Text("Done"),
                                  onPressed: () {
                                    appInfo.userName = currentName;
                                    Navigator.pop(context);
                                  },
                                  textColor: appInfo.mainColor,
                                  hoverColor: appInfo.mainColor,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Visibility(
                            visible: appInfo.userName != "User",
                            child: FlatButton(
                              child: Text("Remove username"),
                              onPressed: () {
                                appInfo.userName = "User";
                                userNameController.text = appInfo.userName;
                              },
                              textColor: appInfo.mainColor,
                              hoverColor: appInfo.mainColor,
                            ),
                          ),
                          Visibility(
                            visible: appInfo.userName != "User" && appInfo.userImagePath != null,
                            child: Text("|"),
                          ),
                          Visibility(
                            visible: appInfo.userImagePath != null,
                            child: FlatButton(
                              child: Text("Remove image"),
                              onPressed: () => appInfo.userImagePath = null,
                              textColor: appInfo.mainColor,
                              hoverColor: appInfo.mainColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  void showNoteSettingsScrollableBottomSheet(BuildContext context, int index) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        bool noteStarred;

        try{
          noteStarred = noteList[index].isStarred == 1;
        } on RangeError {
          noteStarred = noteList[index -1].isStarred == 1;
        }

        return SingleChildScrollView(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.check),
                title: Text("Select note"),
                onTap: () {
                  setState(() {
                    isSelectorVisible = true;
                    noteList[index].isSelected = true;
                    selectionList.add(noteList[index].id);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Edit note"),
                onTap: () {
                  Navigator.pop(context);
                  _editNoteCaller(context, noteList[index]);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete note"),
                onTap: () async {
                  Navigator.pop(context);
                  Note noteBackup = Note(
                    id: noteList[index].id,
                    title: noteList[index].title,
                    content: noteList[index].content,
                    isStarred: noteList[index].isStarred,
                    date: noteList[index].date,
                    color: noteList[index].color,
                  );
                  await NoteHelper().delete(noteList[index].id);
                  List<Note> list = await NoteHelper().getNotes();
                  setState(() => noteList = list);
                  scaffoldKey.currentState.removeCurrentSnackBar();
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
              ),
              ListTile(
                leading: Icon(
                  noteStarred ?
                    Icons.star :
                    Icons.star_border
                ),
                title: Text(
                  noteStarred ?
                    "Unstar note" :
                    "Star note"
                ),
                onTap: () async {
                  if(noteStarred) {
                    await NoteHelper().update(
                      Note(
                        id: noteList[index].id,
                        title: noteList[index].title,
                        content: noteList[index].content,
                        isStarred: 0,
                        date: noteList[index].date,
                        color: noteList[index].color,
                      ),
                    );
                    List<Note> list = await NoteHelper().getNotes();
                    setState(() => noteList = list);
                  } else {
                    await NoteHelper().update(
                      Note(
                        id: noteList[index].id,
                        title: noteList[index].title,
                        content: noteList[index].content,
                        isStarred: 1,
                        date: noteList[index].date,
                        color: noteList[index].color,
                      ),
                    );
                    List<Note> list = await NoteHelper().getNotes();
                    setState(() => noteList = list);
                  }
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.share),
                title: Text("Share note"),
                onTap: () {
                  String shareText = "";

                  if(noteList[index].title != "")
                    shareText += noteList[index].title + "\n\n";
                  shareText += noteList[index].content;

                  Share.share(shareText);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_upload),
                title: Text("Export note"),
                onTap: () async {
                  if(appInfo.storageStatus == PermissionStatus.granted) {
                    DateTime now = DateTime.now();
 
                    bool backupDirExists = await Directory('/storage/emulated/0/PotatoNotes/exported').exists();

                    if(!backupDirExists) {
                      await Directory('/storage/emulated/0/PotatoNotes/exported').create(recursive: true);
                    }

                    String noteExportPath =
                      '/storage/emulated/0/PotatoNotes/exported/exported_note_' + DateFormat("dd-MM-yyyy_HH-mm").format(now) + '.md';

                    String noteContents = "";

                    if(noteList[index].title != "")
                      noteContents += "# " + noteList[index].title + "\n\n";
                    
                    noteContents += noteList[index].content;

                    Navigator.pop(context);

                    File(noteExportPath).writeAsString(noteContents).then((nothing) {
                      scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text("Note exported at PotatoNotes/exported/exported_note_" +
                              DateFormat("dd-MM-yyyy_HH-mm-ss").format(now)),
                        )
                      );
                    });

                  } else {
                    Map<PermissionGroup, PermissionStatus> permissions =
                      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
                    print(permissions.entries);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                enabled: !appInfo.notificationsIdList.contains(index.toString()),
                title: Text("Pin note to notifications"),
                onTap: () async {
                  appInfo.notificationsIdList.add(index.toString());
                  await FlutterLocalNotificationsPlugin().show(
                    int.parse(appInfo.notificationsIdList.last), noteList[index].title != "" ? noteList[index].title : "Pinned note",
                    noteList[index].content, NotificationDetails(
                      AndroidNotificationDetails(
                        '0', 'note_pinned_notifications', 'idk',
                        priority: Priority.High, playSound: true, importance: Importance.High,
                        ongoing: true,
                      ),
                      IOSNotificationDetails()
                    ), payload: index.toString()
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    );
  }
}