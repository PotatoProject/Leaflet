import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/widget/note_options.dart';
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

  static Future<String> showNoteMenu({
    BuildContext context,
    Offset position,
    Note note,
    int numOfImages,
    int numOfColumns,
  }) async {
    return await Navigator.of(context).push(
      PageRouteBuilder(
        fullscreenDialog: false,
        barrierDismissible: true,
        opaque: false,
        pageBuilder: (context, _, __) => NoteOptions(
          note: note,
          position: position,
          numOfImages: numOfImages,
          numOfColumns: numOfColumns,
        ),
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  static List<PopupMenuItem<String>> popupItems(
      BuildContext context, Note note) {
    Widget _popupMenuItem({
      IconData icon,
      String title,
      String value,
      bool disableOnHide = false,
    }) =>
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                icon,
                color: note.color != 0
                    ? Theme.of(context).iconTheme.color.withOpacity(1)
                    : Theme.of(context).accentColor,
              ),
              SizedBox(width: 24),
              Text(title),
            ],
          ),
          enabled: disableOnHide ? !note.hideContent : true,
          value: value,
        );
    return [
      _popupMenuItem(
        icon: CommunityMaterialIcons.check,
        title: "Select",
        value: 'select',
      ),
      _popupMenuItem(
        icon: CommunityMaterialIcons.pin_outline,
        title: 'Pin',
        value: 'pin',
        disableOnHide: true,
      ),
      _popupMenuItem(
        icon: CommunityMaterialIcons.share_variant,
        title: 'Share',
        value: 'share',
        disableOnHide: true,
      ),
    ];
  }
}
