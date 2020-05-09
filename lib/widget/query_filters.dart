import 'package:flutter/material.dart';
import 'package:potato_notes/data/dao/note_helper.dart';

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
            if(widget.filterChangedCallback != null)
              widget.filterChangedCallback();
          }
        ),
      ],
    );
  }
}
