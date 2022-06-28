import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liblymph/database.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

class NewNoteBar extends StatelessWidget {
  final Folder folder;

  const NewNoteBar({required this.folder});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: IgnorePointer(
        child: Text(
          strings.mainPage.writeNote,
          style: TextStyle(
            fontSize: 16,
            color: context.theme.textTheme.bodyText1!.color!.withOpacity(0.7),
          ),
        ),
      ),
      flexibleSpace: InkWell(
        onTap: () => Utils.newNote(context, folder),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.check_box_outlined),
          tooltip: strings.common.newList,
          onPressed: () => Utils.newList(context, folder),
        ),
        IconButton(
          icon: const Icon(Icons.image_outlined),
          tooltip: strings.common.newImage,
          onPressed: () => Utils.newImage(context, folder, ImageSource.gallery),
        ),
        IconButton(
          icon: const Icon(Icons.brush_outlined),
          tooltip: strings.common.newDrawing,
          onPressed: () => Utils.newDrawing(context, folder),
        ),
        IconButton(
          icon: const Icon(Icons.note_add_outlined),
          tooltip: strings.common.importNote,
          onPressed: () => Utils.importNotes(context),
        ),
      ],
    );
  }
}
