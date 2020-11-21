import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/note_view_checkbox.dart';
import 'package:potato_notes/widget/note_view_images.dart';
import 'package:potato_notes/widget/note_view_statusbar.dart';
import 'package:rich_text_editor/rich_text_editor.dart';

class NoteView extends StatefulWidget {
  final Note note;
  final SpannableList? providedTitleList;
  final SpannableList? providedContentList;
  final Function()? onTap;
  final Function()? onLongPress;
  final bool selectorOpen;
  final bool selected;

  NoteView({
    Key? key,
    required this.note,
    this.providedTitleList,
    this.providedContentList,
    this.onTap,
    this.onLongPress,
    this.selectorOpen = false,
    this.selected = false,
  }) : super(key: key);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  bool _hovered = false;
  bool _focused = false;
  bool _highlighted = false;
  double _elevation = 2;
  bool _mouseIsConnected = false;

  @override
  void initState() {
    _mouseIsConnected = RendererBinding.instance!.mouseTracker.mouseIsConnected;
    RendererBinding.instance!.mouseTracker.addListener(mouseListener);
    super.initState();
  }

  @override
  void dispose() {
    RendererBinding.instance!.mouseTracker.removeListener(mouseListener);
    super.dispose();
  }

  void mouseListener() {
    final bool mouseIsConnected =
        RendererBinding.instance!.mouseTracker.mouseIsConnected;
    if (mouseIsConnected != _mouseIsConnected) {
      setState(() {
        _mouseIsConnected = mouseIsConnected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //String parsedStyleJson = utf8.decode(gzip.decode(note.styleJson.data));
    SpannableList? spannableList = widget
        .providedContentList; // ?? SpannableList.fromJson(parsedStyleJson);
    Color backgroundColor = widget.note.color != 0
        ? Color(NoteColors.colorList[widget.note.color].dynamicColor(context))
        : Theme.of(context).cardColor;
    Color borderColor;

    if (widget.selected) {
      _elevation = 8;
    } else if (_highlighted) {
      _elevation = 6;
    } else if (_hovered) {
      _elevation = 4;
    } else if (_focused) {
      _elevation = 3;
    } else {
      _elevation = 2;
    }

    if (widget.selected) {
      borderColor = Theme.of(context).iconTheme.color!;
    } else {
      borderColor = Colors.transparent;
    }

    List<Widget> content = getItems(context, spannableList);

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardBorderRadius),
        side: BorderSide(
          color: borderColor,
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: _elevation,
      shadowColor: Colors.black.withOpacity(0.4),
      margin: kCardPadding,
      child: InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onHover: (value) => setState(() {
          _hovered = value;
        }),
        onFocusChange: (value) => setState(() {
          _focused = value;
        }),
        onHighlightChanged: (value) => setState(() {
          _highlighted = value;
        }),
        borderRadius: BorderRadius.circular(kCardBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IgnorePointer(
              child: Visibility(
                visible:
                    widget.note.images.isNotEmpty && !widget.note.hideContent,
                child: NoteViewImages(
                  images: widget.note.images,
                  showPlusImages: true,
                  numPlusImages: widget.note.images.length < kMaxImageCount
                      ? 0
                      : widget.note.images.length - kMaxImageCount,
                ),
              ),
            ),
            Visibility(
              visible: content.isNotEmpty,
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 16 + Theme.of(context).visualDensity.horizontal,
                  vertical: 16 + Theme.of(context).visualDensity.vertical,
                ),
                itemBuilder: (context, index) => content[index],
                separatorBuilder: (context, index) {
                  return SizedBox(
                      height: 4 + Theme.of(context).visualDensity.vertical);
                },
                itemCount: content.length,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                width: constraints.maxWidth,
                child: NoteViewStatusbar(
                  note: widget.note,
                  width: constraints.maxWidth,
                  padding: content.isEmpty
                      ? EdgeInsets.symmetric(
                          horizontal:
                              16 + Theme.of(context).visualDensity.horizontal,
                          vertical:
                              16 + Theme.of(context).visualDensity.vertical,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getItems(BuildContext context, SpannableList? spannableList) {
    List<Widget> items = [];

    String title = widget.note.title ?? "";
    String content = widget.note.content ?? "";

    if (widget.note.title != "") {
      items.add(
        widget.providedTitleList != null
            ? RichText(
                text: widget.providedTitleList!.toTextSpan(
                  widget.note.title,
                  defaultStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .textTheme
                        .caption!
                        .color!
                        .withOpacity(0.7),
                  ),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                widget.note.title ?? "",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context)
                      .textTheme
                      .caption!
                      .color!
                      .withOpacity(0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      );
    }

    if ((title.isEmpty &&
            content.isEmpty &&
            widget.note.listContent.isEmpty &&
            !widget.note.hideContent &&
            widget.note.images.isEmpty) ||
        (content.isNotEmpty && !widget.note.hideContent)) {
      items.add(
        spannableList != null
            ? RichText(
                text: spannableList.toTextSpan(
                  widget.note.content,
                  defaultStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 16,
                        color: Theme.of(context)
                            .textTheme
                            .caption!
                            .color!
                            .withOpacity(0.5),
                      ),
                ),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .textTheme
                      .caption!
                      .color!
                      .withOpacity(0.5),
                ),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
      );
    }

    if (widget.note.list &&
        widget.note.listContent.isNotEmpty &&
        !widget.note.hideContent) {
      items.add(
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) => listContentWidgets[index],
          itemCount: listContentWidgets.length,
          separatorBuilder: (context, index) => SizedBox(height: 4),
        ),
      );
    }

    return items;
  }

  List<Widget> get listContentWidgets => List.generate(
        min(widget.note.listContent.length, 6),
        (index) {
          ListItem item = widget.note.listContent[index];
          Color backgroundColor = widget.note.color != 0
              ? Color(
                  NoteColors.colorList[widget.note.color].dynamicColor(context))
              : Theme.of(context).cardColor;
          bool showMoreItem = index == 5;
          final icon = showMoreItem
              ? Icon(
                  Icons.add,
                  size: 20,
                )
              : NoteViewCheckbox(
                  value: item.status,
                  activeColor: widget.note.color != 0
                      ? Theme.of(context).textTheme.caption!.color!
                      : Theme.of(context).accentColor,
                  checkColor: backgroundColor,
                  onChanged: (value) {
                    widget.note.listContent[index].status = value!;
                    widget.note.markChanged();
                    helper.saveNote(widget.note);
                    setState(() {});
                  },
                  splashRadius: 14,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                );
          final text = showMoreItem
              ? "${(widget.note.listContent.length) - 5} more items"
              : item.text;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  IgnorePointer(
                    ignoring: !_mouseIsConnected || widget.selectorOpen,
                    child: SizedBox.fromSize(
                      size: Size.square(24),
                      child: Center(
                        child: icon,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: constraints.maxWidth - 32,
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .caption!
                            .color!
                            .withOpacity(
                              item.status && !showMoreItem ? 0.5 : 0.7,
                            ),
                        decoration: item.status && !showMoreItem
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
}
