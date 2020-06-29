import 'dart:io';

import 'package:animations/animations.dart';
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
import 'package:potato_notes/routes/draw_page.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/routes/settings_page.dart';
import 'package:potato_notes/widget/accented_icon.dart';
import 'package:potato_notes/widget/dismissible_route.dart';
import 'package:potato_notes/widget/drawer_list.dart';
import 'package:potato_notes/widget/fake_fab.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/notes_logo.dart';
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

    final localAppInfo = Provider.of<AppInfoProvider>(context, listen: false);
    final localHelper = locator<NoteHelper>();

    localAppInfo.quickActions.initialize((shortcutType) async {
      switch (shortcutType) {
        case 'new_text':
          newNote();
          break;
        case 'new_image':
          newImage(ImageSource.gallery, localHelper);
          break;
        case 'new_drawing':
          newDrawing();
          break;
        case 'new_list':
          newList();
          break;
      }
    });

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

    return Row(
      children: <Widget>[
        Visibility(
          visible: MediaQuery.of(context).orientation == Orientation.landscape,
          child: SizedBox(
            width:
                numOfColumns >= 4 ? MediaQuery.of(context).size.width / 5 : 64,
            child: getDrawer(numOfColumns >= 4, true),
          ),
        ),
        Expanded(
          child: Scaffold(
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
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage())),
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
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: child,
                  ),
                );
              },
            ),
            extendBodyBehindAppBar: true,
            floatingActionButton:
                mode == ReturnMode.NORMAL && !selecting ? fab : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            drawer: MediaQuery.of(context).orientation == Orientation.portrait
                ? Drawer(
                    child: getDrawer(true, false),
                  )
                : null,
            drawerScrimColor: Colors.transparent,
            drawerEdgeDragWidth: MediaQuery.of(context).size.width,
          ),
        ),
      ],
    );
  }

  Widget getDrawer(bool extended, bool fixed) {
    Color notesLogoPenColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey[900];

    return SafeArea(
      child: DrawerList(
        items: Utils.getDestinations(mode),
        header: extended
            ? Container(
                height: 64,
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    NotesLogo(penColor: notesLogoPenColor),
                    SizedBox(width: 16),
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
              )
            : Container(
                width: 64,
                alignment: Alignment.center,
                child: NotesLogo(penColor: notesLogoPenColor),
              ),
        footer: extended
            ? ListTile(
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
                  if (!fixed) {
                    Navigator.pop(context);
                  }

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              )
            : Container(
                height: 64,
                child: IconButton(
                  icon: Icon(CustomIcons.settings_outline),
                  onPressed: () {
                    if (!fixed) {
                      Navigator.pop(context);
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                ),
              ),
        currentIndex: mode.index - 1,
        onTap: (index) async {
          if (!fixed) {
            Navigator.pop(context);
          }

          await controller.animateBack(0);
          setState(() => mode = ReturnMode.values[index + 1]);
          controller.animateTo(1);
        },
        showTitles: extended,
      ),
    );
  }

  Widget get fab {
    return Hero(
      tag: "fabMenu",
      child: FakeFab(
        onLongPress: () => Utils.showFabMenu(context, fabOptions),
        key: GlobalKeyRegistry.get("fab"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        onTap: () => newNote(),
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

          newNote();
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

          newList();
        },
      ),
      ListTile(
        leading: AccentedIcon(OMIcons.image),
        title: Text(
          "Image from gallery",
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => newImage(ImageSource.gallery, helper, shouldPop: true),
      ),
      ListTile(
        leading: AccentedIcon(OMIcons.cameraAlt),
        title: Text(
          "Image from camera",
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => newImage(ImageSource.camera, helper, shouldPop: true),
      ),
      ListTile(
        leading: AccentedIcon(OMIcons.brush),
        title: Text(
          "Drawing",
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.pop(context);

          newDrawing();
        },
      ),
    ];
  }

  void newNote() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NotePage(
          numOfImages: numOfImages,
        ),
      ),
    );
  }

  void newImage(ImageSource source, NoteHelper localHelper,
      {bool shouldPop = false}) async {
    Note note = Utils.emptyNote;
    PickedFile image = await ImagePicker().getImage(source: source);

    if (image != null) {
      note.images.data[image.path] = File(image.path).uri;

      if (shouldPop) Navigator.pop(context);
      note = note.copyWith(id: await Utils.generateId());

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NotePage(
            numOfImages: numOfImages,
            note: note,
          ),
        ),
      );

      localHelper.saveNote(note);
    }
  }

  void newList() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NotePage(
          numOfImages: numOfImages,
          openWithList: true,
        ),
      ),
    );
  }

  void newDrawing() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NotePage(
          numOfImages: numOfImages,
          openWithDrawing: true,
        ),
      ),
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
