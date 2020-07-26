import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potato_notes/data/dao/note_helper.dart';

class DateFilterSelector extends StatefulWidget {
  final DateTime date;
  final DateFilterMode mode;
  final Function(DateTime, DateFilterMode) onConfirm;
  final Function() onReset;

  DateFilterSelector({
    @required this.date,
    this.mode = DateFilterMode.ONLY,
    this.onConfirm,
    this.onReset,
  });

  @override
  _DateFilterSelectorState createState() => _DateFilterSelectorState();

  static String stringFromDateMode(DateFilterMode mode) {
    String string = "";

    switch (mode) {
      case DateFilterMode.AFTER:
        string = "After date";
        break;
      case DateFilterMode.BEFORE:
        string = "Before date";
        break;
      case DateFilterMode.ONLY:
      default:
        string = "Exact date";
        break;
    }

    return string;
  }
}

class _DateFilterSelectorState extends State<DateFilterSelector> {
  DateTime selectedDate;
  DateFilterMode selectedMode;

  @override
  void initState() {
    selectedDate = widget.date ?? DateTime.now();
    selectedMode = widget.mode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget list = ListView(
      shrinkWrap: true,
      children: <Widget>[
        _DateFilterSelectorHeader(selectedDate),
        CalendarDatePicker(
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          onDateChanged: (date) => setState(() => selectedDate = date),
        ),
        ListTile(
          title: Text("Filter mode"),
          contentPadding: EdgeInsets.symmetric(horizontal: 24),
          trailing: DropdownButton(
            items: [
              DropdownMenuItem(
                child: Text(DateFilterSelector.stringFromDateMode(
                    DateFilterMode.AFTER)),
                value: DateFilterMode.AFTER,
              ),
              DropdownMenuItem(
                child: Text(DateFilterSelector.stringFromDateMode(
                    DateFilterMode.BEFORE)),
                value: DateFilterMode.BEFORE,
              ),
              DropdownMenuItem(
                child: Text(
                    DateFilterSelector.stringFromDateMode(DateFilterMode.ONLY)),
                value: DateFilterMode.ONLY,
              ),
            ],
            value: selectedMode,
            onChanged: (mode) => setState(() => selectedMode = mode),
          ),
        ),
      ],
    );
    final Widget base = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MediaQuery.of(context).orientation == Orientation.landscape
            ? Expanded(child: list)
            : list,
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                child: Text("Cancel"),
                textColor: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Spacer(),
              FlatButton(
                child: Text("Reset"),
                textColor: Theme.of(context).accentColor,
                onPressed: () {
                  widget.onReset();
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 8,
              ),
              FlatButton(
                child: Text("Confirm"),
                textColor: Theme.of(context).cardColor,
                color: Theme.of(context).accentColor,
                onPressed: () {
                  widget.onConfirm(selectedDate, selectedMode);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.shortestSide,
        ),
        child: base,
      );
    } else {
      return base;
    }
  }
}

class _DateFilterSelectorHeader extends StatelessWidget {
  final DateTime date;

  _DateFilterSelectorHeader(this.date);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        child: Text(
          DateFormat("EEE, MMM d").format(date),
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}
