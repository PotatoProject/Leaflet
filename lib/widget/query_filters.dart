import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/date_selector.dart';
import 'package:potato_notes/widget/tag_search_delegate.dart';

import 'note_color_selector.dart';

class QueryFilters extends StatefulWidget {
  final SearchQuery query;
  final Function() filterChangedCallback;

  QueryFilters({
    @required this.query,
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
          secondary: Icon(Icons.format_size),
          title: Text(LocaleStrings.common.caseSensitive),
          value: widget.query.caseSensitive,
          activeColor: Theme.of(context).accentColor,
          onChanged: (value) {
            setState(() => widget.query.caseSensitive = value);
            if (widget.filterChangedCallback != null)
              widget.filterChangedCallback();
          },
        ),
        SwitchListTile(
          secondary: Icon(Icons.favorite_border),
          title: Text("Favourites only"),
          value: widget.query.onlyFavourites,
          activeColor: Theme.of(context).accentColor,
          onChanged: (value) {
            setState(() => widget.query.onlyFavourites = value);
            if (widget.filterChangedCallback != null)
              widget.filterChangedCallback();
          },
        ),
        ListTile(
          leading: Icon(Icons.color_lens_outlined),
          title: Text(LocaleStrings.common.colorFilter),
          trailing: Icon(
            Icons.brightness_1,
            size: 28,
            color: Color(
                NoteColors.colorList[widget.query.color].dynamicColor(context)),
          ),
          onTap: () async {
            int queryColor = await Utils.showNotesModalBottomSheet(
              context: context,
              builder: (context) => NoteColorSelector(
                selectedColor: widget.query.color ?? 0,
                onColorSelect: (color) {
                  if (color == 0)
                    Navigator.pop(context, -1);
                  else
                    Navigator.pop(context, color);
                },
              ),
            );

            if (queryColor != null) {
              setState(() => widget.query.color = queryColor);
            }
            if (widget.filterChangedCallback != null)
              widget.filterChangedCallback();
          },
        ),
        ListTile(
          leading: Icon(Icons.date_range_outlined),
          title: Text(LocaleStrings.common.dateFilter),
          subtitle: widget.query.date != null
              ? Text(DateFormat("EEEE d MMM yyyy").format(widget.query.date) +
                  " - " +
                  DateFilterSelector.stringFromDateMode(widget.query.dateMode))
              : null,
          onTap: () async {
            await Utils.showNotesModalBottomSheet(
                context: context,
                builder: (context) => DateFilterSelector(
                      date: widget.query.date,
                      mode: widget.query.dateMode,
                      onConfirm: (date, mode) {
                        setState(() {
                          widget.query.date = date;
                          widget.query.dateMode = mode;
                        });
                        if (widget.filterChangedCallback != null)
                          widget.filterChangedCallback();
                      },
                      onReset: () {
                        setState(() {
                          widget.query.date = null;
                          widget.query.dateMode = DateFilterMode.ONLY;
                        });
                        if (widget.filterChangedCallback != null)
                          widget.filterChangedCallback();
                      },
                    ));
          },
        ),
        ListTile(
          leading: Icon(Icons.label_outline),
          title: Text("Tags"),
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

            if (widget.filterChangedCallback != null)
              widget.filterChangedCallback();
          },
        ),
      ],
    );
  }
}
