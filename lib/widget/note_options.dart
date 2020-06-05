import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:provider/provider.dart';

class NoteOptions extends StatelessWidget {
  final Note note;
  final Offset position;
  final int numOfImages;
  final int numOfColumns;

  NoteOptions({
    @required this.note,
    @required this.position,
    this.numOfImages,
    this.numOfColumns,
  });

  @override
  Widget build(BuildContext context) {
    Preferences prefs = Provider.of<Preferences>(context);

    return MediaQuery.removeViewInsets(
        removeLeft: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Stack(
          children: [
            Positioned(
              top: position.dy,
              left: position.dx,
              child: SizedBox(
                width: (
                  prefs.useGrid
                      ? MediaQuery.of(context).size.width / numOfColumns
                      : MediaQuery.of(context).size.width - 4
                ) - 4,
                child: NoteView(
                  note: note,
                  showOptions: true,
                  numOfImages: numOfImages,
                ),
              ),
            )
          ]
        ),
    );
  }
}