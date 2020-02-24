import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/ui/note_color_selector.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:simple_animations/simple_animations.dart';

List<int> reminderList = List<int>();

class ModifyNotesRoute extends StatefulWidget {
  final Note note;
  final String heroIndex;
  final bool autofocus;

  ModifyNotesRoute(
      {@required this.note, @required this.heroIndex, this.autofocus = false});

  @override
  _ModifyNotesState createState() => new _ModifyNotesState(note);
}

class _ModifyNotesState extends State<ModifyNotesRoute>
    with SingleTickerProviderStateMixin {
  int noteId;
  String noteTitle = "";
  String noteContent = "";
  int noteIsStarred = 0;
  int noteDate = 0;
  int noteColor = 0;
  String noteImagePath;
  int noteIsList = 0;
  String noteListParseString;
  String noteReminders;
  int noteHideContent = 0;
  String notePin;
  String notePassword;
  int noteIsDeleted = 0;
  int noteIsArchived = 0;

  _ModifyNotesState(Note note) {
    this.noteId = note.id;
    this.noteTitle = note.title;
    this.noteContent = note.content;
    this.noteIsStarred = note.isStarred ?? 0;
    this.noteDate = note.date;
    this.noteColor = note.color ?? 0;
    this.noteImagePath = note.imagePath;
    this.noteIsList = note.isList ?? 0;
    this.noteListParseString = note.listParseString;
    this.noteReminders = note.reminders;
    this.noteHideContent = note.hideContent ?? 0;
    this.notePin = note.pin;
    this.notePassword = note.password;
    this.noteIsDeleted = note.isDeleted ?? 0;
    this.noteIsArchived = note.isArchived ?? 0;
  }

  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ListPair> checkList = List<ListPair>();

  TextEditingController entryTextController = TextEditingController(text: "");
  List<TextEditingController> textControllers = List<TextEditingController>();

  TextEditingController titleController;
  TextEditingController contentController;

  AnimationController _controller;

  AppLocalizations locales;

  bool firstRun = true;
  Brightness systemBarsIconBrightness;

  FocusNode contentNode = FocusNode();

  bool showLoadingIcon = false;

  void noteIdInit() async {
    noteId = noteId == null ? await noteIdSearcher() : noteId;
  }

  void reminderListPopulater() {
    reminderList.clear();
    if (noteReminders != null) {
      List<String> reminderListString = noteReminders.split(":");
      reminderListString.forEach((item) {
        String milliseconds = item != "" ? item : null;
        if (milliseconds != null) {
          reminderList.add(int.parse(milliseconds));
        }
      });
      noteReminders = reminderList.join(":");
    }
  }

  void noteRemindersUpdater() {
    noteReminders = reminderList.join(":");
  }

  Brightness getBarsColorFromNoteColor() {
    double noteColorBrightness =
        Color(NoteColors.colorList(context)[noteColor ?? 0]["hex"])
            .computeLuminance();

    if (noteColorBrightness > 0.5) {
      return Brightness.dark;
    } else {
      return Brightness.light;
    }
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: noteTitle);
    contentController = TextEditingController(text: noteContent);
    BackButtonInterceptor.add(saveAndPop);
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    reminderList.clear();
    noteIdInit();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(saveAndPop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    locales = AppLocalizations.of(context);

    reminderListPopulater();

    systemBarsIconBrightness = Theme.of(context).brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    Color getElementsColorBasedOnThemeContext() {
      Color colorToReturn;
      if ((noteColor ?? 0) == 0) {
        Theme.of(context).brightness == Brightness.dark
            ? colorToReturn = Colors.white
            : colorToReturn = Colors.black;
      } else {
        double noteColorBrightness =
            Color(NoteColors.colorList(context)[noteColor ?? 0]["hex"])
                .computeLuminance();

        if (noteColorBrightness > 0.5) {
          colorToReturn = Colors.black;
        } else {
          colorToReturn = Colors.white;
        }
      }

      return colorToReturn;
    }

    final appInfo = Provider.of<AppInfoProvider>(context);

    Utils.changeSystemBarsColors(
        (noteColor ?? 0) == 0
            ? Theme.of(context).scaffoldBackgroundColor
            : Color(NoteColors.colorList(context)[noteColor ?? 0]["hex"]),
        (noteColor ?? 0) == 0
            ? systemBarsIconBrightness
            : getBarsColorFromNoteColor());

    if (firstRun) {
      if (widget.autofocus) FocusScope.of(context).requestFocus(contentNode);

      firstRun = false;
    }

    return Hero(
      tag: "note" + widget.heroIndex,
      child: Theme(
        data: Theme.of(context).copyWith(
          iconTheme:
              IconThemeData(color: getElementsColorBasedOnThemeContext()),
          textTheme: TextTheme(
            subtitle1: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: getElementsColorBasedOnThemeContext(),
                ),
          ),
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                hintStyle: TextStyle(
                  color:
                      HSLColor.fromColor(getElementsColorBasedOnThemeContext())
                          .withAlpha(0.5)
                          .toColor(),
                ),
              ),
          unselectedWidgetColor:
              HSLColor.fromColor(getElementsColorBasedOnThemeContext())
                  .withAlpha(0.5)
                  .toColor(),
          scaffoldBackgroundColor: (noteColor ?? 0) == 0
              ? Theme.of(context).cardColor
              : Color(NoteColors.colorList(context)[noteColor ?? 0]["hex"]),
          accentColor: getElementsColorBasedOnThemeContext(),
          dividerColor:
              HSLColor.fromColor(getElementsColorBasedOnThemeContext())
                  .withAlpha(0.12)
                  .toColor(),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: (noteColor ?? 0) == 0
                ? Theme.of(context).cardColor
                : Color(NoteColors.colorList(context)[noteColor ?? 0]["hex"]),
          ),
          buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.accent, hoverColor: appInfo.mainColor),
          popupMenuTheme: PopupMenuThemeData(
            color: (noteColor ?? 0) == 0
                ? Theme.of(context).cardColor
                : Color(NoteColors.colorList(context)[noteColor ?? 0]["hex"]),
          ),
        ),
        child: Scaffold(
          key: scaffoldKey,
          body: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top, bottom: 60),
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    Visibility(
                      visible: noteImagePath != null,
                      child: noteImagePath == null
                          ? Container()
                          : Semantics(
                              label: locales.semantics_modifyNotes_image,
                              child: CachedNetworkImage(
                                imageUrl: noteImagePath,
                                fit: BoxFit.fill,
                                fadeInDuration: Duration(milliseconds: 0),
                                fadeOutDuration: Duration(milliseconds: 0),
                                placeholder: (context, url) {
                                  return ControlledAnimation(
                                    playback: Playback.MIRROR,
                                    tween: Tween<double>(begin: 0.2, end: 1),
                                    duration: Duration(milliseconds: 400),
                                    builder: (context, animation) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 30),
                                        child: Opacity(
                                          opacity: animation,
                                          child: Icon(
                                            OMIcons.image,
                                            size: 56,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                            hintText: locales.modifyNotesRoute_title,
                            border: InputBorder.none),
                        onChanged: (text) {
                          noteTitle = text;
                        },
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: noteIsList == 1,
                      child: Column(
                        children: checkListBuilder(),
                      ),
                    ),
                    Visibility(
                      visible: reminderList.length > 0,
                      child: Column(
                        children: reminderListBuilder(),
                      ),
                    ),
                    Visibility(
                      visible: noteIsList == 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: contentController,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          focusNode: contentNode,
                          decoration: InputDecoration(
                              hintText: locales.modifyNotesRoute_content,
                              border: InputBorder.none),
                          onChanged: (text) {
                            noteContent = text;
                          },
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: noteImagePath != null
                              ? noteContent.split("\n").length
                              : 32,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  color: (noteColor ?? 0) == 0
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Color(
                          NoteColors.colorList(context)[noteColor ?? 0]["hex"]),
                  child: Container(
                    height: 60,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            tooltip: locales.semantics_back,
                            onPressed: () {
                              saveAndPop(true);
                            },
                          ),
                          Spacer(),
                          Visibility(
                            visible: showLoadingIcon,
                            child: Container(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(noteHideContent == 1 &&
                                    (notePin != null || notePassword != null)
                                ? OMIcons.lock
                                : OMIcons.removeRedEye),
                            tooltip: locales.semantics_modifyNotes_security,
                            onPressed: () {
                              appInfo.hideContent = noteHideContent;
                              appInfo.useProtectionForNoteContent =
                                  notePin != null || notePassword != null;
                              appInfo.pin = notePin != null;
                              appInfo.password = notePassword != null;
                              showHideContentScrollableBottomSheet(
                                  context,
                                  (noteColor ?? 0) == 0
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : Color(NoteColors.colorList(
                                          context)[noteColor ?? 0]["hex"]),
                                  getElementsColorBasedOnThemeContext());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            tooltip: "Add element",
                            onPressed: () {
                              showAddElementScrollableBottomSheet(
                                  context,
                                  (noteColor ?? 0) == 0
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : Color(NoteColors.colorList(
                                          context)[noteColor ?? 0]["hex"]),
                                  getElementsColorBasedOnThemeContext());
                            },
                          ),
                          IconButton(
                            icon: noteIsStarred == 0
                                ? Icon(Icons.star_border)
                                : Icon(Icons.star),
                            tooltip: noteIsStarred == 0
                                ? locales.semantics_modifyNotes_star
                                : locales.semantics_modifyNotes_unstar,
                            onPressed: () {
                              if (noteIsStarred == 0) {
                                setState(() => noteIsStarred = 1);
                              } else if (noteIsStarred == 1) {
                                setState(() => noteIsStarred = 0);
                              }
                            },
                          ),
                          noteIsList == 0
                              ? PopupMenuButton(
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context) {
                                    return <PopupMenuEntry>[
                                      PopupMenuItem(
                                        child: ListTile(
                                          title: Text(locales
                                              .modifyNotesRoute_color_change),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            int result = await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return NoteColorDialog(
                                                    noteColor: noteColor,
                                                  );
                                                });

                                            setState(() {
                                              if (result != null)
                                                noteColor = result;
                                            });
                                          },
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: ListTile(
                                          title: Text(locales.note_share),
                                          onTap: () {
                                            Navigator.pop(context);
                                            String shareText = "";
                                            if (noteTitle != "")
                                              shareText += noteTitle + "\n\n";
                                            shareText += noteContent;
                                            Share.share(shareText);
                                          },
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: ListTile(
                                          title: Text(locales.note_export),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            if (appInfo.storageStatus ==
                                                PermissionStatus.granted) {
                                              DateTime now = DateTime.now();

                                              bool backupDirExists =
                                                  await Directory(
                                                          '/storage/emulated/0/PotatoNotes/exported')
                                                      .exists();

                                              if (!backupDirExists) {
                                                await Directory(
                                                        '/storage/emulated/0/PotatoNotes/exported')
                                                    .create(recursive: true);
                                              }

                                              String noteExportPath =
                                                  '/storage/emulated/0/PotatoNotes/exported/exported_note_' +
                                                      DateFormat(
                                                              "dd-MM-yyyy_HH-mm")
                                                          .format(now) +
                                                      '.md';

                                              String noteContents = "";

                                              if (noteTitle != "")
                                                noteContents +=
                                                    "# " + noteTitle + "\n\n";

                                              noteContents += noteContent;

                                              File(noteExportPath)
                                                  .writeAsString(noteContents)
                                                  .then((nothing) {
                                                scaffoldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                  content: Text(locales
                                                          .note_exportLocation +
                                                      " PotatoNotes/exported/exported_note_" +
                                                      DateFormat(
                                                              "dd-MM-yyyy_HH-mm-ss")
                                                          .format(now)),
                                                ));
                                              });
                                            } else {
                                              await PermissionHandler()
                                                  .requestPermissions([
                                                PermissionGroup.storage
                                              ]);
                                              appInfo.storageStatus =
                                                  await PermissionHandler()
                                                      .checkPermissionStatus(
                                                          PermissionGroup
                                                              .storage);
                                            }
                                          },
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: ListTile(
                                          //leading: Icon(Icons.notifications),
                                          enabled: !appInfo.notificationsIdList
                                              .contains(noteId.toString()),
                                          title: Text(locales.note_pinToNotifs),
                                          onTap: () async {
                                            appInfo.notificationsIdList
                                                .add(noteId.toString());
                                            await FlutterLocalNotificationsPlugin()
                                                .show(
                                                    int.parse(appInfo
                                                        .notificationsIdList
                                                        .last),
                                                    noteTitle != ""
                                                        ? noteTitle
                                                        : locales
                                                            .notesMainPageRoute_pinnedNote,
                                                    noteContent,
                                                    NotificationDetails(
                                                        AndroidNotificationDetails(
                                                          '0',
                                                          'Pinned notes',
                                                          'This channel contains the notes that you pin',
                                                          priority:
                                                              Priority.High,
                                                          playSound: true,
                                                          importance:
                                                              Importance.High,
                                                          ongoing: true,
                                                          color: appInfo.mainColor,
                                                        ),
                                                        IOSNotificationDetails()),
                                                    payload: noteId.toString());
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ];
                                  },
                                )
                              : IconButton(
                                  icon: Icon(OMIcons.colorLens),
                                  tooltip:
                                      locales.modifyNotesRoute_color_change,
                                  onPressed: () async {
                                    int result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return NoteColorDialog(
                                            noteColor: noteColor,
                                          );
                                        });

                                    setState(() {
                                      if (result != null) noteColor = result;
                                    });
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> checkListBuilder() {
    checkList.clear();
    List<Widget> widgets = List<Widget>();
    List<Widget> checkedWidgets = List<Widget>();
    final appInfo = Provider.of<AppInfoProvider>(context);

    Color getElementsColorBasedOnThemeContext() {
      Color colorToReturn;
      if ((noteColor ?? 0) == 0) {
        Theme.of(context).brightness == Brightness.dark
            ? colorToReturn = Colors.white
            : colorToReturn = Colors.black;
      } else {
        double noteColorBrightness =
            Color(NoteColors.colorList(context)[noteColor ?? 0]["hex"])
                .computeLuminance();

        if (noteColorBrightness > 0.5) {
          colorToReturn = Colors.black;
        } else {
          colorToReturn = Colors.white;
        }
      }

      return colorToReturn;
    }

    if (noteListParseString != null) {
      List<String> rawList = noteListParseString.split("\'..\'");

      for (int i = 0; i < rawList.length; i++) {
        List<dynamic> rawStrings = rawList[i].split("\',,\'");

        int checkValue = rawStrings[0] == "" ? 0 : int.parse(rawStrings[0]);
        try {
          checkList.add(ListPair(checkValue: checkValue, title: rawStrings[1]));
        } on RangeError {}
      }
    }

    if (checkList.length > 0) {
      textControllers.clear();
      for (int i = 0; i < checkList.length; i++) {
        textControllers
            .add(TextEditingController(text: checkList[i].title.toString()));
        textControllers[i].selection =
            TextSelection.collapsed(offset: checkList[i].title.length);
        Widget currentWidget = ListTile(
          leading: Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: noteColor != null
                ? getElementsColorBasedOnThemeContext()
                : appInfo.mainColor,
            checkColor: (noteColor ?? 0) == 0
                ? Theme.of(context).cardColor
                : Color(NoteColors.colorList(context)[noteColor ?? 0]["hex"]),
            value: checkList[i].checkValue == 1,
            onChanged: (value) {
              if (value) {
                setState(() => checkList[i].checkValue = 1);
              } else
                setState(() => checkList[i].checkValue = 0);
              setState(() => updateListParseString());
            },
          ),
          title: TextField(
            controller: textControllers[i],
            decoration: InputDecoration(border: InputBorder.none),
            onTap: () {
              textControllers[i].selection =
                  TextSelection.collapsed(offset: checkList[i].title.length);
            },
            onChanged: (text) {
              textControllers[i].text = text;
              textControllers[i].selection =
                  TextSelection.collapsed(offset: text.length);
              setState(() {
                checkList[i].title = text;
                updateListParseString();
              });
            },
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
              color: checkList[i].checkValue == 1
                  ? HSLColor.fromColor(getElementsColorBasedOnThemeContext())
                      .withAlpha(0.4)
                      .toColor()
                  : null,
              decoration: checkList[i].checkValue == 1
                  ? TextDecoration.lineThrough
                  : null,
              decorationColor: checkList[i].checkValue == 1
                  ? HSLColor.fromColor(getElementsColorBasedOnThemeContext())
                      .withAlpha(0.4)
                      .toColor()
                  : null,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              checkList.removeAt(i);
              textControllers.removeAt(i);
              setState(() => updateListParseString());
            },
          ),
        );

        if (checkList[i].checkValue == 0) {
          widgets.add(currentWidget);
        } else {
          checkedWidgets.add(currentWidget);
        }
      }
    }

    widgets.add(
      ListTile(
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.add),
        ),
        title: TextField(
          controller: entryTextController,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: locales.modifyNotesRoute_list_entry),
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (text) {
            checkList.add(ListPair(checkValue: 0, title: text));
            textControllers.add(TextEditingController(text: text));
            setState(() {
              updateListParseString();
              entryTextController.text = "";
            });
          },
        ),
      ),
    );

    Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);
    Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
    Animation<double> _iconTurns =
        _controller.drive(_halfTween.chain(_easeInTween));

    _controller.value = 1.0;

    if (checkedWidgets.length > 0) {
      widgets.add(
        ExpansionTile(
          initiallyExpanded: true,
          title: Text(checkedWidgets.length.toString() +
              locales.modifyNotesRoute_list_selectedEntries),
          children: checkedWidgets,
          leading: RotationTransition(
            turns: _iconTurns,
            child: const Icon(Icons.expand_more),
          ),
          onExpansionChanged: (expanded) {
            if (expanded) {
              _controller.forward();
            } else
              _controller.reverse();
          },
          trailing: Opacity(
            opacity: 0,
            child: Icon(Icons.expand_more),
          ),
        ),
      );
    }

    return widgets;
  }

  List<Widget> reminderListBuilder() {
    List<Widget> widgets = List<Widget>();

    for (int i = 0; i < reminderList.length; i++) {
      widgets.add(ListTile(
        leading: Icon(Icons.timer),
        title: Text(DateFormat("d MMMM yyyy, HH:mm")
            .format(DateTime.fromMillisecondsSinceEpoch(reminderList[i]))),
        onTap: () {
          showAddReminderDialog(context, index: i);
        },
      ));
    }

    return widgets;
  }

  Future<int> noteIdSearcher() async {
    List<Note> noteList =
        await NoteHelper.getNotes(SortMode.ID, NotesReturnMode.ALL);
    List<int> noteIdList = List<int>();

    noteList.forEach((item) {
      noteIdList.add(item.id);
    });

    if (noteIdList.length > 0) {
      return noteIdList[noteIdList.length - 1] + 1;
    } else
      return 1;
  }

  bool saveAndPop(bool stopDefaultButtonEvent) {
    if (((noteContent != "" || noteTitle != "") && noteIsList == 0) ||
        (noteIsList == 1 && noteListParseString != null)) {
      asyncExecutor();
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context);
    }

    return true;
  }

  void updateListParseString() {
    List<String> pairedList = List<String>();

    checkList.forEach((item) {
      pairedList.add(item.checkValue.toString() + "\',,\'" + item.title);
    });

    noteListParseString = pairedList.join("\'..\'");
  }

  void asyncExecutor() async {
    final appInfo = Provider.of<AppInfoProvider>(context);

    noteDate = DateTime.now().millisecondsSinceEpoch;

    updateListParseString();

    if (noteListParseString == null) noteIsList = 0;

    if (noteIsList == 0) noteListParseString = null;

    noteRemindersUpdater();

    if (noteReminders == "") noteReminders = null;

    Note note = Note(
      id: noteId,
      title: noteTitle,
      content: noteContent,
      isStarred: noteIsStarred,
      date: noteDate,
      color: noteColor,
      imagePath: noteImagePath,
      isList: noteIsList,
      listParseString: noteListParseString,
      reminders: noteReminders,
      hideContent: noteHideContent,
      pin: (notePin == null ? 64 : notePin.length) == 64
          ? notePin
          : sha256.convert(utf8.encode(notePin)).toString(),
      password: (notePassword == null ? 64 : notePassword.length) == 64
          ? notePassword
          : sha256.convert(utf8.encode(notePassword)).toString(),
      isDeleted: noteIsDeleted,
      isArchived: noteIsArchived,
    );

    await NoteHelper.insert(note);

    appInfo.notes =
        await NoteHelper.getNotes(appInfo.sortMode, NotesReturnMode.NORMAL);
    Navigator.pop(context, true);
  }

  void showImageActionDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(locales.chooseAction),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            contentPadding: EdgeInsets.only(top: 20, bottom: 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(OMIcons.photoLibrary),
                  title: noteImagePath != null
                      ? Text(locales.modifyNotesRoute_image_update)
                      : Text(locales.modifyNotesRoute_image_add),
                  onTap: () async {
                    Navigator.pop(context);

                    File image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);

                    if (image != null) {
                      List<int> imageBytes = await image.readAsBytes();

                      setState(() => showLoadingIcon = true);
                      Response imageToImgur = await post(
                          "https://api.imgur.com/3/image",
                          body: imageBytes,
                          headers: {
                            "Authorization": "Client-ID f856a5e4fd5b2af"
                          });

                      Map<String, dynamic> imgurBody =
                          json.decode(imageToImgur.body);

                      setState(() => showLoadingIcon = false);

                      if (imgurBody["success"]) {
                        setState(
                            () => noteImagePath = imgurBody["data"]["link"]);
                      }
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  enabled: noteImagePath != null,
                  leading: Icon(OMIcons.delete),
                  title: Text(locales.modifyNotesRoute_image_remove),
                  onTap: () async {
                    setState(() => noteImagePath = null);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void showAddReminderDialog(BuildContext baseContext, {int index}) {
    final appInfo = Provider.of<AppInfoProvider>(baseContext);

    if (index != null) {
      DateTime generalDate =
          DateTime.fromMillisecondsSinceEpoch(reminderList[index]);

      appInfo.date =
          DateTime(generalDate.year, generalDate.month, generalDate.day);
      appInfo.time =
          TimeOfDay(hour: generalDate.hour, minute: generalDate.minute);
    }

    showDialog(
        context: baseContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: index != null
                ? Text(locales.modifyNotesRoute_reminder_update)
                : Text(locales.modifyNotesRoute_reminder_add),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            contentPadding: EdgeInsets.only(top: 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(OMIcons.timer),
                  title: Text(locales.modifyNotesRoute_reminder_time),
                  onTap: () async {
                    TimeOfDay result = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now()
                            .replacing(minute: TimeOfDay.now().minute + 1),
                        builder: (context, child) {
                          return child;
                        });

                    setState(() => appInfo.time = result);
                  },
                  trailing: appInfo.time != null
                      ? Text(appInfo.time.format(context))
                      : null,
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(OMIcons.dateRange),
                  title: Text(locales.modifyNotesRoute_reminder_date),
                  onTap: () async {
                    DateTime result = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        initialDate: DateTime.now(),
                        builder: (context, child) {
                          return child;
                        });

                    setState(() => appInfo.date = result);
                  },
                  trailing: appInfo.date != null
                      ? Text(DateFormat("d/MM/yy").format(appInfo.date))
                      : null,
                ),
              ],
            ),
            actions: <Widget>[
              index != null
                  ? FlatButton(
                      textColor: appInfo.mainColor,
                      hoverColor: appInfo.mainColor,
                      child: Text(locales.remove),
                      onPressed: () async {
                        reminderList.removeAt(index);
                        await FlutterLocalNotificationsPlugin().cancel(
                            int.parse(noteId.toString() + index.toString()));
                        setState(() => noteRemindersUpdater());
                        Navigator.pop(context);
                      },
                    )
                  : Container(),
              FlatButton(
                textColor: appInfo.mainColor,
                hoverColor: appInfo.mainColor,
                child: Text(locales.cancel),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                textColor: appInfo.mainColor,
                hoverColor: appInfo.mainColor,
                child: Text(locales.save),
                onPressed: (appInfo.date != null && appInfo.time != null)
                    ? () async {
                        DateTime completeReminder = DateTime(
                            appInfo.date.year,
                            appInfo.date.month,
                            appInfo.date.day,
                            appInfo.time.hour,
                            appInfo.time.minute);
                        if (index != null) {
                          reminderList[index] =
                              completeReminder.millisecondsSinceEpoch;
                        } else {
                          reminderList
                              .add(completeReminder.millisecondsSinceEpoch);
                        }
                        setState(() => noteRemindersUpdater());
                        String notifId = noteId.toString() +
                            (index != null ? index : reminderList.length)
                                .toString();
                        appInfo.remindersNotifIdList.add(notifId);
                        await FlutterLocalNotificationsPlugin().schedule(
                            int.parse(appInfo.remindersNotifIdList.last),
                            noteTitle != ""
                                ? noteTitle
                                : locales.modifyNotesRoute_reminder,
                            noteContent,
                            completeReminder,
                            NotificationDetails(
                                AndroidNotificationDetails(
                                  '1',
                                  'Reminders',
                                  'This channel contains remainders that you set',
                                  priority: Priority.High,
                                  playSound: true,
                                  importance: Importance.High,
                                  color: appInfo.mainColor,
                                ),
                                IOSNotificationDetails()),
                            payload: noteId.toString() +
                                ":" +
                                completeReminder.millisecondsSinceEpoch
                                    .toString());
                        Navigator.pop(context);
                      }
                    : null,
              ),
            ],
          );
        });
  }

  void showAddElementScrollableBottomSheet(
      BuildContext context, Color bgColor, Color iconTextColor) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: bgColor,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: bgColor,
              ),
              iconTheme: IconThemeData(
                color: iconTextColor,
              ),
              textTheme: TextTheme(
                subtitle1: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: iconTextColor,
                    ),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      OMIcons.addToPhotos,
                      color: iconTextColor,
                    ),
                    title: Text(locales.modifyNotesRoute_image),
                    onTap: () async {
                      Navigator.pop(context);
                      showImageActionDialog(context);
                    },
                  ),
                  ListTile(
                      leading: Icon(
                        noteIsList == 0
                            ? Icons.check_circle_outline
                            : Icons.check_circle,
                        color: iconTextColor,
                      ),
                      title: Text(locales.modifyNotesRoute_list),
                      onTap: () {
                        setState(() {
                          if (noteIsList == 0) {
                            noteIsList = 1;
                            checkList.clear();
                            List<String> initialList = noteContent.split("\n");
                            initialList.forEach((item) {
                              checkList
                                  .add(ListPair(checkValue: 0, title: item));
                            });
                            updateListParseString();
                          } else {
                            noteIsList = 0;
                            List<String> titleList = List<String>();
                            for (int i = 0; i < checkList.length; i++) {
                              titleList.add(checkList[i].title);
                            }
                            noteContent = titleList.join("\n");
                            checkList.clear();
                          }
                        });
                        Navigator.pop(context);
                      }),
                  ListTile(
                    leading: Icon(
                      OMIcons.addAlert,
                      color: iconTextColor,
                    ),
                    title: Text(locales.modifyNotesRoute_reminder),
                    onTap: () async {
                      final appInfo = Provider.of<AppInfoProvider>(context);
                      appInfo.date = null;
                      appInfo.time = null;
                      Navigator.pop(context);
                      showAddReminderDialog(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showHideContentScrollableBottomSheet(
      BuildContext context, Color bgColor, Color iconTextColor) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    showModalBottomSheet<void>(
        context: context,
        backgroundColor: bgColor,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(
                bottomSheetTheme: BottomSheetThemeData(
                  backgroundColor: bgColor,
                ),
                iconTheme: IconThemeData(
                  color: iconTextColor,
                ),
                textTheme: TextTheme(
                  subtitle1: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: iconTextColor,
                      ),
                ),
                disabledColor: iconTextColor.withAlpha(120)),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SwitchListTile(
                    secondary: Icon(
                      OMIcons.removeRedEye,
                      color: iconTextColor,
                    ),
                    activeColor: Theme.of(context).accentColor,
                    title: Text(locales.modifyNotesRoute_security_hideContent),
                    value: appInfo.hideContent == 1,
                    onChanged: (value) async {
                      appInfo.hideContent = value ? 1 : 0;
                      noteHideContent = value ? 1 : 0;
                    },
                  ),
                  SwitchListTile(
                    title:
                        Text(locales.modifyNotesRoute_security_protectionText),
                    secondary: Icon(
                      OMIcons.lock,
                      color: iconTextColor,
                    ),
                    activeColor: Theme.of(context).accentColor,
                    value: appInfo.useProtectionForNoteContent,
                    onChanged: appInfo.hideContent == 1
                        ? (value) {
                            appInfo.useProtectionForNoteContent = value;
                            appInfo.pin = false;
                            appInfo.password = false;
                            setState(() {
                              notePin = null;
                              notePassword = null;
                            });
                          }
                        : null,
                  ),
                  ListTile(
                      enabled: appInfo.hideContent == 1 &&
                          appInfo.useProtectionForNoteContent,
                      leading: Icon(OMIcons.check,
                          color:
                              appInfo.pin ? iconTextColor : Colors.transparent),
                      title: Text(locales.modifyNotesRoute_security_pin),
                      onTap: () async {
                        String result = await showDialog(
                            context: context,
                            builder: (context) {
                              return ProtectionDialog(
                                setPassword: false,
                                pin: notePin,
                                password: notePassword,
                                appInfo: appInfo,
                              );
                            });

                        if (result != null) {
                          notePin = result;
                          notePassword = null;
                        }
                      }),
                  ListTile(
                      enabled: appInfo.hideContent == 1 &&
                          appInfo.useProtectionForNoteContent,
                      leading: Icon(Icons.check,
                          color: appInfo.password
                              ? iconTextColor
                              : Colors.transparent),
                      title: Text(locales.modifyNotesRoute_security_password),
                      onTap: () async {
                        String result = await showDialog(
                            context: context,
                            builder: (context) {
                              return ProtectionDialog(
                                setPassword: true,
                                pin: notePin,
                                password: notePassword,
                                appInfo: appInfo,
                              );
                            });

                        if (result != null) {
                          notePassword = result;
                          notePin = null;
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }
}

class NoteColorDialog extends StatefulWidget {
  final int noteColor;

  NoteColorDialog({this.noteColor});

  @override
  createState() => _NoteColorDialogState();
}

class _NoteColorDialogState extends State<NoteColorDialog> {
  int currentColor = 0;

  @override
  void initState() {
    currentColor = widget.noteColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppInfoProvider appInfo = Provider.of<AppInfoProvider>(context);
    AppLocalizations locales = AppLocalizations.of(context);

    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      semanticLabel: locales.modifyNotesRoute_color_dialogTitle,
      content: NoteColorSelector(
        selectedColor: currentColor,
        onColorSelect: (color) {
          print(color);
          setState(() => currentColor = color);
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            locales.cancel,
            style: TextStyle(
              color: appInfo.mainColor,
            ),
          ),
          onPressed: () => Navigator.pop(context),
          textColor: appInfo.mainColor,
        ),
        FlatButton(
          child: Text(
            locales.confirm,
            style: TextStyle(
              color: appInfo.mainColor,
            ),
          ),
          onPressed: () {
            print(currentColor);
            Navigator.pop(context, currentColor);
          },
          textColor: appInfo.mainColor,
        ),
      ],
    );
  }
}

class ProtectionDialog extends StatefulWidget {
  bool setPassword;
  String pin;
  String password;
  AppInfoProvider appInfo;

  ProtectionDialog({
    this.setPassword,
    this.pin,
    this.password,
    this.appInfo,
  });

  @override
  createState() => _ProtectionDialogState();
}

class _ProtectionDialogState extends State<ProtectionDialog> {
  bool hideText = true;
  TextEditingController controller = TextEditingController();
  String status = "";
  bool error = true;

  int minLength;
  int maxLength;

  @override
  void initState() {
    super.initState();
    minLength = widget.setPassword ? 2 : 4;
    maxLength = widget.setPassword ? 30 : 12;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locales = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(widget.setPassword
          ? locales.modifyNotesRoute_security_dialog_titlePassword
          : locales.modifyNotesRoute_security_dialog_titlePin),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: hideText,
                  keyboardType: widget.setPassword
                      ? TextInputType.text
                      : TextInputType.number,
                  onChanged: (text) {
                    setState(() {
                      if (text.length < minLength) {
                        status = locales
                            .modifyNotesRoute_security_dialog_lengthShort(
                                widget.setPassword ? "Password" : "PIN",
                                minLength.toString());
                        error = true;
                      } else if (text.length > maxLength) {
                        status = locales
                            .modifyNotesRoute_security_dialog_lengthExceed(
                                widget.setPassword ? "Password" : "PIN",
                                maxLength.toString());
                        error = true;
                      } else {
                        status = (widget.setPassword ? "Password" : "PIN") +
                            locales.modifyNotesRoute_security_dialog_valid;
                        error = false;
                      }
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: hideText
                      ? Theme.of(context).iconTheme.color.withAlpha(120)
                      : Theme.of(context).iconTheme.color,
                ),
                tooltip: hideText
                    ? locales.semantics_showText
                    : locales.semantics_hideText,
                onPressed: () {
                  setState(() => hideText = !hideText);
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              status,
              style: TextStyle(
                color: error ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(locales.cancel),
          onPressed: () => Navigator.pop(context),
          textColor: Theme.of(context).accentColor,
        ),
        FlatButton(
          child: Text(locales.done),
          onPressed: error
              ? null
              : () {
                  if (widget.setPassword) {
                    widget.password =
                        sha256.convert(utf8.encode(controller.text)).toString();
                    widget.pin = null;
                    widget.appInfo.password = true;
                    widget.appInfo.pin = false;
                  } else {
                    widget.password = null;
                    widget.pin =
                        sha256.convert(utf8.encode(controller.text)).toString();
                    widget.appInfo.password = false;
                    widget.appInfo.pin = true;
                  }
                  Navigator.pop(context,
                      widget.setPassword ? widget.password : widget.pin);
                },
          textColor: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
