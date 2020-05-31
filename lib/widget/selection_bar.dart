import 'dart:convert';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/note_color_selector.dart';
import 'package:share/share.dart';

class SelectionBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<Note> selectionList;
  final ReturnMode currentMode;
  final Function() onCloseSelection;

  SelectionBar({
    @required this.scaffoldKey,
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
    List<Widget> buttons = [];

    if (currentMode == ReturnMode.NORMAL ||
        currentMode == ReturnMode.FAVOURITES ||
        currentMode == ReturnMode.TAG) {
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
                await helper.saveNote(selectionList[i].copyWith(
                    starred: false,
                    synced: false,
                    lastModifyDate: DateTime.now()));
              else
                await helper.saveNote(selectionList[i].copyWith(
                    starred: true,
                    synced: false,
                    lastModifyDate: DateTime.now()));
            }

            onCloseSelection();
          },
        ),
      );
    }

    if (currentMode == ReturnMode.NORMAL || currentMode == ReturnMode.TAG) {
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
                  Navigator.pop(context, color);
                },
              ),
            );

            if (selectedColor != null) {
              for (int i = 0; i < selectionList.length; i++)
                await helper.saveNote(selectionList[i].copyWith(
                    color: selectedColor,
                    synced: false,
                    lastModifyDate: DateTime.now()));

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
            await Utils.deleteNotes(
              scaffoldKey: scaffoldKey,
              notes: selectionList,
              reason: "${selectionList.length} notes archived.",
              archive: true,
            );

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
            await Utils.deleteNotes(
              scaffoldKey: scaffoldKey,
              notes: selectionList,
              reason: "${selectionList.length} notes moved to trash.",
            );
          }
        }

        onCloseSelection();
      },
    ));

    if (currentMode != ReturnMode.NORMAL &&
        currentMode != ReturnMode.FAVOURITES &&
        currentMode != ReturnMode.TAG) {
      buttons.add(IconButton(
        icon: Icon(Icons.settings_backup_restore),
        padding: EdgeInsets.all(0),
        onPressed: () async {
          await Utils.restoreNotes(
            scaffoldKey: scaffoldKey,
            notes: selectionList,
            reason: "${selectionList.length} notes restored.",
            archive: currentMode == ReturnMode.ARCHIVE,
          );

          onCloseSelection();
        },
      ));
    }

    if (selectionList.length == 1 && !selectionList[0].hideContent && !kIsWeb) {
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
    appInfo.notifications.show(
      note.id,
      note.title.isEmpty ? "Pinned notification" : note.title,
      note.content,
      NotificationDetails(
        AndroidNotificationDetails(
          'pinned_notifications',
          'Pinned notifications',
          'User pinned notifications',
          color: Utils.defaultAccent,
          ongoing: true,
          priority: Priority.Max,
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
