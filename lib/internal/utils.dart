import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/content_style.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/data/model/tag_list.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/global_key_registry.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/routes/about_page.dart';
import 'package:potato_notes/widget/bottom_sheet_base.dart';
import 'package:potato_notes/widget/dismissible_route.dart';
import 'package:potato_notes/widget/drawer_list.dart';
import 'package:potato_notes/widget/pass_challenge.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';

import 'locale_strings.dart';

const int kMaxImageCount = 4;
const double kCardBorderRadius = 6;
const EdgeInsets kCardPadding = const EdgeInsets.all(4);
const EdgeInsets kSecondaryRoutePadding = const EdgeInsets.symmetric(
  horizontal: 180,
  vertical: 64,
);
const EdgeInsets kTertiaryRoutePadding = const EdgeInsets.symmetric(
  horizontal: 240,
  vertical: 96,
);

class Utils {
  static Future<dynamic> showPassChallengeSheet(BuildContext context) async {
    return await showNotesModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PassChallenge(
        editMode: false,
        onChallengeSuccess: () => Navigator.pop(context, true),
        onSave: null,
      ),
    );
  }

  static Future<bool> showBiometricPrompt() async {
    return await LocalAuthentication().authenticateWithBiometrics(
      localizedReason: "",
      stickyAuth: true,
      androidAuthStrings: AndroidAuthMessages(
        signInTitle: LocaleStrings.common.biometricsPrompt,
        fingerprintHint: "",
        cancelButton: LocaleStrings.common.cancel,
      ),
    );
  }

  static Future<dynamic> showNotesModalBottomSheet({
    @required BuildContext context,
    @required WidgetBuilder builder,
    Color backgroundColor,
    double elevation,
    ShapeBorder shape,
    Clip clipBehavior,
    Color barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async {
    double topPadding = MediaQuery.of(context).padding.top;

    return await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheetBase(
        child: builder(context),
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        topPadding: topPadding,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: null,
      clipBehavior: Clip.none,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
  }

  static List<PopupMenuItem<String>> popupItems(BuildContext context) {
    Widget _popupMenuItem({
      IconData icon,
      String title,
      String value,
    }) =>
        PopupMenuItem(
          child: Row(
            children: [
              Icon(icon),
              SizedBox(width: 24),
              Text(title),
            ],
          ),
          value: value,
        );
    return [
      _popupMenuItem(
        icon: MdiIcons.pinOutline,
        title: LocaleStrings.mainPage.selectionBarPin,
        value: 'pin',
      ),
      _popupMenuItem(
        icon: MdiIcons.shareVariant,
        title: LocaleStrings.mainPage.selectionBarShare,
        value: 'share',
      ),
    ];
  }

  static void showFabMenu(BuildContext context, List<Widget> items) {
    RenderBox fabBox =
        GlobalKeyRegistry.get("fab").currentContext.findRenderObject();

    Size fabSize = fabBox.size;
    Offset fabPosition = fabBox.localToGlobal(Offset(0, 0));

    Widget child = Stack(
      children: <Widget>[
        Positioned(
          bottom: MediaQuery.of(context).size.height -
              (fabPosition.dy + fabSize.height),
          right: MediaQuery.of(context).size.width -
              (fabPosition.dx + fabSize.width),
          child: Hero(
            tag: "fabMenu",
            child: Material(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: 250,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  reverse: true,
                  children: items,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) => child,
        opaque: false,
        barrierDismissible: true,
      ),
    );
  }

  static String generateId() {
    return Uuid().v4();
  }

  static Note get emptyNote => Note(
        id: null,
        title: "",
        content: "",
        styleJson: ContentStyle([]),
        starred: false,
        creationDate: DateTime.now(),
        lastModifyDate: DateTime.now(),
        color: 0,
        images: ImageList(List()),
        list: false,
        listContent: ListContent([]),
        reminders: ReminderList([]),
        tags: TagList([]),
        hideContent: false,
        lockNote: false,
        usesBiometrics: false,
        deleted: false,
        archived: false,
        synced: false,
      );

  static String getNameFromMode(ReturnMode mode, {int tagIndex = 0}) {
    switch (mode) {
      case ReturnMode.NORMAL:
        return LocaleStrings.mainPage.titleHome;
      case ReturnMode.ARCHIVE:
        return LocaleStrings.mainPage.titleArchive;
      case ReturnMode.TRASH:
        return LocaleStrings.mainPage.titleTrash;
      case ReturnMode.FAVOURITES:
        return LocaleStrings.mainPage.titleFavourites;
      case ReturnMode.TAG:
        if (prefs.tags.isNotEmpty) {
          return prefs.tags[tagIndex].name;
        } else {
          return LocaleStrings.mainPage.titleTag;
        }
        break;
      case ReturnMode.ALL:
      default:
        return LocaleStrings.mainPage.titleAll;
    }
  }

  static List<DrawerListItem> getDestinations(ReturnMode mode) => [
        DrawerListItem(
          icon: Icon(MdiIcons.homeVariantOutline),
          selectedIcon: Icon(MdiIcons.homeVariant),
          label: Utils.getNameFromMode(ReturnMode.NORMAL),
        ),
        DrawerListItem(
          icon: Icon(MdiIcons.archiveOutline),
          selectedIcon: Icon(MdiIcons.archive),
          label: Utils.getNameFromMode(ReturnMode.ARCHIVE),
        ),
        DrawerListItem(
          icon: Icon(MdiIcons.trashCanOutline),
          selectedIcon: Icon(MdiIcons.trashCan),
          label: Utils.getNameFromMode(ReturnMode.TRASH),
        ),
        DrawerListItem(
          icon: Icon(MdiIcons.heartMultipleOutline),
          selectedIcon: Icon(MdiIcons.heartMultiple),
          label: Utils.getNameFromMode(ReturnMode.FAVOURITES),
        ),
      ];

  static get defaultAccent => Color(0xFFFF9100);

  // Marks the note as changed for the sync systems
  static Note markNoteChanged(Note note) {
    return note.copyWith(synced: false, lastModifyDate: DateTime.now());
  }

  static Tag markTagChanged(Tag tag) {
    return tag.copyWith(lastModifyDate: DateTime.now());
  }

  static Future<void> deleteNotes({
    GlobalKey<ScaffoldState> scaffoldKey,
    @required List<Note> notes,
    @required String reason,
    bool archive = false,
  }) async {
    for (Note note in notes) {
      if (archive) {
        await helper.saveNote(
            markNoteChanged(note).copyWith(deleted: false, archived: true));
      } else {
        await helper.saveNote(
            markNoteChanged(note).copyWith(deleted: true, archived: false));
      }
    }

    List<Note> backupNotes = List.from(notes);

    scaffoldKey?.currentState?.hideCurrentSnackBar();
    scaffoldKey?.currentState?.showSnackBar(
      SnackBar(
        content: Text(reason),
        action: SnackBarAction(
          label: LocaleStrings.common.undo,
          onPressed: () async {
            for (Note note in backupNotes) {
              await helper
                  .saveNote(note.copyWith(deleted: false, archived: false));
            }
          },
        ),
      ),
    );
  }

  static Future<void> restoreNotes({
    GlobalKey<ScaffoldState> scaffoldKey,
    @required List<Note> notes,
    @required String reason,
    bool archive = false,
  }) async {
    for (Note note in notes) {
      await helper.saveNote(
          markNoteChanged(note).copyWith(deleted: false, archived: false));
    }

    List<Note> backupNotes = List.from(notes);

    scaffoldKey?.currentState?.hideCurrentSnackBar();
    scaffoldKey?.currentState?.showSnackBar(
      SnackBar(
        content: Text(reason),
        action: SnackBarAction(
          label: LocaleStrings.common.undo,
          onPressed: () async {
            for (Note note in backupNotes) {
              if (archive) {
                await helper
                    .saveNote(note.copyWith(deleted: false, archived: true));
              } else {
                await helper
                    .saveNote(note.copyWith(deleted: true, archived: false));
              }
            }
          },
        ),
      ),
    );
  }

  static List<ContributorInfo> get contributors => [
        ContributorInfo(
          name: "Davide Bianco",
          role: LocaleStrings.aboutPage.contributorsHrX,
          avatarUrl: "https://avatars.githubusercontent.com/u/29352339",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "HrX03"),
            SocialLink(SocialLinkType.INSTAGRAM, "b_b_biancoboi"),
            SocialLink(SocialLinkType.TWITTER, "HrX2003"),
          ],
        ),
        ContributorInfo(
          name: "Bas Wieringa (broodrooster)",
          role: LocaleStrings.aboutPage.contributorsBas,
          avatarUrl: "https://avatars.githubusercontent.com/u/31385368",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "broodroosterdev"),
          ],
        ),
        ContributorInfo(
          name: "Nico Franke",
          role: LocaleStrings.aboutPage.contributorsNico,
          avatarUrl: "https://avatars.githubusercontent.com/u/23036430",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "ZerNico"),
            SocialLink(SocialLinkType.INSTAGRAM, "z3rnico"),
            SocialLink(SocialLinkType.TWITTER, "Z3rNico"),
          ],
        ),
        ContributorInfo(
          name: "SphericalKat",
          role: LocaleStrings.aboutPage.contributorsKat,
          avatarUrl: "https://avatars.githubusercontent.com/u/31761843",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "ATechnoHazard"),
          ],
        ),
        ContributorInfo(
          name: "Rohit K.Parida",
          role: LocaleStrings.aboutPage.contributorsRohit,
          avatarUrl: "https://avatars.githubusercontent.com/u/18437518",
          socialLinks: [
            SocialLink(SocialLinkType.TWITTER, "paridadesigns"),
          ],
        ),
        ContributorInfo(
          name: "RshBfn",
          role: LocaleStrings.aboutPage.contributorsRshBfn,
          avatarUrl:
              "https://pbs.twimg.com/profile_images/1282395593646604288/Rkxny-Fi.jpg",
          socialLinks: [
            SocialLink(SocialLinkType.TWITTER, "RshBfn"),
          ],
        ),
      ];

  static Future<dynamic> showSecondaryRoute(
    BuildContext context,
    Widget route, {
    EdgeInsets sidePadding = kSecondaryRoutePadding,
    RouteTransitionsBuilder transitionsBuilder,
    bool barrierDismissible = true,
    bool allowGestures = true,
  }) async {
    bool shouldUseDialog = deviceInfo.uiType == UiType.LARGE_TABLET ||
        deviceInfo.uiType == UiType.DESKTOP;

    if (shouldUseDialog) {
      showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => Dialog(
          insetPadding: sidePadding,
          child: route,
        ),
      );
    } else {
      if (transitionsBuilder != null) {
        return Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return transitionsBuilder(
                context,
                animation,
                secondaryAnimation,
                route,
              );
            },
          ),
        );
      } else {
        if (allowGestures) {
          return Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => route,
            ),
          );
        } else {
          return Navigator.of(context).push(
            DismissiblePageRoute(
              builder: (context) => route,
              allowGestures: false,
            ),
          );
        }
      }
    }
  }

  static ImageProvider uriToImageProvider(Uri uri) {
    if (uri.data != null) {
      return MemoryImage(uri.data.contentAsBytes());
    } else if (uri.scheme.startsWith("http") || uri.scheme.startsWith("blob")) {
      return CachedNetworkImageProvider(() => uri.toString());
    } else {
      return FileImage(File(uri.path));
    }
  }

  static Map<String, dynamic> toSyncMap(Note note) {
    var originalMap = note.toJson();
    Map<String, dynamic> newMap = Map();
    originalMap.forEach((key, value) {
      var newValue = value;
      var newKey = ReCase(key).snakeCase;
      switch (key) {
        case "styleJson":
          {
            var style = value as ContentStyle;
            newValue = json.encode(style.data);
            break;
          }
        case "images":
          {
            var images = value as ImageList;
            newValue = json.encode(images.data);
            break;
          }
        case "listContent":
          {
            var listContent = value as ListContent;
            newValue = json.encode(listContent.content);
            break;
          }
        case "reminders":
          {
            var reminders = value as ReminderList;
            newValue = json.encode(reminders.reminders);
            break;
          }
        case "tags":
          {
            var tags = value as TagList;
            newValue = json.encode(tags.tagIds);
            break;
          }
      }
      if (key == "id") {
        newKey = "note_id";
      }
      newMap.putIfAbsent(newKey, () => newValue);
    });
    return newMap;
  }

  static Note fromSyncMap(Map<String, dynamic> syncMap) {
    Map<String, dynamic> newMap = Map();
    syncMap.forEach((key, value) {
      var newValue = value;
      var newKey = ReCase(key).camelCase;
      switch (key) {
        case "style_json":
          {
            var map = json.decode(value);
            List<int> data = List<int>.from(map.map((i) => i as int)).toList();
            newValue = new ContentStyle(data);
            break;
          }
        case "images":
          {
            List<dynamic> list = json.decode(value);
            List<SavedImage> images =
                list.map((i) => SavedImage.fromJson(i)).toList();
            newValue = new ImageList(images);
            break;
          }
        case "list_content":
          {
            var map = json.decode(value);
            List<ListItem> content =
                List<ListItem>.from(map.map((i) => ListItem.fromJson(i)))
                    .toList();
            newValue = new ListContent(content);
            break;
          }
        case "reminders":
          {
            var map = json.decode(value);
            List<DateTime> reminders =
                List<DateTime>.from(map.map((i) => DateTime.parse(i))).toList();
            newValue = new ReminderList(reminders);
            break;
          }
        case "tags":
          {
            var map = json.decode(value);
            List<String> tagIds = List<String>.from(map).toList();
            newValue = new TagList(tagIds);
          }
      }
      if (key == "note_id") {
        newKey = "id";
      }
      newMap.putIfAbsent(newKey, () => newValue);
    });
    return Note.fromJson(newMap);
  }

  static String get defaultApiUrl => "https://sync.potatoproject.co/api/v2";
}
