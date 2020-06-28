import 'dart:convert';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/locator.dart';
import 'package:potato_notes/widget/note_color_selector.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class SelectionBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Note> selectionList;
  final ReturnMode currentMode;
  final Function() onCloseSelection;

  SelectionBar({
    @required this.selectionList,
    this.currentMode = ReturnMode.NORMAL,
    this.onCloseSelection,
  });

  @override
  Size get preferredSize {
    return new Size.fromHeight(56.0);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        padding: EdgeInsets.all(0),
        onPressed: onCloseSelection,
      ),
      title: Text(
        selectionList.length.toString(),
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: getButtons(context),
    );
  }

  List<Widget> getButtons(BuildContext context) {
    NoteHelper helper = locator<NoteHelper>();
    List<Widget> buttons = [];

    if (currentMode == ReturnMode.NORMAL ||
        currentMode == ReturnMode.FAVOURITES) {
      bool anyStarred = selectionList.any((item) => item.starred);

      buttons.add(
        IconButton(
          icon: Icon(anyStarred
              ? CommunityMaterialIcons.heart
              : CommunityMaterialIcons.heart_outline),
          padding: EdgeInsets.all(0),
          onPressed: () async {
            for (int i = 0; i < selectionList.length; i++) {
              if (anyStarred)
                await helper
                    .saveNote(selectionList[i].copyWith(starred: false));
              else
                await helper.saveNote(selectionList[i].copyWith(starred: true));
            }

            onCloseSelection();
          },
        ),
      );
    }

    if (currentMode == ReturnMode.NORMAL) {
      buttons.addAll([
        IconButton(
          icon: Icon(OMIcons.colorLens),
          padding: EdgeInsets.all(0),
          onPressed: () async {
            int selectedColor;

            if (selectionList.length > 1) {
              int color = selectionList[0].color;

              if (selectionList.every((item) => item.color == color))
                selectedColor = color;
              else
                selectedColor = 0;
            } else
              selectedColor = selectionList[0].color;

            selectedColor = await Utils.showNotesModalBottomSheet(
              context: context,
              builder: (context) => NoteColorSelector(
                selectedColor: selectedColor,
                onColorSelect: (color) {
                  if (selectedColor == color)
                    Navigator.pop(context, null);
                  else
                    Navigator.pop(context, color);
                },
              ),
            );

            if (selectedColor != null) {
              for (int i = 0; i < selectionList.length; i++)
                await helper
                    .saveNote(selectionList[i].copyWith(color: selectedColor));

              onCloseSelection();
            }
          },
        ),
      ]);
    }

    if (currentMode != ReturnMode.ARCHIVE) {
      buttons.add(IconButton(
        icon: Icon(OMIcons.archive),
        padding: EdgeInsets.all(0),
        onPressed: () async {
          for (int i = 0; i < selectionList.length; i++)
            await helper.saveNote(
                selectionList[i].copyWith(deleted: false, archived: true));

          onCloseSelection();
        },
      ));
    }

    buttons.add(IconButton(
      icon: Icon(Icons.delete_outline),
      padding: EdgeInsets.all(0),
      onPressed: () async {
        for (int i = 0; i < selectionList.length; i++) {
          Note note = selectionList[i];

          if (note.deleted) {
            helper.deleteNote(note);
          } else {
            helper.saveNote(note.copyWith(deleted: true, archived: false));
          }
        }

        onCloseSelection();
      },
    ));

    if (currentMode != ReturnMode.NORMAL &&
        currentMode != ReturnMode.FAVOURITES) {
      buttons.add(IconButton(
        icon: Icon(Icons.settings_backup_restore),
        padding: EdgeInsets.all(0),
        onPressed: () async {
          for (int i = 0; i < selectionList.length; i++)
            await helper.saveNote(
                selectionList[i].copyWith(deleted: false, archived: false));

          onCloseSelection();
        },
      ));
    }

    if (selectionList.length == 1 && !selectionList[0].hideContent) {
      buttons.add(
        PopupMenuButton(
          itemBuilder: (context) => Utils.popupItems(context),
          onSelected: (action) async {
            Note note = selectionList[0];

            switch (action) {
              case 'pin':
                handlePinNotes(context, selectionList[0]);
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

            onCloseSelection();
          },
        ),
      );
    }

    return buttons;
  }

  void handlePinNotes(BuildContext context, Note note) {
    final appInfo = Provider.of<AppInfoProvider>(context, listen: false);

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
