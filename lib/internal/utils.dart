import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/content_style.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/data/model/tag_list.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/global_key_registry.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/routes/about_page.dart';
import 'package:potato_notes/widget/bottom_sheet_base.dart';
import 'package:potato_notes/widget/dismissible_route.dart';
import 'package:potato_notes/widget/drawer_list.dart';
import 'package:potato_notes/widget/pass_challenge.dart';

const int kMaxImageCount = 4;
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
    return await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheetBase(
        child: builder(context),
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
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
        icon: CommunityMaterialIcons.pin_outline,
        title: 'Pin',
        value: 'pin',
      ),
      _popupMenuItem(
        icon: CommunityMaterialIcons.share_variant,
        title: 'Share',
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

  static Future<int> generateId() async {
    Note lastNote;
    List<Note> notes = await helper.listNotes(ReturnMode.ALL);
    notes.sort((a, b) => a.id.compareTo(b.id));

    if (notes.isNotEmpty) {
      lastNote = notes.last;
    }

    return (lastNote?.id ?? 0) + 1;
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
        images: ImageList({}),
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
        return "Home";
      case ReturnMode.ARCHIVE:
        return "Archive";
      case ReturnMode.TRASH:
        return "Trash";
      case ReturnMode.FAVOURITES:
        return "Favourites";
      case ReturnMode.TAG:
        if (prefs.tags.isNotEmpty) {
          return prefs.tags[tagIndex].name;
        } else {
          return "Tag";
        }
        break;
      case ReturnMode.ALL:
      default:
        return "All";
    }
  }

  static List<DrawerListItem> getDestinations(ReturnMode mode) => [
        DrawerListItem(
          icon: Icon(CommunityMaterialIcons.home_variant_outline),
          selectedIcon: Icon(CommunityMaterialIcons.home_variant),
          label: Utils.getNameFromMode(ReturnMode.NORMAL),
        ),
        DrawerListItem(
          icon: Icon(MdiIcons.archiveOutline),
          selectedIcon: Icon(MdiIcons.archive),
          label: Utils.getNameFromMode(ReturnMode.ARCHIVE),
        ),
        DrawerListItem(
          icon: Icon(CommunityMaterialIcons.trash_can_outline),
          selectedIcon: Icon(CommunityMaterialIcons.trash_can),
          label: Utils.getNameFromMode(ReturnMode.TRASH),
        ),
        DrawerListItem(
          icon: Icon(CommunityMaterialIcons.heart_multiple_outline),
          selectedIcon: Icon(CommunityMaterialIcons.heart_multiple),
          label: Utils.getNameFromMode(ReturnMode.FAVOURITES),
        ),
      ];

  static get defaultAccent => Color(0xFFFF9100);

  static Future<void> deleteNotes({
    GlobalKey<ScaffoldState> scaffoldKey,
    @required List<Note> notes,
    @required String reason,
    bool archive = false,
  }) async {
    for (Note note in notes) {
      if (archive) {
        await helper.saveNote(note.copyWith(deleted: false, archived: true));
      } else {
        await helper.saveNote(note.copyWith(deleted: true, archived: false));
      }
    }

    List<Note> backupNotes = List.from(notes);

    scaffoldKey?.currentState?.hideCurrentSnackBar();
    scaffoldKey?.currentState?.showSnackBar(
      SnackBar(
        content: Text(reason),
        action: SnackBarAction(
          label: "Undo",
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

  static List<ContributorInfo> get contributors => [
        ContributorInfo(
          name: "Davide Bianco",
          role: "Lead developer and app design",
          avatarUrl: "https://avatars.githubusercontent.com/u/29352339",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "HrX03"),
            SocialLink(SocialLinkType.INSTAGRAM, "b_b_biancoboi"),
            SocialLink(SocialLinkType.TWITTER, "HrX2003"),
          ],
        ),
        ContributorInfo(
          name: "Bas Wieringa (broodrooster)",
          role: "Sync API and App",
          avatarUrl: "https://avatars.githubusercontent.com/u/31385368",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "broodroosterdev"),
          ],
        ),
        ContributorInfo(
          name: "Nico Franke",
          role: "Sync API",
          avatarUrl: "https://avatars.githubusercontent.com/u/23036430",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "ZerNico"),
            SocialLink(SocialLinkType.INSTAGRAM, "z3rnico"),
            SocialLink(SocialLinkType.TWITTER, "Z3rNico"),
          ],
        ),
        ContributorInfo(
          name: "SphericalKat",
          role: "Old sync API",
          avatarUrl: "https://avatars.githubusercontent.com/u/31761843",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "ATechnoHazard"),
          ],
        ),
        ContributorInfo(
          name: "Rohit K.Parida",
          role: "Illustrations and note colors",
          avatarUrl: "https://avatars.githubusercontent.com/u/18437518",
          socialLinks: [
            SocialLink(SocialLinkType.TWITTER, "paridadesigns"),
          ],
        ),
        ContributorInfo(
          name: "RshBfn",
          role: "App icon and main accent",
          avatarUrl:
              "https://pbs.twimg.com/profile_images/1282395593646604288/Rkxny-Fi.jpg",
          socialLinks: [
            SocialLink(SocialLinkType.TWITTER, "RshBfn"),
          ],
        ),
      ];

  static Future<void> restoreNotes({
    GlobalKey<ScaffoldState> scaffoldKey,
    @required List<Note> notes,
    @required String reason,
    bool archive = false,
  }) async {
    for (Note note in notes) {
      await helper.saveNote(note.copyWith(deleted: false, archived: false));
    }

    List<Note> backupNotes = List.from(notes);

    scaffoldKey?.currentState?.hideCurrentSnackBar();
    scaffoldKey?.currentState?.showSnackBar(
      SnackBar(
        content: Text(reason),
        action: SnackBarAction(
          label: "Undo",
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

  static Future<dynamic> showSecondaryRoute(
    BuildContext context,
    Widget route, {
    EdgeInsets sidePadding = kSecondaryRoutePadding,
    bool allowGestures = true,
  }) async {
    bool shouldUseDialog = deviceInfo.uiType == UiType.LARGE_TABLET ||
        deviceInfo.uiType == UiType.DESKTOP;

    if (shouldUseDialog) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          insetPadding: sidePadding,
          child: route,
        ),
      );
    } else {
      return Navigator.of(context).push(
        DismissiblePageRoute(
          builder: (context) => route,
          allowGestures: allowGestures,
        ),
      );
    }
  }
}
