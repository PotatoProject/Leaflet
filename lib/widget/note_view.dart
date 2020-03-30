import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/list_item.dart';
import 'package:potato_notes/widget/note_view_images.dart';
import 'package:rich_text_editor/rich_text_editor.dart';

const double _kBorderRadius = 8.0;

class NoteView extends StatelessWidget {
  final Note note;
  final Function() onTap;
  final Function() onLongPress;
  final int numOfImages;

  NoteView({
    @required this.note,
    this.onTap,
    this.onLongPress,
    this.numOfImages = 2,
  });

  @override
  Widget build(BuildContext context) {
    String parsedStyleJson = utf8.decode(gzip.decode(note.styleJson.data));
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_kBorderRadius),
      ),
      elevation: 3,
      margin: EdgeInsets.all(4),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            note.images.images.isNotEmpty
                ? NoteViewImages(
                    note.images.images.sublist(
                        0,
                        note.images.images.length > numOfImages * 2
                            ? numOfImages * 2
                            : note.images.images.length),
                    numOfImages,
                    _kBorderRadius,
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: note.title != null,
                    child: Text(
                      note.title ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .textTheme
                            .title
                            .color
                            .withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Visibility(
                    visible: note.content.trim() != "" || note.content != null,
                    child: note.styleJson != null
                        ? RichText(
                          text: SpannableList.fromJson(parsedStyleJson).toTextSpan(
                            note.content,
                            defaultStyle: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .textTheme
                                  .title
                                  .color
                                  .withOpacity(0.5),
                            ),
                          ),
                          maxLines: 8,
                          overflow: TextOverflow.ellipsis,
                        )
                        : Text(
                          note.content,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .textTheme
                                .title
                                .color
                                .withOpacity(0.5),
                          ),
                          maxLines: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  Visibility(
                    visible: note.list,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: listContentWidgets,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get listContentWidgets => List.generate(
          (note.listContent?.content?.length ?? 0) > 5
              ? 5
              : (note.listContent?.content?.length ?? 0), (index) {
        ListItem item = ListItem(
          note.listContent.content.keys.toList()[index],
          note.listContent.content.values.toList()[index],
        );

        return Padding(
          padding: EdgeInsets.only(top: 8),
          child: Builder(
            builder: (context) => Row(
              children: [
                Icon(
                  item.status ? Icons.check_box : Icons.check_box_outline_blank,
                  color: item.status ? Theme.of(context).accentColor : null,
                  size: 20,
                ),
                VerticalDivider(
                  color: Colors.transparent,
                  width: 8,
                ),
                Text(item.text),
              ],
            ),
          ),
        );
      });
}
