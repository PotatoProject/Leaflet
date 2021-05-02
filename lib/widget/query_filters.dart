import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/date_selector.dart';
import 'package:potato_notes/widget/return_mode_sheet.dart';
import 'package:potato_notes/widget/tag_search_delegate.dart';

import 'note_color_selector.dart';

class QueryFilters extends StatefulWidget {
  final SearchQuery query;
  final VoidCallback? filterChangedCallback;

  const QueryFilters({
    required this.query,
    this.filterChangedCallback,
  });

  @override
  _QueryFiltersState createState() => _QueryFiltersState();
}

class _QueryFiltersState extends State<QueryFilters> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.format_size),
          title: Text(LocaleStrings.common.caseSensitive),
          value: widget.query.caseSensitive,
          activeColor: context.theme.colorScheme.secondary,
          onChanged: (value) {
            setState(() => widget.query.caseSensitive = value);
            widget.filterChangedCallback?.call();
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.favorite_border),
          title: const Text("Favourites only"),
          value: widget.query.onlyFavourites,
          activeColor: context.theme.colorScheme.secondary,
          onChanged: (value) {
            setState(() => widget.query.onlyFavourites = value);
            widget.filterChangedCallback?.call();
          },
        ),
        ListTile(
          leading: const Icon(Icons.folder_outlined),
          title: const Text("Note locations"),
          subtitle: Text(returnModeToString),
          onTap: () async {
            await Utils.showModalBottomSheet(
              context: context,
              builder: (context) => ReturnModeSelectionSheet(
                mode: widget.query.returnMode,
                onModeChanged: (mode) {
                  widget.query.returnMode = mode;
                  setState(() {});
                  widget.filterChangedCallback?.call();
                },
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.color_lens_outlined),
          title: Text(LocaleStrings.common.colorFilter),
          trailing: Icon(
            Icons.brightness_1,
            size: 28,
            color: context.notePalette.colors[widget.query.color].color,
          ),
          onTap: () async {
            final int? queryColor = await Utils.showModalBottomSheet(
              context: context,
              builder: (context) => NoteColorSelector(
                selectedColor: widget.query.color,
                onColorSelect: (color) {
                  if (color == 0) {
                    context.pop(-1);
                  } else {
                    context.pop(color);
                  }
                },
              ),
            );

            if (queryColor != null) {
              setState(() => widget.query.color = queryColor);
            }
            widget.filterChangedCallback?.call();
          },
        ),
        ListTile(
          leading: const Icon(Icons.date_range_outlined),
          title: Text(LocaleStrings.common.dateFilter),
          subtitle: widget.query.date != null
              ? Text(
                  "${DateFormat("EEEE d MMM yyyy").format(widget.query.date!)} - ${DateFilterSelector.stringFromDateMode(widget.query.dateMode)}",
                )
              : null,
          onTap: () async {
            await Utils.showModalBottomSheet(
              context: context,
              builder: (context) => DateFilterSelector(
                date: widget.query.date,
                mode: widget.query.dateMode,
                onConfirm: (date, mode) {
                  setState(() {
                    widget.query.date = date;
                    widget.query.dateMode = mode;
                  });
                  widget.filterChangedCallback?.call();
                },
                onReset: () {
                  setState(() {
                    widget.query.date = null;
                    widget.query.dateMode = DateFilterMode.only;
                  });
                  widget.filterChangedCallback?.call();
                },
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.label_outline),
          title: const Text("Tags"),
          trailing: Text(
            widget.query.tags.isNotEmpty
                ? "${widget.query.tags.length} selected"
                : "",
          ),
          onTap: () async {
            await Utils.showSecondaryRoute(
              context,
              SearchPage(
                delegate: TagSearchDelegate(
                  widget.query.tags,
                  onChanged: () => setState(() {}),
                ),
              ),
            );

            widget.filterChangedCallback?.call();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(MdiIcons.filterRemoveOutline),
          title: const Text("Clear filters"),
          onTap: () async {
            widget.query.reset();
            setState(() {});

            widget.filterChangedCallback?.call();
          },
        ),
      ],
    );
  }

  String get returnModeToString {
    final List<String> enabled = [];

    if (widget.query.returnMode.fromNormal) enabled.add("Normal");
    if (widget.query.returnMode.fromArchive) enabled.add("Archive");
    if (widget.query.returnMode.fromTrash) enabled.add("Trash");

    return enabled.join(", ");
  }
}
