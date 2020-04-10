import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/widget/main_page_bar.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/selection_bar.dart';
import 'package:provider/provider.dart';
import 'package:spicy_components/spicy_components.dart';

class MainPage extends StatefulWidget {
  final List<Note> initialNotes;

  MainPage({this.initialNotes});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int numOfColumns;
  int numOfImages;
  AnimationController controller;

  AppInfoProvider appInfo;
  NoteHelper helper;
  Preferences prefs;

  ReturnMode mode = ReturnMode.NORMAL;
  bool selecting = false;
  List<int> selectionList = [];

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 150), value: 1);
    super.initState();
  }

  @override
  void dispose() {
    appInfo.accentSubscription.cancel();
    appInfo.themeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (appInfo == null) appInfo = Provider.of<AppInfoProvider>(context);
    if (helper == null) helper = Provider.of<NoteHelper>(context);
    if (prefs == null) prefs = Provider.of<Preferences>(context);

    double width = MediaQuery.of(context).size.width;

    if (width >= 1280) {
      numOfColumns = 5;
      numOfImages = 4;
    } else if (width >= 900) {
      numOfColumns = 4;
      numOfImages = 3;
    } else if (width >= 600) {
      numOfColumns = 3;
      numOfImages = 3;
    } else if (width >= 360) {
      numOfColumns = 2;
      numOfImages = 2;
    } else {
      numOfColumns = 1;
      numOfImages = 2;
    }

    return Scaffold(
      body: StreamBuilder<List<Note>>(
        initialData: widget.initialNotes,
        stream: helper.noteStream(mode),
        builder: (context, snapshot) {
          if ((snapshot.data?.length ?? 0) != 0) {
            return AnimatedBuilder(
              animation: Tween<double>(begin: 0, end: 1).animate(controller),
              builder: (context, child) {
                Widget commonNote(Note note) => NoteView(
                      note: note,
                      onTap: () {
                        if (selecting) {
                          setState(() {
                            if (selectionList.contains(note.id)) {
                              selectionList.remove(note.id);
                              if (selectionList.isEmpty) selecting = false;
                            } else {
                              selectionList.add(note.id);
                            }
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotePage(
                                note: note,
                                numOfImages: numOfImages,
                              ),
                            ),
                          );
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          selecting = true;
                          selectionList.add(note.id);
                        });
                      },
                      selected: selectionList.contains(note.id),
                      numOfImages: numOfImages,
                    );

                return Opacity(
                  opacity: controller.value,
                  child: prefs.useGrid
                      ? StaggeredGridView.countBuilder(
                          crossAxisCount: numOfColumns,
                          itemBuilder: (context, index) =>
                              commonNote(snapshot.data[index]),
                          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                          itemCount: snapshot.data.length,
                          padding: EdgeInsets.fromLTRB(
                            4,
                            4 + MediaQuery.of(context).padding.top,
                            4,
                            4.0 + 56,
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) =>
                              commonNote(snapshot.data[index]),
                          itemCount: snapshot.data.length,
                          padding: EdgeInsets.fromLTRB(
                            4,
                            4 + MediaQuery.of(context).padding.top,
                            4,
                            4.0 + 56,
                          ),
                        ),
                );
              },
            );
          } else
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getInfoOnCurrentMode.key,
                  SizedBox(height: 24),
                  Text(
                    getInfoOnCurrentMode.value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  )
                ],
              ),
            );
        },
      ),
      extendBody: true,
      bottomNavigationBar: selecting
          ? SelectionBar(
            selectionList: selectionList,
            onCloseSelection: () {
              selecting = false;
              selectionList.clear();
            },
          )
          : MainPageBar(
            controller: controller,
            currentMode: mode,
            onReturnModeChange: (newMode) => mode = newMode,
          ),
      floatingActionButton:
          mode == ReturnMode.NORMAL && !selecting ? fab : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget get fab => FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotePage(
                numOfImages: numOfImages,
              ),
            ),
          );
          appInfo.barManager.lightNavBarColor =
              SpicyThemes.light(appInfo.mainColor).cardColor;
          appInfo.barManager.darkNavBarColor =
              SpicyThemes.dark(appInfo.mainColor).cardColor;
        },
        child: Icon(OMIcons.edit),
        backgroundColor: Theme.of(context).accentColor,
      );

  MapEntry<Widget, String> get getInfoOnCurrentMode {
    switch (mode) {
      case ReturnMode.ALL:
      case ReturnMode.NORMAL:
        return MapEntry(appInfo.noNotesIllustration, "No notes were added yet");
      case ReturnMode.ARCHIVE:
        return MapEntry(
            appInfo.emptyArchiveIllustration, "The archive is empty");
      case ReturnMode.TRASH:
        return MapEntry(appInfo.emptyTrashIllustration, "The trash is empty");
    }
  }
}
