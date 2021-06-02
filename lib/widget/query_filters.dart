import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/date_selector.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.format_size),
            title: Text(LocaleStrings.search.noteFiltersCaseSensitive),
            value: widget.query.caseSensitive,
            activeColor: context.theme.colorScheme.secondary,
            onChanged: (value) {
              setState(() => widget.query.caseSensitive = value);
              widget.filterChangedCallback?.call();
            },
          ),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.favorite_border),
            title: Text(LocaleStrings.search.noteFiltersFavourites),
            value: widget.query.onlyFavourites,
            activeColor: context.theme.colorScheme.secondary,
            onChanged: (value) {
              setState(() => widget.query.onlyFavourites = value);
              widget.filterChangedCallback?.call();
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: Text(LocaleStrings.search.noteFiltersLocations),
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
            title: Text(LocaleStrings.search.noteFiltersColor),
            trailing: Container(
              width: 28,
              height: 28,
              decoration: ShapeDecoration(
                shape: CircleBorder(
                  side: widget.query.color == 0
                      ? BorderSide(
                          color: context.theme.textTheme.bodyText1!.color!
                              .withOpacity(0.3),
                          width: 2,
                        )
                      : BorderSide.none,
                ),
                color:
                    context.notePalette.colors[widget.query.color ?? 0].color,
              ),
            ),
            onTap: () async {
              int? selectedColor = widget.query.color;
              final int? queryColor = await Utils.showModalBottomSheet(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) {
                    return DialogSheetBase(
                      content: NoteColorSelector(
                        selectedColor: selectedColor,
                        onColorSelect: (color) =>
                            setState(() => selectedColor = color),
                      ),
                      contentPadding: EdgeInsets.zero,
                      actions: [
                        TextButton(
                          onPressed: () => context.pop(-1),
                          child: Text(LocaleStrings.common.reset),
                        ),
                        TextButton(
                          onPressed: () => context.pop(selectedColor),
                          child: Text(LocaleStrings.common.confirm),
                        ),
                      ],
                    );
                  },
                ),
              );

              if (queryColor != null) {
                setState(
                  () =>
                      widget.query.color = queryColor != -1 ? queryColor : null,
                );
              }
              widget.filterChangedCallback?.call();
            },
          ),
          ListTile(
            leading: const Icon(Icons.date_range_outlined),
            title: Text(LocaleStrings.search.noteFiltersDate),
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
            title: Text(LocaleStrings.search.noteFiltersTags),
            trailing: Text(
              widget.query.tags.isNotEmpty
                  ? LocaleStrings.search
                      .noteFiltersTagsSelected(widget.query.tags.length)
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
            title: Text(LocaleStrings.search.noteFiltersClear),
            onTap: () async {
              widget.query.reset();
              setState(() {});

              widget.filterChangedCallback?.call();
            },
          ),
        ],
      ),
    );
  }

  String get returnModeToString {
    final List<String> enabled = [];

    if (widget.query.returnMode.fromNormal) {
      enabled.add(LocaleStrings.search.noteFiltersLocationsNormal);
    }
    if (widget.query.returnMode.fromArchive) {
      enabled.add(LocaleStrings.search.noteFiltersLocationsArchive);
    }
    if (widget.query.returnMode.fromTrash) {
      enabled.add(LocaleStrings.search.noteFiltersLocationsTrash);
    }

    return enabled.join(", ");
  }
}
