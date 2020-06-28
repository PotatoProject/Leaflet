import 'dart:io';

import 'package:animations/animations.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/custom_icons.dart';
import 'package:potato_notes/internal/global_key_registry.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/locator.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/routes/settings_page.dart';
import 'package:potato_notes/widget/accented_icon.dart';
import 'package:potato_notes/widget/drawer_list.dart';
import 'package:potato_notes/widget/drawer_list_tile.dart';
import 'package:potato_notes/widget/fake_fab.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/selection_bar.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int numOfColumns;
  int numOfImages;
  AnimationController controller;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  AppInfoProvider appInfo;

  ReturnMode mode = ReturnMode.NORMAL;
  bool selecting = false;
  List<Note> selectionList = [];

  Map<ReturnMode, List<Note>> cachedNotesMap = {
    ReturnMode.NORMAL: [],
    ReturnMode.ARCHIVE: [],
    ReturnMode.TRASH: [],
    ReturnMode.FAVOURITES: [],
  };

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 100),
      value: 1,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (appInfo == null) appInfo = Provider.of<AppInfoProvider>(context);
    final helper = locator<NoteHelper>();
    final prefs = Provider.of<Preferences>(context);

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

    Animation<double> fade =
        Tween<double>(begin: 0.3, end: 1).animate(controller);

    return Scaffold(
      key: scaffoldKey,
      appBar: selecting
          ? SelectionBar(
              selectionList: selectionList,
              onCloseSelection: () => setState(() {
                selecting = false;
                selectionList.clear();
              }),
              currentMode: mode,
            )
          : AppBar(
              title: Text(Utils.getNameFromMode(mode)),
              textTheme: Theme.of(context).textTheme,
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage())),
                ),
                IconButton(
                  icon: Icon(OMIcons.person),
                  onPressed: () => scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text("Not yet..."),
                    ),
                  ),
                ),
              ],
            ),
      body: StreamBuilder<List<Note>>(
        stream: helper.noteStream(mode),
        initialData: cachedNotesMap[mode],
        builder: (context, snapshot) {
          EdgeInsets padding = EdgeInsets.fromLTRB(
            4,
            4 + MediaQuery.of(context).padding.top,
            4,
            4,
          );

          Widget child;
          List<Note> notes = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            notes = cachedNotesMap[mode];
          } else if (snapshot.connectionState == ConnectionState.active) {
            cachedNotesMap[mode] = snapshot.data;
          }

          if (notes.isNotEmpty) {
            if (prefs.useGrid) {
              child = StaggeredGridView.countBuilder(
                crossAxisCount: numOfColumns,
                itemBuilder: (context, index) => commonNote(notes[index]),
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                itemCount: notes.length,
                padding: padding,
              );
            } else {
              child = ListView.builder(
                itemBuilder: (context, index) => commonNote(notes[index]),
                itemCount: notes.length,
                padding: padding,
              );
            }
          } else {
            child = Center(
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
          }

          return FadeScaleTransition(
            animation: fade,
            child: child,
          );
        },
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton:
          mode == ReturnMode.NORMAL && !selecting ? fab : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: Drawer(
        elevation: 16,
        child: DrawerList(
          onTap: (index) async {
            Navigator.pop(context);
            await controller.animateBack(0);
            setState(() => mode = ReturnMode.values[index + 1]);
            controller.animateTo(1);
          },
          header: Container(
            height: 64,
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/notes.png",
                  height: 36,
                ),
                SizedBox(width: 8),
                Text(
                  "PotatoNotes",
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          footer: ListTile(
            leading: Icon(CustomIcons.settings_outline),
            title: Text(
              "Settings",
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .color
                    .withOpacity(0.7),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 24),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          currentIndex: mode.index - 1,
          items: [
            DrawerListTileData(
              icon: Icon(CommunityMaterialIcons.home_variant_outline),
              activeIcon: Icon(CommunityMaterialIcons.home_variant),
              title: Text(Utils.getNameFromMode(ReturnMode.NORMAL)),
            ),
            DrawerListTileData(
              icon: Icon(MdiIcons.archiveOutline),
              activeIcon: Icon(MdiIcons.archive),
              title: Text(Utils.getNameFromMode(ReturnMode.ARCHIVE)),
            ),
            DrawerListTileData(
              icon: Icon(CommunityMaterialIcons.trash_can_outline),
              activeIcon: Icon(CommunityMaterialIcons.trash_can),
              title: Text(Utils.getNameFromMode(ReturnMode.TRASH)),
            ),
            DrawerListTileData(
              icon: Icon(CommunityMaterialIcons.heart_multiple_outline),
              activeIcon: Icon(CommunityMaterialIcons.heart_multiple),
              title: Text(Utils.getNameFromMode(ReturnMode.FAVOURITES)),
            ),
          ],
        ),
      ),
      drawerScrimColor: Colors.transparent,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
    );
  }

  Widget get fab {
    return Hero(
      tag: "fabMenu",
      child: FakeFab(
        onLongPress: () => Utils.showFabMenu(context, fabOptions),
        key: GlobalKeyRegistry.get("fab"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotePage(
              numOfImages: numOfImages,
            ),
          ),
        ),
        child: Icon(OMIcons.edit),
      ),
    );
  }

  List<Widget> get fabOptions {
    final helper = locator<NoteHelper>();

    return [
      ListTile(
        leading: AccentedIcon(OMIcons.edit),
        title: Text(
          "Text note",
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.pop(context);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotePage(
                numOfImages: numOfImages,
              ),
            ),
          );
        },
      ),
      ListTile(
        leading: AccentedIcon(MdiIcons.checkboxMarkedOutline),
        title: Text(
          "List",
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.pop(context);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotePage(
                numOfImages: numOfImages,
                note: Utils.emptyNote.copyWith(list: true),
              ),
            ),
          );
        },
      ),
      ListTile(
        leading: AccentedIcon(OMIcons.image),
        title: Text(
          "Image from gallery",
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () async {
          Note note = Utils.emptyNote;
          PickedFile image =
              await ImagePicker().getImage(source: ImageSource.gallery);

          if (image != null) {
            note.images.data[image.path] = File(image.path).uri;

            Navigator.pop(context);
            note = note.copyWith(id: await Utils.generateId());

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotePage(
                  numOfImages: numOfImages,
                  note: note,
                ),
              ),
            );

            helper.saveNote(note);
          }
        },
      ),
      ListTile(
        leading: AccentedIcon(OMIcons.cameraAlt),
        title: Text(
          "Image from camera",
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () async {
          Note note = Utils.emptyNote;
          PickedFile image =
              await ImagePicker().getImage(source: ImageSource.camera);

          if (image != null) {
            note.images.data[image.path] = File(image.path).uri;

            Navigator.pop(context);
            note = note.copyWith(id: await Utils.generateId());

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotePage(
                  numOfImages: numOfImages,
                  note: note,
                ),
              ),
            );

            helper.saveNote(note);
          }
        },
      ),
    ];
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

        setState(() {
          selecting = true;
          selectionList.add(note);
        });
      },
      selected: selectionList.any((item) => item.id == note.id),
      numOfImages: numOfImages,
    );
  }
}
