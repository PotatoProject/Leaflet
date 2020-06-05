import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/widget/pass_challenge.dart';
import 'package:provider/provider.dart';

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

  static Future<String> showNoteMenu(BuildContext context, Offset position, [Note note]) async {
    return await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                CommunityMaterialIcons.check,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(width: 24),
              Text("Select"),
            ],
          ),
          value: 'select',
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                CommunityMaterialIcons.pin_outline,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(width: 24),
              Text("Pin to notifications"),
            ],
          ),
          enabled: !note.hideContent,
          value: 'pin',
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                CommunityMaterialIcons.share_variant,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(width: 24),
              Text("Share"),
            ],
          ),
          enabled: !note.hideContent,
          value: 'share',
        ),
      ],
    );
  }
}
