import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';

class NewNoteBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: IgnorePointer(
        child: Text(
          "Write a note",
          style: TextStyle(
            fontSize: 16,
            color: context.theme.textTheme.bodyText1.color.withOpacity(0.7),
          ),
        ),
      ),
      textTheme: context.theme.textTheme,
      flexibleSpace: InkWell(
        onTap: () => Utils.newNote(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.check_box_outlined),
          tooltip: LocaleStrings.common.newList,
          onPressed: () => Utils.newList(context),
        ),
        IconButton(
          icon: const Icon(Icons.image_outlined),
          tooltip: LocaleStrings.common.newImage,
          onPressed: () => Utils.newImage(context, ImageSource.gallery),
        ),
        IconButton(
          icon: const Icon(Icons.brush_outlined),
          tooltip: LocaleStrings.common.newDrawing,
          onPressed: () => Utils.newDrawing(context),
        ),
      ],
    );
  }
}
