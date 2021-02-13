import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/note_list_page.dart';
import 'package:potato_notes/widget/mouse_listener_mixin.dart';
import 'package:potato_notes/widget/note_view_checkbox.dart';
import 'package:potato_notes/widget/note_images.dart';
import 'package:potato_notes/widget/note_view_statusbar.dart';
import 'package:potato_notes/widget/popup_menu_item_with_icon.dart';

class NoteView extends StatefulWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool selectorOpen;
  final bool selected;
  final ValueChanged<bool> onCheckboxChanged;
  final bool allowSelection;

  NoteView({
    Key key,
    @required this.note,
    this.onTap,
    this.onLongPress,
    this.selectorOpen = false,
    this.selected = false,
    this.onCheckboxChanged,
    this.allowSelection = false,
  }) : super(key: key);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> with MouseListenerMixin {
  bool _hovered = false;
  bool _focused = false;
  bool _highlighted = false;
  double _elevation;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.note.color != 0
        ? Color(NoteColors.colorList[widget.note.color].dynamicColor(context))
        : Theme.of(context).cardColor;
    Color borderColor = widget.selected
        ? Theme.of(context).iconTheme.color
        : Colors.transparent;
    Color checkBoxColor = widget.note.images.isNotEmpty
        ? Colors.white
        : Theme.of(context).iconTheme.color.withOpacity(1);
    Color checkColor =
        widget.note.images.isNotEmpty ? Colors.black : backgroundColor;

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

    List<Widget> content = getItems(context);
    final bool showCheckbox =
        (_hovered || widget.selected || widget.selectorOpen) &&
            widget.allowSelection;

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
      child: GestureDetector(
        onSecondaryTapDown: !widget.selectorOpen ? showOptionsMenu : null,
        onLongPressStart:
            !widget.selectorOpen && !isMouseConnected ? showOptionsMenu : null,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (value) => setState(() {
            _hovered = value;
          }),
          onFocusChange: (value) => setState(() {
            _focused = value;
          }),
          onHighlightChanged: (value) => setState(() {
            _highlighted = value;
          }),
          splashFactory: InkRipple.splashFactory,
          borderRadius: BorderRadius.circular(kCardBorderRadius),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              //Text(widget.note.toJson().toString()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IgnorePointer(
                    child: Visibility(
                      visible: (widget.note.images?.isNotEmpty ?? false) &&
                          !widget.note.hideContent,
                      child: NoteImages(
                        images: widget.note.images,
                        maxGridRows: 2,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: content.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            16 + Theme.of(context).visualDensity.horizontal,
                        vertical: 16 + Theme.of(context).visualDensity.vertical,
                      ),
                      child: _SeparatedColumn(
                        children: content,
                        separator: SizedBox(
                          height: 4 + Theme.of(context).visualDensity.vertical,
                        ),
                      ),
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
                                horizontal: 16 +
                                    Theme.of(context).visualDensity.horizontal,
                                vertical: 16 +
                                    Theme.of(context).visualDensity.vertical,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: AnimatedOpacity(
                  opacity: showCheckbox ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: 8, right: 8),
                    height: 64,
                    width: 64,
                    clipBehavior: Clip.none,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        colors: [
                          Colors.grey[900].withOpacity(
                            widget.note.images.isNotEmpty ? 0.6 : 0.2,
                          ),
                          Colors.grey[900].withOpacity(0),
                        ],
                        radius: 1,
                      ),
                    ),
                    child: IgnorePointer(
                      ignoring: !showCheckbox,
                      child: NoteViewCheckbox(
                        value: widget.selected,
                        onChanged: widget.onCheckboxChanged,
                        width: 20,
                        splashRadius: 18,
                        inactiveColor: checkBoxColor,
                        activeColor: checkBoxColor,
                        checkColor: checkColor,
                        shapeRadius: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getItems(BuildContext context) {
    List<Widget> items = [];

    if (widget.note.title != "") {
      items.add(
        Text(
          widget.note.title ?? "",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.caption.color.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    if ((widget.note.title.isEmpty &&
            widget.note.content.isEmpty &&
            widget.note.listContent.isEmpty &&
            !widget.note.hideContent &&
            widget.note.images.isEmpty) ||
        (widget.note.content.isNotEmpty && !widget.note.hideContent)) {
      items.add(
        Text(
          widget.note.content,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.caption.color.withOpacity(0.5),
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
        _SeparatedColumn(
          children: listContentWidgets,
          separator: SizedBox(height: 4),
        ),
      );
    }

    return items;
  }

  List<Widget> get listContentWidgets => List.generate(
        min(widget.note.listContent?.length ?? 0, 6),
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
                      ? Theme.of(context).textTheme.caption.color
                      : Theme.of(context).accentColor,
                  checkColor: backgroundColor,
                  onChanged: (value) {
                    widget.note.listContent[index].status = value;
                    widget.note.markChanged();
                    helper.saveNote(widget.note);
                    setState(() {});
                  },
                  splashRadius: 14,
                );
          final text = showMoreItem
              ? "${(widget.note.listContent?.length ?? 0) - 5} more items"
              : item.text;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  IgnorePointer(
                    ignoring: !isMouseConnected || widget.selectorOpen,
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
                            .caption
                            .color
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

  void showOptionsMenu(details) async {
    final selectionOptions = SelectionState.of(context).selectionOptions;
    final everyOption = selectionOptions.options(context, [widget.note]);
    final options = everyOption.where((e) => !e.oneNoteOnly).toList();
    final oneNoteOptions = everyOption.where((e) => e.oneNoteOnly).toList();

    final value = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: <PopupMenuEntry>[
        ...options
            .map<PopupMenuEntry>(
              (e) => PopupMenuItemWithIcon(
                icon: Icon(e.icon),
                child: Text(e.title),
                value: e.value,
              ),
            )
            .toList(),
        if (oneNoteOptions.isNotEmpty) PopupMenuDivider(),
        ...oneNoteOptions
            .map<PopupMenuEntry>(
              (e) => PopupMenuItemWithIcon(
                icon: Icon(e.icon),
                child: Text(e.title),
                value: e.value,
              ),
            )
            .toList(),
      ],
    );

    selectionOptions.onSelected(context, [widget.note], value);
  }
}

class _SeparatedColumn extends StatelessWidget {
  final List<Widget> children;
  final Widget separator;

  _SeparatedColumn({
    @required this.children,
    @required this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(children.length * 2 - 1, (index) {
        if (index.isEven) {
          return children[index ~/ 2];
        } else {
          return separator;
        }
      }),
    );
  }
}
