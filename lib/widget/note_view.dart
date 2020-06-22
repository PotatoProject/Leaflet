import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/internal/note_colors.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/note_view_images.dart';
import 'package:potato_notes/widget/note_view_statusbar.dart';
import 'package:rich_text_editor/rich_text_editor.dart';

const double _kBorderRadius = 10.0;

class NoteView extends StatelessWidget {
  final Note note;
  final Function() onTap;
  final Function() onLongPress;
  final int numOfImages;
  final bool selected;
  final bool showOptions;

  NoteView({
    Key key,
    @required this.note,
    this.onTap,
    this.onLongPress,
    this.numOfImages = 2,
    this.selected = false,
    this.showOptions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String parsedStyleJson = utf8.decode(gzip.decode(note.styleJson.data));
    Color borderColor;

    if (selected) {
      borderColor = Theme.of(context).textTheme.caption.color;
    } else if (note.color == 0) {
      double opacity =
          Theme.of(context).brightness == Brightness.light ? 0.1 : 0.2;

      borderColor =
          Theme.of(context).textTheme.caption.color.withOpacity(opacity);
    } else {
      borderColor = Colors.transparent;
    }
    
    return Card(
      color: note.color != 0
          ? Color(NoteColors.colorList(context)[note.color]["hex"])
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_kBorderRadius),
        side: BorderSide(
          color: borderColor,
          width: 1.5,
        ),
      ),
      margin: EdgeInsets.all(4),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(_kBorderRadius),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0),
          children: [
            IgnorePointer(
              child: Visibility(
                visible: (note.images.data?.isNotEmpty ?? false) &&
                    !note.hideContent &&
                    !showOptions,
                child: NoteViewImages(
                  images: note.images.uris.sublist(
                      0,
                      note.images.data.length > numOfImages * 2
                          ? numOfImages * 2
                          : note.images.data.length),
                  numOfImages: numOfImages,
                  borderRadius: _kBorderRadius,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: note.title != "",
                    child: Text(
                      note.title ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .textTheme
                            .caption
                            .color
                            .withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Visibility(
                    visible: !note.hideContent,
                    child: note.styleJson != null
                        ? RichText(
                            text: SpannableList.fromJson(parsedStyleJson)
                                .toTextSpan(
                              note.content,
                              defaultStyle: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .caption
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
                                  .caption
                                  .color
                                  .withOpacity(0.5),
                            ),
                            maxLines: 8,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                  Visibility(
                    visible: note.list && !note.hideContent && !showOptions,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: listContentWidgets,
                    ),
                  ),
                ],
              ),
            ),
            NoteViewStatusbar(note: note),
            Visibility(
              visible: showOptions,
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  Divider(
                    height: 1,
                  ),
                  ...Utils.popupItems(context, note),
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
            : (note.listContent?.content?.length ?? 0),
        (index) {
          ListItem item = note.listContent.content[index];

          return Container(
            padding: EdgeInsets.only(top: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Icon(
                      item.status
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: item.status
                          ? note.color != 0
                              ? Theme.of(context).textTheme.caption.color
                              : Theme.of(context).accentColor
                          : null,
                      size: 20,
                    ),
                    VerticalDivider(
                      color: Colors.transparent,
                      width: 8,
                    ),
                    SizedBox(
                      width: constraints.maxWidth - 28,
                      child: Text(
                        item.text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .caption
                                .color
                                .withOpacity(item.status ? 0.5 : 0.7),
                            decoration: item.status
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
}
