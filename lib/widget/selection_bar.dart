import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/note_color_selector.dart';
import 'package:share_plus/share_plus.dart';

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
    return Size.fromHeight(56.0);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        padding: EdgeInsets.all(0),
        onPressed: onCloseSelection,
        tooltip: LocaleStrings.mainPage.selectionBarClose,
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
          icon: Icon(
            anyStarred ? Icons.favorite : Icons.favorite_border,
          ),
          tooltip: anyStarred
              ? LocaleStrings.mainPage.selectionBarRmFav
              : LocaleStrings.mainPage.selectionBarAddFav,
          padding: EdgeInsets.all(0),
          onPressed: () async {
            for (int i = 0; i < selectionList.length; i++) {
              if (anyStarred)
                await helper.saveNote(
                  selectionList[i].markChanged().copyWith(starred: false),
                );
              else
                await helper.saveNote(
                  selectionList[i].markChanged().copyWith(starred: true),
                );
            }

            onCloseSelection();
          },
        ),
      );
    }

    if (currentMode == ReturnMode.NORMAL || currentMode == ReturnMode.TAG) {
      buttons.addAll([
        IconButton(
          icon: Icon(Icons.color_lens_outlined),
          padding: EdgeInsets.all(0),
          tooltip: LocaleStrings.mainPage.selectionBarChangeColor,
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
        icon: Icon(Icons.archive_outlined),
        padding: EdgeInsets.all(0),
        tooltip: LocaleStrings.mainPage.selectionBarArchive,
        onPressed: () async {
          for (int i = 0; i < selectionList.length; i++)
            await Utils.deleteNotes(
              context: context,
              notes: selectionList,
              reason:
                  LocaleStrings.mainPage.notesArchived(selectionList.length),
              archive: true,
            );

          onCloseSelection();
        },
      ));
    }

    buttons.add(IconButton(
      icon: Icon(Icons.delete_outline),
      padding: EdgeInsets.all(0),
      tooltip: LocaleStrings.mainPage.selectionBarDelete,
      onPressed: () async {
        for (int i = 0; i < selectionList.length; i++) {
          Note note = selectionList[i];

          if (note.deleted) {
            Utils.deleteNoteSafely(note);
          } else {
            await Utils.deleteNotes(
              context: context,
              notes: selectionList,
              reason: LocaleStrings.mainPage.notesDeleted(selectionList.length),
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
        tooltip: LocaleStrings.common.restore,
        onPressed: () async {
          await Utils.restoreNotes(
            context: context,
            notes: selectionList,
            reason: LocaleStrings.mainPage.notesRestored(selectionList.length),
            archive: currentMode == ReturnMode.ARCHIVE,
          );

          onCloseSelection();
        },
      ));
    }

    if (selectionList.length == 1 &&
        !selectionList[0].hideContent &&
        !DeviceInfo.isDesktopOrWeb) {
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
      int.parse(note.id.split("-")[0], radix: 16).toUnsigned(31),
      note.title.isEmpty
          ? LocaleStrings.common.notificationDefaultTitle
          : note.title,
      note.content,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'pinned_notifications',
          LocaleStrings.common.notificationDetailsTitle,
          LocaleStrings.common.notificationDetailsDesc,
          color: Utils.defaultAccent,
          ongoing: true,
          priority: Priority.max,
        ),
        iOS: IOSNotificationDetails(),
        macOS: MacOSNotificationDetails(),
      ),
      payload: json.encode(
        NotificationPayload(
          action: NotificationAction.PIN,
          id: int.parse(note.id.split("-")[0], radix: 16).toUnsigned(31),
          noteId: note.id,
        ).toJson(),
      ),
    );
  }
}
