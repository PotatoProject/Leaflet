import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/widget/note_color_selector.dart';
import 'package:provider/provider.dart';
import 'package:spicy_components/spicy_components.dart';

class SelectionBar extends StatelessWidget {
  final List<Note> selectionList;
  final ReturnMode currentMode;
  final Function() onCloseSelection;

  SelectionBar({
    @required this.selectionList,
    this.currentMode = ReturnMode.NORMAL,
    this.onCloseSelection,
  });

  @override
  Widget build(BuildContext context) {
    return SpicyBottomBar(
      leftItems: [
        IconButton(
          icon: Icon(Icons.close),
          padding: EdgeInsets.all(0),
          onPressed: onCloseSelection,
        ),
        Text(
          selectionList.length.toString(),
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
      rightItems: getButtons(context),
    );
  }

  List<Widget> getButtons(BuildContext context) {
    NoteHelper helper = Provider.of<NoteHelper>(context);
    List<Widget> buttons = [];

    if (currentMode == ReturnMode.NORMAL) {
      bool anyNotStarred = selectionList.any((item) => !item.starred);

      buttons.addAll([
        IconButton(
          icon: Icon(
            anyNotStarred ? Icons.star : Icons.star_border
          ),
          padding: EdgeInsets.all(0),
          onPressed: () async {
            for (int i = 0; i < selectionList.length; i++) {
              if(anyNotStarred)
                await helper.saveNote(selectionList[i].copyWith(starred: true));
              else
                await helper.saveNote(selectionList[i].copyWith(starred: false));
            }

            onCloseSelection();
          },
        ),
        IconButton(
          icon: Icon(OMIcons.colorLens),
          padding: EdgeInsets.all(0),
          onPressed: () async {
            int selectedColor;

            if(selectionList.length > 1) {
              int color = selectionList[0].color;

              if(selectionList.every((item) => item.color == color))
                selectedColor = color;
              else
                selectedColor = 0;
            } else selectedColor = selectionList[0].color;

            selectedColor = await showModalBottomSheet(
              context: context,
              builder: (context) => NoteColorSelector(
                selectedColor: selectedColor,
                onColorSelect: (color) {
                  if(selectedColor == color)
                    Navigator.pop(context, null);
                  else
                    Navigator.pop(context, color);
                },
              ),
            );

            if(selectedColor != null) {
              for (int i = 0; i < selectionList.length; i++)
                await helper.saveNote(selectionList[i].copyWith(color: selectedColor));

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
            await helper.saveNote(selectionList[i].copyWith(deleted: false, archived: true));

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

          if(note.deleted) {
            helper.deleteNote(note);
          } else {
            helper.saveNote(note.copyWith(deleted: true, archived: false));
          }
        }

        onCloseSelection();
      },
    ));

    if(currentMode != ReturnMode.NORMAL) {
      buttons.add(IconButton(
        icon: Icon(Icons.settings_backup_restore),
        padding: EdgeInsets.all(0),
        onPressed: () async {
          List<Note> notes = await helper.listNotes(ReturnMode.ALL);

          for (int i = 0; i < selectionList.length; i++)
            await helper.saveNote(selectionList[i].copyWith(deleted: false, archived: false));

          onCloseSelection();
        },
      ));
    }

    return buttons;
  }
}
