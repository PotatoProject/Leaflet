import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/widget/note_view.dart';

class NoteOptions extends StatelessWidget {
  final Note note;
  final int numOfImages;
  final int numOfColumns;

  NoteOptions({
    @required this.note,
    this.numOfImages,
    this.numOfColumns,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removeViewInsets(
      removeTop: true,
      removeLeft: true,
      removeRight: true,
      removeBottom: true,
      context: context,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: NoteView(
            note: note,
            onTap: () => Navigator.pop(context),
            showOptions: true,
            numOfImages: numOfImages,
          ),
        ),
      ),
    );
  }
}
