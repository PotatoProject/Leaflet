import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/note_colors.dart';
import 'package:potato_notes/widget/date_selector.dart';

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
          title: Text("Case sensitive"),
          value: widget.query.caseSensitive,
          activeColor: Theme.of(context).accentColor,
          onChanged: (value) {
            setState(() => widget.query.caseSensitive = value);
            if (widget.filterChangedCallback != null)
              widget.filterChangedCallback();
          },
        ),
        ListTile(
          leading: Icon(OMIcons.colorLens),
          title: Text("Color filter"),
          trailing: Icon(
            Icons.brightness_1,
            size: 28,
            color: Color(
                NoteColors.colorList(context)[widget.query.color ?? 0]["hex"]),
          ),
          onTap: () async {
            int queryColor = await showModalBottomSheet(
              context: context,
              builder: (context) => NoteColorSelector(
                selectedColor: widget.query.color,
                onColorSelect: (color) {
                  if (color == 0)
                    Navigator.pop(context, null);
                  else
                    Navigator.pop(context, color);
                },
              ),
            );

            setState(() => widget.query.color = queryColor);
            if (widget.filterChangedCallback != null)
              widget.filterChangedCallback();
          },
        ),
        ListTile(
          leading: Icon(OMIcons.dateRange),
          title: Text("Date filter"),
          subtitle: widget.query.date != null
              ? Text(
                  DateFormat("EEEE d MMM yyyy").format(widget.query.date) +
                  " - " +
                  DateFilterSelector.stringFromDateMode(widget.query.dateMode)
                )
              : null,
          onTap: () async {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
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
              )
            );
          },
        ),
      ],
    );
  }
}
