import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/internal/constants.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/mouse_listener_mixin.dart';
import 'package:potato_notes/widget/note_images.dart';
import 'package:potato_notes/widget/note_view_checkbox.dart';
import 'package:potato_notes/widget/note_view_statusbar.dart';
import 'package:potato_notes/widget/popup_menu_item_with_icon.dart';
import 'package:potato_notes/widget/selection_bar.dart';
import 'package:potato_notes/widget/separated_list.dart';

class NoteView extends StatefulWidget {
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selectorOpen;
  final bool selected;
  final ValueChanged<bool?>? onCheckboxChanged;
  final bool allowSelection;
  final List<Tag>? overrideTags;

  const NoteView({
    Key? key,
    required this.note,
    this.onTap,
    this.onLongPress,
    this.selectorOpen = false,
    this.selected = false,
    this.onCheckboxChanged,
    this.allowSelection = false,
    this.overrideTags,
  }) : super(key: key);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> with MouseListenerMixin {
  bool _hovered = false;
  bool _focused = false;
  bool _highlighted = false;
  late double _elevation;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = widget.note.color != 0
        ? context.notePalette.colors[widget.note.color].color
        : context.theme.cardColor;
    final Color borderColor =
        widget.selected ? context.theme.iconTheme.color! : Colors.transparent;
    final Color checkBoxColor =
        widget.note.images.isNotEmpty && !widget.note.hideContent
            ? Colors.white
            : context.theme.iconTheme.color!.withOpacity(1);
    final Color checkColor =
        widget.note.images.isNotEmpty && !widget.note.hideContent
            ? Colors.black
            : backgroundColor;

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

    final List<Widget> items = getItems(context);
    final bool showCheckbox =
        (_hovered || widget.selected || widget.selectorOpen) &&
            widget.allowSelection;

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
        side: BorderSide(
          color: borderColor,
          width: 2,
        ),
      ),
      clipBehavior: widget.note.images.isNotEmpty ? Clip.antiAlias : Clip.none,
      elevation: _elevation,
      shadowColor: Colors.black.withOpacity(0.4),
      margin: Constants.cardPadding,
      child: GestureDetector(
        onSecondaryTapDown: !widget.selectorOpen ? showOptionsMenu : null,
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
          onLongPress: !widget.selectorOpen && !isMouseConnected
              ? widget.onLongPress
              : null,
          splashFactory: InkRipple.splashFactory,
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IgnorePointer(
                    child: Visibility(
                      visible: (widget.note.images.isNotEmpty) &&
                          !widget.note.hideContent,
                      child: NoteImages(
                        images: widget.note.images,
                        maxGridRows: 2,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: items.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16 + context.theme.visualDensity.horizontal,
                        vertical: 16 + context.theme.visualDensity.vertical,
                      ),
                      child: SeparatedList(
                        separator: SizedBox(
                          height: 4 + context.theme.visualDensity.vertical,
                        ),
                        children: items,
                      ),
                    ),
                  ),
                  NoteViewStatusbar(
                    note: widget.note,
                    padding: items.isEmpty
                        ? EdgeInsets.symmetric(
                            horizontal:
                                16 + context.theme.visualDensity.horizontal,
                            vertical: 16 + context.theme.visualDensity.vertical,
                          )
                        : null,
                    overrideTags: widget.overrideTags,
                  ),
                ],
              ),
              PositionedDirectional(
                end: 0,
                top: 0,
                child: AnimatedOpacity(
                  opacity: showCheckbox ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    alignment: AlignmentDirectional.topEnd,
                    padding: const EdgeInsetsDirectional.only(top: 8, end: 8),
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: AlignmentDirectional.topEnd,
                        colors: [
                          Colors.grey.shade900.withOpacity(
                            widget.note.images.isNotEmpty &&
                                    !widget.note.hideContent
                                ? 0.5
                                : 0,
                          ),
                          Colors.grey.shade900.withOpacity(0),
                          Colors.grey.shade900.withOpacity(0),
                        ],
                        stops: const [0.0, 0.9, 1.0],
                        radius: 1,
                      ),
                    ),
                    child: IgnorePointer(
                      ignoring: !showCheckbox,
                      child: NoteViewCheckbox(
                        value: widget.selected,
                        onChanged: widget.onCheckboxChanged,
                        splashRadius: 18,
                        inactiveColor: checkBoxColor.withOpacity(
                          _hovered ||
                                  widget.note.images.isNotEmpty &&
                                      !widget.note.hideContent
                              ? 1.0
                              : 0.5,
                        ),
                        activeColor: checkBoxColor,
                        checkColor: checkColor,
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
    final List<Widget> items = [];

    if (widget.note.title != "") {
      items.add(
        Text(
          widget.note.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: context.theme.textTheme.caption!.color!.withOpacity(0.7),
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
            color: context.theme.textTheme.caption!.color!.withOpacity(0.5),
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
        Padding(
          padding: EdgeInsets.only(
            top: widget.note.title != "" || widget.note.content != ""
                ? 8 + context.theme.visualDensity.vertical
                : 0,
          ),
          child: SeparatedList(
            separator: const SizedBox(height: 8),
            children: listContentWidgets,
          ),
        ),
      );
    }

    return items;
  }

  List<Widget> get listContentWidgets => List.generate(
        min(widget.note.listContent.length, 6),
        (index) {
          final ListItem item = widget.note.listContent[index];
          final Color backgroundColor = widget.note.color != 0
              ? context.notePalette.colors[widget.note.color].color
              : context.theme.cardColor;
          final bool showMoreItem = index == 5;
          final Widget icon = showMoreItem
              ? const Icon(Icons.add, size: 20)
              : NoteViewCheckbox(
                  value: item.status,
                  activeColor: widget.note.color != 0
                      ? context.theme.textTheme.caption!.color
                      : context.theme.colorScheme.secondary,
                  checkColor: backgroundColor,
                  onChanged: (value) {
                    widget.note.listContent[index].status = value!;
                    widget.note.markChanged();
                    helper.saveNote(widget.note);
                    setState(() {});
                  },
                  splashRadius: 14,
                  width: 16,
                );
          final String text = showMoreItem
              ? LocaleStrings.mainPage
                  .noteListXMoreItems((widget.note.listContent.length) - 5)
              : item.text;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  IgnorePointer(
                    ignoring: !isMouseConnected || widget.selectorOpen,
                    child: SizedBox.fromSize(
                      size: const Size.square(20),
                      child: Center(
                        child: icon,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: constraints.maxWidth - 32,
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            context.theme.textTheme.caption!.color!.withOpacity(
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

  Future<void> showOptionsMenu(TapDownDetails details) async {
    final SelectionOptions selectionOptions =
        context.selectionState.selectionOptions;
    final List<SelectionOptionEntry> everyOption =
        selectionOptions.options(context, [widget.note]);
    final List<SelectionOptionEntry> options =
        everyOption.where((e) => !e.oneNoteOnly).toList();
    final List<SelectionOptionEntry> oneNoteOptions =
        everyOption.where((e) => e.oneNoteOnly).toList();

    final String? value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: <PopupMenuEntry<String>>[
        ...options
            .map<PopupMenuEntry<String>>(
              (e) => PopupMenuItemWithIcon<String>(
                icon: Icon(e.icon),
                value: e.value,
                child: Text(e.title),
              ),
            )
            .toList(),
        if (oneNoteOptions.isNotEmpty) const PopupMenuDivider(),
        ...oneNoteOptions
            .map<PopupMenuEntry<String>>(
              (e) => PopupMenuItemWithIcon<String>(
                icon: Icon(e.icon),
                value: e.value,
                child: Text(e.title),
              ),
            )
            .toList(),
      ],
    );

    if (value != null) {
      selectionOptions.onSelected?.call(context, [widget.note], value);
    }
  }
}
