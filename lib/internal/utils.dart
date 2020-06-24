import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/content_style.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/internal/global_key_registry.dart';
import 'package:potato_notes/locator.dart';
import 'package:potato_notes/widget/pass_challenge.dart';

class Utils {
  static Future<dynamic> showPassChallengeSheet(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PassChallenge(
        editMode: false,
        onChallengeSuccess: () => Navigator.pop(context, true),
        onSave: null,
      ),
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
    final helper = locator<NoteHelper>();
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
        hideContent: false,
        lockNote: false,
        usesBiometrics: false,
        deleted: false,
        archived: false,
        synced: false,
      );
}
