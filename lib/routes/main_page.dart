import 'dart:convert';
import 'dart:ui';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/global_key_registry.dart';
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/locator.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/routes/settings_page.dart';
import 'package:potato_notes/widget/main_page_bar.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/selection_bar.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:spicy_components/spicy_components.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int numOfColumns;
  int numOfImages;
  AnimationController controller;

  AppInfoProvider appInfo;

  ReturnMode mode = ReturnMode.NORMAL;
  bool selecting = false;
  List<Note> selectionList = [];

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
    final helper = locator<NoteHelper>();
    final prefs = locator<Preferences>();

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
      appBar: AppBar(
        title: Text("PotatoNotes"),
        textTheme: Theme.of(context).textTheme,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchPage())),
          ),
          IconButton(
            icon: Icon(MdiIcons.cogOutline),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage())),
          ),
        ],
      ),
      body: StreamBuilder<List<Note>>(
        stream: helper.noteStream(mode),
        builder: (context, snapshot) {
          if ((snapshot.data?.length ?? 0) != 0) {
            return AnimatedBuilder(
              animation: Tween<double>(begin: 0, end: 1).animate(controller),
              builder: (context, child) {
                EdgeInsets padding = EdgeInsets.fromLTRB(
                  4,
                  4 + MediaQuery.of(context).padding.top,
                  4,
                  4,
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
                          padding: padding,
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) =>
                              commonNote(snapshot.data[index]),
                          itemCount: snapshot.data.length,
                          padding: padding,
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
      bottomNavigationBar: selecting
          ? SelectionBar(
              selectionList: selectionList,
              onCloseSelection: () {
                selecting = false;
                selectionList.clear();
              },
              currentMode: mode,
            )
          : MainPageBar(
              currentMode: mode,
              onReturnModeChange: (newMode) => mode = newMode,
            ),
      extendBodyBehindAppBar: true,
      floatingActionButton:
          mode == ReturnMode.NORMAL && !selecting ? fab : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget get fab {
    Color borderColor;
    double opacity =
        Theme.of(context).brightness == Brightness.light ? 0.1 : 0.2;

    borderColor =
        Theme.of(context).textTheme.caption.color.withOpacity(opacity);

    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotePage(
              numOfImages: numOfImages,
            ),
          ),
        );
      },
      child: Icon(OMIcons.edit),
      elevation: 2,
      disabledElevation: 0,
      focusElevation: 2,
      highlightElevation: 2,
      hoverElevation: 2,
    );
  }

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
      default:
        return MapEntry(appInfo.noNotesIllustration, "No notes were added yet");
    }
  }

  Widget commonNote(Note note) {
    GlobalKey key = GlobalKeyRegistry.get(note.id);

    return NoteView(
      key: key,
      note: note,
      onTap: () async {
        if (selecting) {
          setState(() {
            if (selectionList.any((item) => item.id == note.id)) {
              selectionList.removeWhere((item) => item.id == note.id);
              if (selectionList.isEmpty) selecting = false;
            } else {
              selectionList.add(note);
            }
          });
        } else {
          bool status = false;
          if (note.lockNote && note.usesBiometrics) {
            bool bioAuth =
                await LocalAuthentication().authenticateWithBiometrics(
              localizedReason: "",
              androidAuthStrings: AndroidAuthMessages(
                signInTitle: "Scan fingerprint to open note",
                fingerprintHint: "",
              ),
            );

            if (bioAuth)
              status = bioAuth;
            else
              status = await Utils.showPassChallengeSheet(context) ?? false;
          } else if (note.lockNote && !note.usesBiometrics) {
            status = await Utils.showPassChallengeSheet(context) ?? false;
          } else {
            status = true;
          }

          if (status) {
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
        }
      },
      onLongPress: () async {
        if (selecting) return;

        String action = await Utils.showNoteMenu(
          context: context,
          note: note,
          numOfImages: numOfImages,
          numOfColumns: numOfColumns,
        );

        if (action != null) {
          switch (action) {
            case 'select':
              setState(() {
                selecting = true;
                selectionList.add(note);
              });
              break;
            case 'pin':
              handlePinNotes(context, note);
              break;
            case 'share':
              bool status = note.lockNote
                  ? await Utils.showPassChallengeSheet(context)
                  : true;
              if (status ?? false) {
                Share.share(
                  (note.title.isNotEmpty ? note.title + "\n\n" : "") +
                      note.content,
                  subject: "PotatoNotes saved note",
                );
              }
              break;
          }
        }
      },
      selected: selectionList.any((item) => item.id == note.id),
      numOfImages: numOfImages,
    );
  }

  void handlePinNotes(BuildContext context, Note note) {
    appInfo.notifications.show(
      note.id,
      note.title.isEmpty ? "Pinned notification" : note.title,
      note.content,
      NotificationDetails(
        AndroidNotificationDetails(
          'pinned_notifications',
          'Pinned notifications',
          'User pinned notifications',
          color: Color(0xFFFF9100),
          ongoing: true,
        ),
        IOSNotificationDetails(),
      ),
      payload: json.encode(
        NotificationPayload(
          action: NotificationAction.PIN,
          id: note.id,
        ).toJson(),
      ),
    );
  }
}
