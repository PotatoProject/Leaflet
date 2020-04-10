import 'package:flutter/material.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:provider/provider.dart';
import 'package:spicy_components/spicy_components.dart';

class SelectionBar extends StatelessWidget {
  final List<int> selectionList;
  final Function() onCloseSelection;

  SelectionBar({
    @required this.selectionList,
    this.onCloseSelection,
  });

  @override
  Widget build(BuildContext context) {
    NoteHelper helper = Provider.of<NoteHelper>(context);

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
      rightItems: [
        IconButton(
          icon: Icon(Icons.delete_outline),
          padding: EdgeInsets.all(0),
          onPressed: () async {
            List<Note> notes = await helper.listNotes(ReturnMode.ALL);

            for (int i = 0; i < selectionList.length; i++) {
              Note note = notes
                  .where((item) => item.id == selectionList[i])
                  .toList()[0];
              
              helper.saveNote(note.copyWith(deleted: true));
            }

            onCloseSelection();
          },
        ),
      ],
    );
  }
}
