import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/methods.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/internal/search_filters.dart';
import 'package:potato_notes/routes/modify_notes_route.dart';
import 'package:potato_notes/routes/search_notes_route.dart';
import 'package:potato_notes/routes/security_note_route.dart';
import 'package:potato_notes/routes/settings_route.dart';
import 'package:potato_notes/routes/sync_login_route.dart';
import 'package:potato_notes/routes/sync_manage_route.dart';
import 'package:potato_notes/routes/user_info_route.dart';
import 'package:potato_notes/ui/user_info_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:simple_animations/simple_animations.dart';

class NotesMainPageRoute extends StatefulWidget {
  final List<Note> noteList;

  NotesMainPageRoute({@required this.noteList});

  @override
  _NotesMainPageState createState() => new _NotesMainPageState(noteList);
}

class _NotesMainPageState extends State<NotesMainPageRoute>
    with SingleTickerProviderStateMixin {
  List<Note> noteList = List<Note>();

  _NotesMainPageState(List<Note> list) {
    this.noteList = list;
  }

  AnimationController controller;

  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Note> selectionList = List<Note>();
  bool isSelectorVisible = false;

  AppInfoProvider appInfo;
  AppLocalizations locales;
  Timer executor;
  bool autoSyncLastStatus;
  int autoSyncLastTimeout;

  bool syncing = false;
  List<int> queueList = [];

  NotesReturnMode currentView = NotesReturnMode.NORMAL;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        value: 1.0, duration: Duration(milliseconds: 150), vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher_fg');
      IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings();
      InitializationSettings initializationSettings =
          new InitializationSettings(
              initializationSettingsAndroid, initializationSettingsIOS);

      Future onNotificationClicked(String payload) async {
        List<String> payloadSplitted = payload.split(":");
        bool executeAlt = true;
        try {
          String _ = payloadSplitted[1];
        } on RangeError {
          executeAlt = false;
        }

        if (executeAlt) {
          appInfo.remindersNotifIdList.remove(payloadSplitted[0]);
          List<int> noteListId = List<int>();
          noteList.forEach((item) {
            noteListId.add(item.id);
          });
          Note note =
              noteList[noteListId.indexOf(int.parse(payloadSplitted[0]))];
          List<String> remindersString = note.reminders.split(":");
          remindersString.remove(payloadSplitted[1]);
          _editNoteCaller(
              context,
              Note(
                  id: int.parse(payloadSplitted[0]),
                  title: note.title,
                  content: note.content,
                  isStarred: note.isStarred,
                  date: note.date,
                  color: note.color,
                  imagePath: note.imagePath,
                  isList: note.isList,
                  listParseString: note.listParseString,
                  reminders: remindersString.join(":")),
              "");
        } else {
          appInfo.notificationsIdList.remove(payloadSplitted[0]);
        }
      }

      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onNotificationClicked);

      initializeNotifications();
    });
  }

  void updateAutosyncExecutor(bool execute, int timeout) {
    if (appInfo.userToken != null) {
      if (execute) {
        executor = Timer.periodic(
            Duration(seconds: appInfo.autoSyncTimeInterval), (timer) async {
          if (appInfo.autoSync == false || appInfo.userToken == null)
            timer.cancel();

          List<Note> parsedList =
              await OnlineNoteHelper.getNotes(SortMode.ID, NotesReturnMode.ALL);
          List<Note> list =
              await NoteHelper.getNotes(SortMode.ID, NotesReturnMode.ALL);

          bool shouldUpdate() {
            if (parsedList.length != list.length) {
              return true;
            } else {
              for (int i = 0; i < parsedList.length; i++) {
                Note parsedNote = parsedList[i];
                Note note = list[i];

                if (parsedNote.title != note.title ||
                    parsedNote.content != note.content ||
                    parsedNote.isStarred != note.isStarred ||
                    parsedNote.date != note.date ||
                    parsedNote.color != note.color ||
                    parsedNote.imagePath != note.imagePath ||
                    parsedNote.isList != note.isList ||
                    parsedNote.listParseString != note.listParseString ||
                    parsedNote.reminders != note.reminders ||
                    parsedNote.hideContent != note.hideContent ||
                    parsedNote.pin != note.pin ||
                    parsedNote.password != note.password ||
                    parsedNote.isDeleted != note.isDeleted ||
                    parsedNote.isArchived != note.isArchived) {
                  return true;
                }
              }
              return false;
            }
          }

          if (parsedList != null && shouldUpdate()) {
            noteList.forEach((note) => note.isSelected = false);
            setState(() {
              selectionList.clear();
              isSelectorVisible = false;
            });

            for (int i = 0; i < list.length; i++) {
              NoteHelper.delete(list[i].id);
            }

            for (int i = 0; i < parsedList.length; i++) {
              await NoteHelper.insert(parsedList[i]);
            }

            list = await NoteHelper.getNotes(appInfo.sortMode, currentView);
            setState(() => noteList = list);
          }
        });
      } else {
        executor?.cancel();
      }
    }
  }

  void initializeNotifications() async {
    appInfo = Provider.of<AppInfoProvider>(context);

    for (int i = 0; i < appInfo.notificationsIdList.length; i++) {
      int index = int.parse(appInfo.notificationsIdList[i]);
      await FlutterLocalNotificationsPlugin().show(
          index,
          noteList[index].title != ""
              ? noteList[index].title
              : locales.notesMainPageRoute_pinnedNote,
          noteList[index].content,
          NotificationDetails(
              AndroidNotificationDetails(
                '0',
                'note_pinned_notifications',
                'idk',
                priority: Priority.High,
                playSound: true,
                importance: Importance.High,
                ongoing: true,
              ),
              IOSNotificationDetails()),
          payload: index.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    appInfo = Provider.of<AppInfoProvider>(context);
    locales = AppLocalizations.of(context);

    if ((autoSyncLastStatus == null && autoSyncLastTimeout == null) ||
        (autoSyncLastStatus != appInfo.autoSync ||
            autoSyncLastTimeout != appInfo.autoSyncTimeInterval)) {
      updateAutosyncExecutor(appInfo.autoSync, appInfo.autoSyncTimeInterval);
      autoSyncLastStatus = appInfo.autoSync;
      autoSyncLastTimeout = appInfo.autoSyncTimeInterval;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      key: scaffoldKey,
      body: RefreshIndicator(
        displacement: 160,
        onRefresh: appInfo.userToken == null
            ? () async {}
            : () async {
                List<Note> parsedList = await OnlineNoteHelper.getNotes(
                    SortMode.ID, NotesReturnMode.ALL);
                List<Note> list =
                    await NoteHelper.getNotes(SortMode.ID, NotesReturnMode.ALL);

                bool shouldUpdate() {
                  if (parsedList.length != list.length) {
                    return true;
                  } else {
                    for (int i = 0; i < parsedList.length; i++) {
                      Note parsedNote = parsedList[i];
                      Note note = list[i];

                      if (parsedNote.title != note.title ||
                          parsedNote.content != note.content ||
                          parsedNote.isStarred != note.isStarred ||
                          parsedNote.date != note.date ||
                          parsedNote.color != note.color ||
                          parsedNote.imagePath != note.imagePath ||
                          parsedNote.isList != note.isList ||
                          parsedNote.listParseString != note.listParseString ||
                          parsedNote.reminders != note.reminders ||
                          parsedNote.hideContent != note.hideContent ||
                          parsedNote.pin != note.pin ||
                          parsedNote.password != note.password ||
                          parsedNote.isDeleted != note.isDeleted ||
                          parsedNote.isArchived != note.isArchived) {
                        return true;
                      }
                    }
                    return false;
                  }
                }

                if (parsedList != null && shouldUpdate()) {
                  noteList.forEach((note) => note.isSelected = false);
                  setState(() {
                    selectionList.clear();
                    isSelectorVisible = false;
                  });

                  for (int i = 0; i < list.length; i++) {
                    NoteHelper.delete(list[i].id);
                  }

                  for (int i = 0; i < parsedList.length; i++) {
                    await NoteHelper.insert(parsedList[i]);
                  }

                  list =
                      await NoteHelper.getNotes(appInfo.sortMode, currentView);
                  setState(() => noteList = list);
                }
              },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            children: <Widget>[
              noteList.length != 0
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: AnimatedBuilder(
                        animation:
                            Tween<double>(begin: 0, end: 1).animate(controller),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          child: Column(
                            children: noteListBuilder(context),
                          ),
                        ),
                        builder: (context, child) {
                          return Opacity(
                            opacity: controller.value,
                            child: child,
                          );
                        },
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              currentView == NotesReturnMode.DELETED
                                  ? Icons.delete_outline
                                  : currentView == NotesReturnMode.ARCHIVED
                                      ? OMIcons.archive
                                      : OMIcons.note,
                              size: 50.0,
                              color: HSLColor.fromColor(
                                      Theme.of(context).textTheme.title.color)
                                  .withAlpha(0.4)
                                  .toColor()),
                          Text(
                            currentView == NotesReturnMode.DELETED
                                ? locales.notesMainPageRoute_emptyTrash
                                : currentView == NotesReturnMode.ARCHIVED
                                    ? locales.notesMainPageRoute_emptyArchive
                                    : locales.notesMainPageRoute_noNotes,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: HSLColor.fromColor(
                                      Theme.of(context).textTheme.title.color)
                                  .withAlpha(0.4)
                                  .toColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isSelectorVisible ? selectorBottomBar : bottomBar,
      floatingActionButton:
          currentView == NotesReturnMode.NORMAL && !isSelectorVisible
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  elevation: 2,
                  backgroundColor: Theme.of(context).accentColor,
                  onPressed: () {
                    _addNoteCaller(context);
                    selectionList.clear();
                    noteList.forEach((item) {
                      item.isSelected = false;
                    });
                    setState(() => isSelectorVisible = false);
                  },
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget get bottomBar {
    return Material(
      elevation: 140,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(CommunityMaterialIcons.menu),
              padding: EdgeInsets.symmetric(horizontal: 16),
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => UserInfoDialog(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  onSettingsTileClick: () => _settingsCaller(context),
                  onPotatoSyncTileClick: () async {
                    if (appInfo.userToken != null) {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SyncManageRoute()));
                    } else {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SyncLoginRoute()));
                    }

                    List<Note> list = await NoteHelper.getNotes(
                        appInfo.sortMode, currentView);
                    setState(() => noteList = list);
                  },
                  extraItems: <Widget>[
                    UserInfoListTile(
                      icon: Icon(
                        CommunityMaterialIcons.home_variant_outline,
                        color: currentView == NotesReturnMode.NORMAL
                            ? Theme.of(context).accentColor
                            : Theme.of(context)
                                .iconTheme
                                .color
                                .withOpacity(0.7),
                      ),
                      text: Text(
                        locales.notes,
                        style: TextStyle(
                            color: currentView == NotesReturnMode.NORMAL
                                ? Theme.of(context).accentColor
                                : null,
                            fontWeight: currentView == NotesReturnMode.NORMAL
                                ? FontWeight.w500
                                : FontWeight.w400,
                            fontSize: 16),
                      ),
                      onTap: () async {
                        if (currentView != NotesReturnMode.NORMAL) {
                          currentView = NotesReturnMode.NORMAL;
                          List<Note> list = await NoteHelper.getNotes(
                              appInfo.sortMode, currentView);
                          setState(() => noteList = list);
                          Navigator.pop(context);

                          noteList.forEach((item) {
                            item.isSelected = false;
                          });

                          setState(() {
                            selectionList.clear();
                            isSelectorVisible = false;
                          });

                          Brightness systemBarsIconBrightness =
                              Theme.of(context).brightness == Brightness.dark
                                  ? Brightness.light
                                  : Brightness.dark;

                          changeSystemBarsColors(
                              Theme.of(context).scaffoldBackgroundColor,
                              systemBarsIconBrightness);
                        }
                      },
                    ),
                    UserInfoListTile(
                      icon: Icon(
                        OMIcons.archive,
                        color: currentView == NotesReturnMode.ARCHIVED
                            ? Theme.of(context).accentColor
                            : Theme.of(context)
                                .iconTheme
                                .color
                                .withOpacity(0.7),
                      ),
                      text: Text(
                        locales.archive,
                        style: TextStyle(
                            color: currentView == NotesReturnMode.ARCHIVED
                                ? Theme.of(context).accentColor
                                : null,
                            fontWeight: currentView == NotesReturnMode.ARCHIVED
                                ? FontWeight.w500
                                : FontWeight.w400,
                            fontSize: 16),
                      ),
                      onTap: () async {
                        if (currentView != NotesReturnMode.ARCHIVED) {
                          currentView = NotesReturnMode.ARCHIVED;
                          List<Note> list = await NoteHelper.getNotes(
                              appInfo.sortMode, currentView);
                          setState(() => noteList = list);
                          Navigator.pop(context);

                          noteList.forEach((item) {
                            item.isSelected = false;
                          });

                          setState(() {
                            selectionList.clear();
                            isSelectorVisible = false;
                          });

                          Brightness systemBarsIconBrightness =
                              Theme.of(context).brightness == Brightness.dark
                                  ? Brightness.light
                                  : Brightness.dark;

                          changeSystemBarsColors(
                              Theme.of(context).scaffoldBackgroundColor,
                              systemBarsIconBrightness);
                        }
                      },
                    ),
                    UserInfoListTile(
                      icon: Icon(
                        CommunityMaterialIcons.trash_can_outline,
                        color: currentView == NotesReturnMode.DELETED
                            ? Theme.of(context).accentColor
                            : Theme.of(context)
                                .iconTheme
                                .color
                                .withOpacity(0.7),
                      ),
                      text: Text(
                        locales.trash,
                        style: TextStyle(
                            color: currentView == NotesReturnMode.DELETED
                                ? Theme.of(context).accentColor
                                : null,
                            fontWeight: currentView == NotesReturnMode.DELETED
                                ? FontWeight.w500
                                : FontWeight.w400,
                            fontSize: 16),
                      ),
                      onTap: () async {
                        if (currentView != NotesReturnMode.DELETED) {
                          currentView = NotesReturnMode.DELETED;
                          List<Note> list = await NoteHelper.getNotes(
                              appInfo.sortMode, currentView);
                          setState(() => noteList = list);
                          Navigator.pop(context);

                          noteList.forEach((item) {
                            item.isSelected = false;
                          });

                          setState(() {
                            selectionList.clear();
                            isSelectorVisible = false;
                          });

                          Brightness systemBarsIconBrightness =
                              Theme.of(context).brightness == Brightness.dark
                                  ? Brightness.light
                                  : Brightness.dark;

                          changeSystemBarsColors(
                              Theme.of(context).scaffoldBackgroundColor,
                              systemBarsIconBrightness);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              padding: EdgeInsets.symmetric(horizontal: 16),
              onPressed: () => _searchNoteCaller(
                  context, noteList, Theme.of(context).scaffoldBackgroundColor),
            ),
            IconButton(
              icon: appInfo.isGridView
                  ? Icon(OMIcons.viewAgenda)
                  : Icon(CommunityMaterialIcons.view_dashboard_outline),
              padding: EdgeInsets.symmetric(horizontal: 16),
              onPressed: () async {
                if (controller.status == AnimationStatus.completed) {
                  await controller.animateTo(0);
                  appInfo.isGridView = !appInfo.isGridView;
                  await controller.animateTo(1);
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Visibility(
                visible: syncing,
                child: ControlledAnimation(
                  playback: Playback.LOOP,
                  tween: Tween<double>(begin: 0, end: 360),
                  duration: Duration(milliseconds: 900),
                  builder: (context, animation) {
                    return Transform.rotate(
                      angle: -(animation * pi) / 180,
                      child: Icon(Icons.sync),
                    );
                  },
                ),
              ),
            ),
            Spacer(),
            Visibility(
              visible: currentView == NotesReturnMode.DELETED,
              child: PopupMenuButton(
                onSelected: (value) {
                  if (value == 0) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          title: Text(
                              locales.notesMainPageRoute_note_emptyTrash_title),
                          content: Text(locales
                              .notesMainPageRoute_note_emptyTrash_content),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(locales.cancel),
                              onPressed: () => Navigator.pop(context),
                              textColor: appInfo.mainColor,
                            ),
                            FlatButton(
                              child: Text(locales.confirm),
                              color: appInfo.mainColor,
                              textColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              onPressed: () async {
                                Navigator.pop(context);

                                for (int i = 0; i < noteList.length; i++) {
                                  await NoteHelper.delete(noteList[i].id);
                                }

                                List<Note> list = await NoteHelper.getNotes(
                                    appInfo.sortMode, NotesReturnMode.DELETED);
                                setState(() {
                                  noteList = list;
                                  syncing = true;
                                  queueList.add(1);
                                });

                                for (int i = 0; i < noteList.length; i++) {
                                  if (appInfo.userToken != null) {
                                    await OnlineNoteHelper.delete(
                                        noteList[i].id);
                                  }
                                }

                                queueList.removeLast();
                                if (queueList.length == 0) {
                                  setState(() => syncing = false);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      enabled: noteList.length != 0,
                      value: 0,
                      child: Text(locales.note_emptyTrash),
                    ),
                  ];
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget get selectorBottomBar {
    return Material(
      elevation: 140,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.close,
                color: appInfo.mainColor,
              ),
              onPressed: () async {
                selectionList.clear();
                noteList.forEach((item) {
                  item.isSelected = false;
                });
                setState(() => isSelectorVisible = false);
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                selectionList.length.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),
            Visibility(
              visible: currentView != NotesReturnMode.DELETED,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      selectionList
                                  .where((note) => note.isStarred == 0)
                                  .toList()
                                  .length !=
                              0
                          ? Icons.star
                          : Icons.star_border,
                    ),
                    onPressed: () async {
                      bool starOrNot = selectionList
                              .where((note) => note.isStarred == 0)
                              .toList()
                              .length !=
                          0;

                      List<Note> selectionListCopy = List.from(selectionList);

                      if (starOrNot) {
                        for (int i = 0; i < selectionList.length; i++) {
                          await NoteHelper.update(
                            noteList
                                .firstWhere((note) => note == selectionList[i])
                                .copyWith(isStarred: 1),
                          );
                        }

                        List<Note> list = await NoteHelper.getNotes(
                            appInfo.sortMode, currentView);
                        setState(() => noteList = list);

                        noteList.forEach((item) {
                          item.isSelected = false;
                        });

                        setState(() {
                          selectionList.clear();
                          isSelectorVisible = false;
                          syncing = true;
                        });

                        for (int i = 0; i < selectionListCopy.length; i++) {
                          if (appInfo.userToken != null) {
                            await OnlineNoteHelper.save(noteList
                                .firstWhere((note) =>
                                    note.id == selectionListCopy[i].id)
                                .copyWith(isStarred: 1));
                          }
                        }

                        setState(() => syncing = false);
                      } else {
                        for (int i = 0; i < selectionList.length; i++) {
                          await NoteHelper.update(
                            noteList
                                .firstWhere((note) => note == selectionList[i])
                                .copyWith(isStarred: 0),
                          );
                        }

                        List<Note> list = await NoteHelper.getNotes(
                            appInfo.sortMode, currentView);
                        setState(() => noteList = list);

                        noteList.forEach((item) {
                          item.isSelected = false;
                        });

                        setState(() {
                          selectionList.clear();
                          isSelectorVisible = false;
                          syncing = true;
                          queueList.add(1);
                        });

                        for (int i = 0; i < selectionListCopy.length; i++) {
                          if (appInfo.userToken != null) {
                            await OnlineNoteHelper.save(noteList
                                .firstWhere((note) =>
                                    note.id == selectionListCopy[i].id)
                                .copyWith(isStarred: 0));
                          }
                        }

                        queueList.removeLast();

                        if (queueList.length == 0) {
                          setState(() => syncing = false);
                        }
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      OMIcons.colorLens,
                    ),
                    onPressed: () async {
                      var result = await showDialog(
                          context: context,
                          builder: (context) {
                            return NoteColorDialog(
                              noteColor: null,
                            );
                          });

                      List<Note> selectionListCopy = List.from(selectionList);

                      if (result != null) {
                        for (int i = 0; i < selectionList.length; i++) {
                          await NoteHelper.update(
                            noteList
                                .firstWhere((note) => note == selectionList[i])
                                .copyWith(color: result),
                          );
                        }

                        List<Note> list = await NoteHelper.getNotes(
                            appInfo.sortMode, currentView);
                        setState(() {
                          noteList = list;
                          selectionList.clear();
                          isSelectorVisible = false;
                          syncing = true;
                          queueList.add(1);
                        });

                        for (int i = 0; i < selectionListCopy.length; i++) {
                          if (appInfo.userToken != null) {
                            await OnlineNoteHelper.save(
                                selectionListCopy[i].copyWith(color: result));
                          }
                        }

                        queueList.removeLast();

                        if (queueList.length == 0) {
                          setState(() => syncing = false);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                OMIcons.delete,
              ),
              onPressed: () async {
                if (currentView != NotesReturnMode.DELETED) {
                  List<Note> noteBackup = List.from(selectionList);

                  for (int i = 0; i < selectionList.length; i++) {
                    await NoteHelper.update(
                      noteList
                          .firstWhere((note) => note == selectionList[i])
                          .copyWith(isDeleted: 1, isStarred: 0),
                    );
                  }

                  selectionList.clear();

                  noteList.forEach((item) {
                    item.isSelected = false;
                  });

                  List<Note> list =
                      await NoteHelper.getNotes(appInfo.sortMode, currentView);

                  setState(() {
                    noteList = list;
                    isSelectorVisible = false;
                    syncing = true;
                    queueList.add(1);
                  });

                  scaffoldKey.currentState.removeCurrentSnackBar();
                  scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(noteBackup.length > 1
                          ? locales.notes_delete_snackbar
                          : locales.note_delete_snackbar),
                      action: SnackBarAction(
                        label: locales.undo,
                        onPressed: () async {
                          for (int i = 0; i < noteBackup.length; i++) {
                            await NoteHelper.insert(
                                noteBackup[i].copyWith(isDeleted: 0));
                          }

                          List<Note> list = await NoteHelper.getNotes(
                              appInfo.sortMode, currentView);
                          setState(() {
                            noteList = list;
                            syncing = true;
                            queueList.add(1);
                          });

                          for (int i = 0; i < noteBackup.length; i++) {
                            if (appInfo.userToken != null) {
                              await OnlineNoteHelper.save(
                                  noteBackup[i].copyWith(isDeleted: 0));
                            }
                          }

                          queueList.removeLast();
                          if (queueList.length == 0) {
                            setState(() => syncing = false);
                          }
                        },
                      ),
                    ),
                  );

                  for (int i = 0; i < noteBackup.length; i++) {
                    if (appInfo.userToken != null) {
                      await OnlineNoteHelper.save(
                          noteBackup[i].copyWith(isDeleted: 1, isStarred: 0));
                    }
                  }

                  queueList.removeLast();

                  if (queueList.length == 0) {
                    setState(() => syncing = false);
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        title: Text(
                            locales.notesMainPageRoute_note_deleteDialog_title),
                        content: Text(locales
                            .notesMainPageRoute_note_deleteDialog_content),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(locales.cancel),
                            onPressed: () => Navigator.pop(context),
                            textColor: appInfo.mainColor,
                          ),
                          FlatButton(
                            child: Text(locales.confirm),
                            color: appInfo.mainColor,
                            textColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            onPressed: () async {
                              Navigator.pop(context);
                              List<Note> selectionListCopy =
                                  List.from(selectionList);

                              for (int i = 0; i < selectionList.length; i++) {
                                await NoteHelper.delete(selectionList[i].id);
                              }

                              List<Note> list = await NoteHelper.getNotes(
                                  appInfo.sortMode, NotesReturnMode.DELETED);
                              setState(() => noteList = list);

                              noteList.forEach((item) {
                                item.isSelected = false;
                              });

                              setState(() {
                                selectionList.clear();
                                isSelectorVisible = false;
                                syncing = true;
                                queueList.add(1);
                              });

                              for (int i = 0;
                                  i < selectionListCopy.length;
                                  i++) {
                                if (appInfo.userToken != null) {
                                  await OnlineNoteHelper.delete(
                                      selectionListCopy[i].id);
                                }
                              }

                              queueList.removeLast();
                              if (queueList.length == 0) {
                                setState(() => syncing = false);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            Visibility(
              visible: currentView != NotesReturnMode.ARCHIVED,
              child: IconButton(
                icon: Icon(
                  OMIcons.archive,
                ),
                onPressed: () async {
                  List<Note> noteBackup = List.from(selectionList);
                  int selectionListLenght = selectionList.length;

                  for (int i = 0; i < selectionListLenght; i++) {
                    await NoteHelper.update(
                      noteList
                          .firstWhere((note) => note == selectionList[i])
                          .copyWith(isArchived: 1, isDeleted: 0, isStarred: 0),
                    );
                  }

                  bool multipleItems = selectionListLenght > 1;
                  selectionList.clear();

                  noteList.forEach((item) {
                    item.isSelected = false;
                  });

                  List<Note> list =
                      await NoteHelper.getNotes(appInfo.sortMode, currentView);

                  setState(() {
                    noteList = list;
                    isSelectorVisible = false;
                    syncing = true;
                    queueList.add(1);
                  });

                  scaffoldKey.currentState.removeCurrentSnackBar();
                  scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(multipleItems
                          ? locales.notes_archive_snackbar
                          : locales.note_archive_snackbar),
                      action: SnackBarAction(
                        label: locales.undo,
                        onPressed: () async {
                          for (int i = 0; i < noteBackup.length; i++) {
                            await NoteHelper.insert(
                                noteBackup[i].copyWith(isArchived: 0));
                          }

                          List<Note> list = await NoteHelper.getNotes(
                              appInfo.sortMode, currentView);
                          setState(() {
                            noteList = list;
                            syncing = true;
                            queueList.add(1);
                          });

                          for (int i = 0; i < noteBackup.length; i++) {
                            if (appInfo.userToken != null) {
                              await OnlineNoteHelper.save(
                                  noteBackup[i].copyWith(isArchived: 0));
                            }
                          }

                          queueList.removeLast();
                          if (queueList.length == 0) {
                            setState(() => syncing = false);
                          }
                        },
                      ),
                    ),
                  );

                  for (int i = 0; i < noteBackup.length; i++) {
                    if (appInfo.userToken != null) {
                      await OnlineNoteHelper.save(noteBackup[i]
                          .copyWith(isArchived: 1, isDeleted: 0, isStarred: 0));
                    }
                  }

                  queueList.removeLast();
                  if (queueList.length == 0) {
                    setState(() => syncing = false);
                  }
                },
              ),
            ),
            Visibility(
              visible: currentView != NotesReturnMode.NORMAL,
              child: IconButton(
                icon: Icon(
                  OMIcons.settingsBackupRestore,
                ),
                onPressed: () async {
                  if (currentView == NotesReturnMode.ARCHIVED) {
                    List<Note> noteBackup = List.from(selectionList);

                    for (int i = 0; i < selectionList.length; i++) {
                      await NoteHelper.update(
                        noteList
                            .firstWhere((note) => note == selectionList[i])
                            .copyWith(isArchived: 0),
                      );
                    }

                    selectionList.clear();

                    noteList.forEach((item) {
                      item.isSelected = false;
                    });

                    List<Note> list = await NoteHelper.getNotes(
                        appInfo.sortMode, currentView);

                    setState(() {
                      noteList = list;
                      isSelectorVisible = false;
                      syncing = true;
                      queueList.add(1);
                    });

                    scaffoldKey.currentState.removeCurrentSnackBar();
                    scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(noteBackup.length > 1
                            ? locales.notes_removeFromArchive_snackbar
                            : locales.note_removeFromArchive_snackbar),
                        action: SnackBarAction(
                          label: locales.undo,
                          onPressed: () async {
                            for (int i = 0; i < noteBackup.length; i++) {
                              await NoteHelper.insert(
                                  noteBackup[i].copyWith(isArchived: 1));
                            }

                            List<Note> list = await NoteHelper.getNotes(
                                appInfo.sortMode, currentView);
                            setState(() {
                              noteList = list;
                              syncing = true;
                              queueList.add(1);
                            });

                            for (int i = 0; i < noteBackup.length; i++) {
                              if (appInfo.userToken != null) {
                                await OnlineNoteHelper.save(
                                    noteBackup[i].copyWith(isArchived: 1));
                              }
                            }

                            queueList.removeLast();
                            if (queueList.length == 0) {
                              setState(() => syncing = false);
                            }
                          },
                        ),
                      ),
                    );

                    for (int i = 0; i < noteBackup.length; i++) {
                      if (appInfo.userToken != null) {
                        await OnlineNoteHelper.save(
                            noteBackup[i].copyWith(isArchived: 0));
                      }
                    }

                    queueList.removeLast();

                    if (queueList.length == 0) {
                      setState(() => syncing = false);
                    }
                  } else if (currentView == NotesReturnMode.DELETED) {
                    List<Note> noteBackup = List.from(selectionList);

                    for (int i = 0; i < selectionList.length; i++) {
                      await NoteHelper.update(
                        noteList
                            .firstWhere((note) => note == selectionList[i])
                            .copyWith(isDeleted: 0),
                      );
                    }

                    selectionList.clear();

                    noteList.forEach((item) {
                      item.isSelected = false;
                    });

                    List<Note> list = await NoteHelper.getNotes(
                        appInfo.sortMode, currentView);

                    setState(() {
                      noteList = list;
                      isSelectorVisible = false;
                      syncing = true;
                      queueList.add(1);
                    });

                    scaffoldKey.currentState.removeCurrentSnackBar();
                    scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(noteBackup.length > 1
                            ? locales.notes_restore_snackbar
                            : locales.note_restore_snackbar),
                        action: SnackBarAction(
                          label: locales.undo,
                          onPressed: () async {
                            for (int i = 0; i < noteBackup.length; i++) {
                              await NoteHelper.insert(
                                  noteBackup[i].copyWith(isDeleted: 1));

                              if (appInfo.userToken != null) {
                                await OnlineNoteHelper.save(
                                    noteBackup[i].copyWith(isDeleted: 1));
                              }
                            }

                            List<Note> list = await NoteHelper.getNotes(
                                appInfo.sortMode, currentView);
                            setState(() {
                              noteList = list;
                              syncing = true;
                              queueList.add(1);
                            });

                            for (int i = 0; i < noteBackup.length; i++) {
                              if (appInfo.userToken != null) {
                                await OnlineNoteHelper.save(
                                    noteBackup[i].copyWith(isDeleted: 1));
                              }
                            }

                            queueList.removeLast();
                            if (queueList.length == 0) {
                              setState(() => syncing = false);
                            }
                          },
                        ),
                      ),
                    );

                    for (int i = 0; i < noteBackup.length; i++) {
                      if (appInfo.userToken != null) {
                        await OnlineNoteHelper.save(
                            noteBackup[i].copyWith(isDeleted: 0));
                      }
                    }

                    queueList.removeLast();

                    if (queueList.length == 0) {
                      setState(() => syncing = false);
                    }
                  }
                },
              ),
            ),
            PopupMenuButton(
              icon: Icon(OMIcons.moreVert, color: appInfo.mainColor),
              onSelected: null,
              itemBuilder: (context) {
                return [
                  (selectionList.length == 1
                      ? PopupMenuItem(
                          enabled: false,
                          child: ListTile(
                            title: Text(locales.note_share),
                            onTap: () {
                              String shareText = "";

                              if (selectionList[0].title != "")
                                shareText += selectionList[0].title + "\n\n";
                              shareText += selectionList[0].content;

                              Share.share(shareText);
                              Navigator.pop(context);

                              noteList.forEach((item) {
                                item.isSelected = false;
                              });

                              setState(() {
                                selectionList.clear();
                                isSelectorVisible = false;
                              });
                            },
                          ),
                        )
                      : null),
                  PopupMenuItem(
                    enabled: false,
                    child: ListTile(
                      title: Text(locales.note_export),
                      onTap: () async {
                        Navigator.pop(context);

                        if (appInfo.storageStatus == PermissionStatus.granted) {
                          DateTime now = DateTime.now();

                          bool backupDirExists = await Directory(
                                  '/storage/emulated/0/PotatoNotes/exported')
                              .exists();

                          if (!backupDirExists) {
                            await Directory(
                                    '/storage/emulated/0/PotatoNotes/exported')
                                .create(recursive: true);
                          }

                          for (int i = 0; i < selectionList.length; i++) {
                            Note curNote = noteList
                                .firstWhere((note) => note == selectionList[i]);

                            String noteExportPath =
                                '/storage/emulated/0/PotatoNotes/exported/exported_note_' +
                                    DateFormat("dd-MM-yyyy_HH-mm").format(now) +
                                    '_' +
                                    curNote.id.toString() +
                                    '.md';

                            String noteContents = "";

                            if (curNote.title != "")
                              noteContents += "# " + curNote.title + "\n\n";

                            noteContents += curNote.content;

                            File(noteExportPath).writeAsString(noteContents);
                          }

                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(locales.done),
                            elevation: 3,
                          ));
                        } else {
                          await PermissionHandler()
                              .requestPermissions([PermissionGroup.storage]);
                          appInfo.storageStatus = await PermissionHandler()
                              .checkPermissionStatus(PermissionGroup.storage);
                        }

                        noteList.forEach((item) {
                          item.isSelected = false;
                        });

                        setState(() {
                          selectionList.clear();
                          isSelectorVisible = false;
                        });
                      },
                    ),
                  ),
                  (selectionList.length == 1
                      ? PopupMenuItem(
                          enabled: false,
                          child: ListTile(
                            title: Text(locales.note_pinToNotifs),
                            enabled: !appInfo.notificationsIdList
                                .contains(selectionList[0].id.toString()),
                            onTap: () async {
                              appInfo.notificationsIdList
                                  .add(selectionList[0].id.toString());
                              await FlutterLocalNotificationsPlugin().show(
                                  int.parse(appInfo.notificationsIdList.last),
                                  selectionList[0].title != ""
                                      ? selectionList[0].title
                                      : "Pinned note",
                                  selectionList[0].content,
                                  NotificationDetails(
                                      AndroidNotificationDetails(
                                        '0',
                                        'note_pinned_notifications',
                                        'idk',
                                        priority: Priority.High,
                                        playSound: true,
                                        importance: Importance.High,
                                        ongoing: true,
                                      ),
                                      IOSNotificationDetails()),
                                  payload: selectionList[0].id.toString());
                              Navigator.pop(context);

                              noteList.forEach((item) {
                                item.isSelected = false;
                              });

                              setState(() {
                                selectionList.clear();
                                isSelectorVisible = false;
                              });
                            },
                          ),
                        )
                      : null),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> noteListBuilder(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    if (!appInfo.isGridView) {
      List<Widget> pinnedNotes = List<Widget>();
      List<Widget> normalNotes = List<Widget>();

      pinnedNotes.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Text(
          locales.notesMainPageRoute_starred,
          style: TextStyle(
              fontSize: 14.0,
              color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                  .withAlpha(0.4)
                  .toColor()),
        ),
      ));

      for (int i = 0; i < noteList.length; i++) {
        int bIndex = (noteList.length - 1) - i;
        if (noteList[bIndex].isStarred == 1) {
          pinnedNotes.add(noteListItem(context, bIndex, false));
        }
      }

      for (int i = 0; i < noteList.length; i++) {
        int bIndex = (noteList.length - 1) - i;
        if (noteList[bIndex].isStarred == 0) {
          normalNotes.add(noteListItem(context, bIndex, false));
        }
      }

      pinnedNotes.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Text(
          locales.notesMainPageRoute_other,
          style: TextStyle(
              fontSize: 14.0,
              color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                  .withAlpha(0.4)
                  .toColor()),
        ),
      ));

      return <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            pinnedNotes.length > 2
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: pinnedNotes,
                  )
                : Container(),
            normalNotes.length > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: normalNotes,
                  )
                : Container(),
          ],
        ),
      ];
    } else {
      List<int> pinnedIndexes = List<int>();
      List<int> normalIndexes = List<int>();
      List<Widget> pinnedWidgets = List<Widget>();
      List<Widget> normalWidgets = List<Widget>();

      pinnedWidgets.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Text(
          locales.notesMainPageRoute_starred,
          style: TextStyle(
              fontSize: 14.0,
              color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                  .withAlpha(0.4)
                  .toColor()),
        ),
      ));

      for (int i = 0; i < noteList.length; i++) {
        if (noteList[i].isStarred == 1) {
          pinnedIndexes.add(i);
        }
      }

      for (int i = 0; i < noteList.length; i++) {
        if (noteList[i].isStarred == 0) {
          normalIndexes.add(i);
        }
      }

      Widget pinnedGrid = noteGridBuilder(context, pinnedIndexes);
      Widget normalGrid = noteGridBuilder(context, normalIndexes);

      if (pinnedGrid != null) pinnedWidgets.add(pinnedGrid);

      if (normalGrid != null) normalWidgets.add(normalGrid);

      pinnedWidgets.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Text(
          locales.notesMainPageRoute_other,
          style: TextStyle(
              fontSize: 14.0,
              color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                  .withAlpha(0.4)
                  .toColor()),
        ),
      ));

      return <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            pinnedWidgets.length > 2
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: pinnedWidgets,
                  )
                : Container(),
            normalWidgets.length > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: normalWidgets,
                  )
                : Container(),
          ],
        ),
      ];
    }
  }

  Widget noteGridBuilder(BuildContext context, List<int> indexes) {
    List<Widget> columnOne = List<Widget>();
    List<Widget> columnTwo = List<Widget>();

    bool secondColumnFirst = false;

    if ((indexes.length - 1).isEven) {
      secondColumnFirst = false;
    } else {
      secondColumnFirst = true;
    }

    for (int i = 0; i < indexes.length; i++) {
      int bIndex = (indexes.length - 1) - i;
      if (bIndex.isEven) {
        columnOne.add(noteListItem(context, indexes[bIndex], true));
      } else {
        columnTwo.add(noteListItem(context, indexes[bIndex], true));
      }
    }

    if (indexes.length > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2 - 4,
            child: Column(
              children: secondColumnFirst ? columnTwo : columnOne,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2 - 4,
            child: Column(
              children: secondColumnFirst ? columnOne : columnTwo,
            ),
          ),
        ],
      );
    } else
      return null;
  }

  void _addNoteCaller(BuildContext context) async {
    final Note emptyNote = Note(
      id: null,
      title: "",
      content: "",
      isStarred: 0,
      date: 0,
      color: null,
      imagePath: null,
      isList: 0,
      listParseString: null,
      reminders: null,
      hideContent: 0,
      pin: null,
      password: null,
    );

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifyNotesRoute(
            note: emptyNote,
            heroIndex: "",
            autofocus: true,
          ),
        ));

    Brightness systemBarsIconBrightness =
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark;

    changeSystemBarsColors(
        Theme.of(context).scaffoldBackgroundColor, systemBarsIconBrightness);

    if (result != null) {
      setState(() {
        noteList = result;
        syncing = true;
        queueList.add(1);
      });

      if (appInfo.userToken != null) {
        await OnlineNoteHelper.save(noteList.last);
      }

      queueList.removeLast();
      if (queueList.length == 0) setState(() => syncing = false);
    }
  }

  void _editNoteCaller(
      BuildContext context, Note note, String heroIndex) async {
    if (note.hideContent == 1 && (note.pin != null || note.password != null)) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SecurityNoteRoute(
                  note: note, heroIndex: heroIndex.toString())));
    } else {
      await Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200),
            pageBuilder: (_, __, ___) =>
                ModifyNotesRoute(note: note, heroIndex: heroIndex.toString()),
          ));
    }

    Brightness systemBarsIconBrightness =
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark;

    changeSystemBarsColors(
        Theme.of(context).scaffoldBackgroundColor, systemBarsIconBrightness);

    List<Note> list = await NoteHelper.getNotes(appInfo.sortMode, currentView);

    setState(() {
      noteList = list;
      syncing = true;
      queueList.add(1);
    });

    if (appInfo.userToken != null) {
      await OnlineNoteHelper.save(noteList.last);
    }

    queueList.removeLast();
    if (queueList.length == 0) setState(() => syncing = false);
  }

  void _searchNoteCaller(
      BuildContext context, List<Note> noteList, Color returnBarsColor) async {
    SearchFiltersProvider searchFilters =
        Provider.of<SearchFiltersProvider>(context);

    searchFilters.color = null;
    searchFilters.date = null;
    searchFilters.caseSensitive = false;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchNotesRoute(noteList: noteList)));

    if (result != null) setState(() => noteList = result);
  }

  void _settingsCaller(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsRoute()));

    List<Note> list = await NoteHelper.getNotes(appInfo.sortMode, currentView);
    setState(() => noteList = list);
  }

  Widget noteListItem(BuildContext context, int index, bool oneSideOnly) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    double getAlphaFromTheme() {
      if (Theme.of(context).brightness == Brightness.light) {
        return 0.1;
      } else {
        return 0.2;
      }
    }

    Color cardColor = Theme.of(context).textTheme.title.color;

    double cardBrightness = getAlphaFromTheme();

    Color borderColor =
        HSLColor.fromColor(cardColor).withAlpha(cardBrightness).toColor();

    Color getTextColorFromNoteColor(int index, bool isContent) {
      double noteColorBrightness =
          Color(noteList[index].color).computeLuminance();
      Color contentWhite =
          HSLColor.fromColor(Colors.white).withAlpha(0.7).toColor();
      Color contentBlack =
          HSLColor.fromColor(Colors.black).withAlpha(0.7).toColor();

      if (noteColorBrightness > 0.5) {
        return isContent ? contentBlack : Colors.black;
      } else {
        return isContent ? contentWhite : Colors.white;
      }
    }

    Color getBorderColor() {
      if (noteList[index].isSelected) {
        if (noteList[index].color != null) {
          return Theme.of(context).textTheme.title.color;
        } else {
          return Theme.of(context).accentColor;
        }
      } else if (noteList[index].color != null) {
        return Colors.transparent;
      } else {
        if (Theme.of(context).brightness == Brightness.light) {
          return borderColor;
        } else {
          if (appInfo.followSystemTheme) {
            if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
              return Colors.transparent;
            } else {
              return borderColor;
            }
          } else {
            if (appInfo.themeMode != 0) {
              return Colors.transparent;
            } else {
              return borderColor;
            }
          }
        }
      }
    }

    return Hero(
      createRectTween: (Rect begin, Rect end) {
        return MaterialRectArcTween(begin: begin, end: end);
      },
      tag: "note" + index.toString(),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: getBorderColor(), width: 2),
        ),
        color: noteList[index].color == null
            ? (Theme.of(context).brightness == Brightness.light
                ? null
                : Theme.of(context).scaffoldBackgroundColor)
            : Color(noteList[index].color),
        child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () {
              if (isSelectorVisible) {
                setState(() {
                  noteList[index].isSelected = !noteList[index].isSelected;
                  if (noteList[index].isSelected) {
                    selectionList.add(noteList[index]);
                  } else {
                    selectionList.remove(noteList[index]);
                    if (selectionList.length == 0) {
                      isSelectorVisible = false;
                    }
                  }
                });
              } else {
                _editNoteCaller(context, noteList[index], index.toString());
              }
            },
            onDoubleTap: isSelectorVisible
                ? null
                : appInfo.isQuickStarredGestureOn
                    ? () => toggleStarNote(index)
                    : null,
            onLongPress: () {
              if (!isSelectorVisible)
                setState(() {
                  isSelectorVisible = true;
                  noteList[index].isSelected = true;
                  selectionList.add(noteList[index]);
                });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: noteList[index].imagePath != null,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      child: noteList[index].imagePath == null
                          ? Container()
                          : Center(
                              child: CachedNetworkImage(
                                imageUrl: noteList[index].imagePath,
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
                                            EdgeInsets.symmetric(vertical: 40),
                                        child: Opacity(
                                          opacity: animation,
                                          child: Icon(
                                            Icons.image,
                                            size: 56,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            )),
                ),
                Visibility(
                  visible: noteList[index].hideContent == 1 ||
                      noteList[index].reminders != null,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        20,
                        14,
                        20,
                        noteList[index].hideContent == 1 &&
                                noteList[index].title == ""
                            ? 14
                            : 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                          visible: noteList[index].reminders != null,
                          child: Center(
                            child: Icon(
                              Icons.alarm,
                              size: 12,
                              color: noteList[index].color == null
                                  ? Theme.of(context)
                                      .textTheme
                                      .title
                                      .color
                                      .withAlpha(140)
                                  : getTextColorFromNoteColor(index, false),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: noteList[index].hideContent == 1,
                          child: Center(
                            child: Icon(
                              noteList[index].pin != null ||
                                      noteList[index].password != null
                                  ? Icons.lock
                                  : Icons.remove_red_eye,
                              size: 12,
                              color: noteList[index].color == null
                                  ? Theme.of(context)
                                      .textTheme
                                      .title
                                      .color
                                      .withAlpha(140)
                                  : getTextColorFromNoteColor(index, false),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (noteList[index].hideContent == 1 &&
                                  noteList[index].reminders == null) ||
                              (noteList[index].hideContent == 0 &&
                                  noteList[index].reminders != null),
                          child: Container(
                            padding: EdgeInsets.only(left: 8),
                            width: oneSideOnly
                                ? MediaQuery.of(context).size.width / 2 - 80
                                : MediaQuery.of(context).size.width - 100,
                            child: (noteList[index].hideContent == 1 &&
                                    noteList[index].reminders == null)
                                ? Text(
                                    locales
                                        .notesMainPageRoute_note_hiddenContent,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: noteList[index].color == null
                                          ? Theme.of(context)
                                              .textTheme
                                              .title
                                              .color
                                              .withAlpha(140)
                                          : getTextColorFromNoteColor(
                                              index, false),
                                    ),
                                  )
                                : (noteList[index].hideContent == 0 &&
                                        noteList[index].reminders != null)
                                    ? Text(
                                        locales
                                            .notesMainPageRoute_note_remindersSet,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: noteList[index].color == null
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .title
                                                  .color
                                                  .withAlpha(140)
                                              : getTextColorFromNoteColor(
                                                  index, false),
                                        ),
                                      )
                                    : Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: appInfo.devShowIdLabels,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: Text(
                      "Note id: " + noteList[index].id.toString(),
                      style: TextStyle(
                        color: noteList[index].color == null
                            ? null
                            : getTextColorFromNoteColor(index, false),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: noteList[index].title != "",
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 14, 20, 0),
                    width: oneSideOnly
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        noteList[index].title ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: TextStyle(
                          color: noteList[index].color == null
                              ? Theme.of(context)
                                  .textTheme
                                  .title
                                  .color
                                  .withAlpha(220)
                              : getTextColorFromNoteColor(index, false),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: noteList[index].hideContent == 0,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        20, noteList[index].title == "" ? 14 : 0, 20, 14),
                    width: oneSideOnly
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width,
                    child: noteList[index].isList == 1
                        ? Column(
                            children: generateListWidgets(index, oneSideOnly),
                          )
                        : Text(
                            noteList[index].content ?? "",
                            overflow: TextOverflow.ellipsis,
                            textWidthBasis: TextWidthBasis.parent,
                            maxLines: 11,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: noteList[index].color == null
                                  ? Theme.of(context)
                                      .textTheme
                                      .title
                                      .color
                                      .withAlpha(180)
                                  : getTextColorFromNoteColor(index, true),
                            ),
                          ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  List<Widget> generateListWidgets(int index, bool oneSideOnly) {
    List<Widget> widgets = List<Widget>();
    List<ListPair> checkedList = List<ListPair>();
    List<ListPair> uncheckedList = List<ListPair>();

    Color getTextColorFromNoteColor(int index, bool isContent) {
      double noteColorBrightness =
          Color(noteList[index].color).computeLuminance();
      Color contentWhite =
          HSLColor.fromColor(Colors.white).withAlpha(0.7).toColor();
      Color contentBlack =
          HSLColor.fromColor(Colors.black).withAlpha(0.7).toColor();

      if (noteColorBrightness > 0.5) {
        return isContent ? contentBlack : Colors.black;
      } else {
        return isContent ? contentWhite : Colors.white;
      }
    }

    List<String> rawList = noteList[index].listParseString.split("\'..\'");

    for (int i = 0; i < rawList.length; i++) {
      List<dynamic> rawStrings = rawList[i].split("\',,\'");

      int checkValue = rawStrings[0] == "" ? 0 : int.parse(rawStrings[0]);

      if (checkValue == 1) {
        try {
          checkedList
              .add(ListPair(checkValue: checkValue, title: rawStrings[1]));
        } on RangeError {}
      } else {
        try {
          uncheckedList
              .add(ListPair(checkValue: checkValue, title: rawStrings[1]));
        } on RangeError {}
      }
    }

    for (int i = 0; i < uncheckedList.length; i++) {
      widgets.add(Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(Icons.check_box_outline_blank,
              size: 14,
              color: noteList[index].color == null
                  ? Theme.of(context).iconTheme.color
                  : getTextColorFromNoteColor(index, true)),
          Container(
            padding: EdgeInsets.only(left: 6, top: 4, bottom: 4),
            width: oneSideOnly
                ? MediaQuery.of(context).size.width / 2 - 88
                : MediaQuery.of(context).size.width - 108,
            child: Text(
              uncheckedList[i].title,
              overflow: TextOverflow.ellipsis,
              textWidthBasis: TextWidthBasis.parent,
              style: TextStyle(
                  color: noteList[index].color == null
                      ? Theme.of(context).textTheme.title.color
                      : getTextColorFromNoteColor(index, true)),
            ),
          )
        ],
      ));
    }

    for (int i = 0; i < checkedList.length; i++) {
      widgets.add(Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(Icons.check_box,
              size: 14,
              color: noteList[index].color == null
                  ? Theme.of(context).iconTheme.color
                  : getTextColorFromNoteColor(index, true)),
          Container(
            padding: EdgeInsets.only(left: 6, top: 4, bottom: 4),
            width: oneSideOnly
                ? MediaQuery.of(context).size.width / 2 - 88
                : MediaQuery.of(context).size.width - 108,
            child: Text(
              checkedList[i].title,
              overflow: TextOverflow.ellipsis,
              textWidthBasis: TextWidthBasis.parent,
              style: TextStyle(
                color: noteList[index].color == null
                    ? Theme.of(context).textTheme.title.color
                    : getTextColorFromNoteColor(index, true),
                decoration: TextDecoration.lineThrough,
              ),
            ),
          )
        ],
      ));
    }

    /*if (checkedList.length != 0) {
      widgets.add(Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(Icons.add,
              size: 14,
              color: noteList[index].color == null
                  ? Theme.of(context).iconTheme.color
                  : getTextColorFromNoteColor(index, true)),
          Container(
            width: oneSideOnly
                ? MediaQuery.of(context).size.width / 2 - 88
                : MediaQuery.of(context).size.width - 108,
            padding: EdgeInsets.only(left: 6, top: 4, bottom: 4),
            child: Text(
              checkedList.length.toString() +
                  locales.notesMainPageRoute_note_list_selectedEntries,
              style: TextStyle(
                  color: noteList[index].color == null
                      ? Theme.of(context).textTheme.title.color
                      : getTextColorFromNoteColor(index, true)),
            ),
          )
        ],
      ));
    }*/

    return widgets;
  }

  void toggleStarNote(int index) async {
    if (noteList[index].isStarred == 0) {
      await NoteHelper.update(
        noteList[index].copyWith(isStarred: 1),
      );
      List<Note> list =
          await NoteHelper.getNotes(appInfo.sortMode, currentView);
      setState(() => noteList = list);
    } else if (noteList[index].isStarred == 1) {
      await NoteHelper.update(
        noteList[index].copyWith(isStarred: 0),
      );
      List<Note> list =
          await NoteHelper.getNotes(appInfo.sortMode, currentView);
      setState(() => noteList = list);
    }
  }
}

class AutoSyncExecutor {
  Timer timer;
  bool isRunning = false;

  AutoSyncExecutor(int timeout, Function(Timer) callback) {
    timer = Timer.periodic(Duration(seconds: timeout), callback);
    isRunning = true;
  }

  stop() {
    timer.cancel();
    isRunning = false;
  }

  update(int timeout, Function(Timer) callback) {
    timer.cancel();
    timer = Timer.periodic(Duration(seconds: timeout), callback);
    isRunning = true;
  }
}
