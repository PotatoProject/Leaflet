import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/extensions.dart';

class DateFilterSelector extends StatefulWidget {
  final DateTime? date;
  final DateFilterMode mode;
  final Function(DateTime, DateFilterMode)? onConfirm;
  final Function()? onReset;

  const DateFilterSelector({
    required this.date,
    this.mode = DateFilterMode.only,
    this.onConfirm,
    this.onReset,
  });

  @override
  _DateFilterSelectorState createState() => _DateFilterSelectorState();

  static String stringFromDateMode(DateFilterMode mode) {
    switch (mode) {
      case DateFilterMode.after:
        return LocaleStrings.search.noteFiltersDateModeAfter;
      case DateFilterMode.before:
        return LocaleStrings.search.noteFiltersDateModeBefore;
      case DateFilterMode.only:
      default:
        return LocaleStrings.search.noteFiltersDateModeExact;
    }
  }
}

class _DateFilterSelectorState extends State<DateFilterSelector> {
  late DateTime selectedDate;
  late DateFilterMode selectedMode;

  @override
  void initState() {
    selectedDate = widget.date ?? DateTime.now();
    selectedMode = widget.mode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget list = ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: <Widget>[
        _DateFilterSelectorHeader(
          selectedDate,
          onReset: widget.onReset,
        ),
        CalendarDatePicker(
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          onDateChanged: (date) => setState(() => selectedDate = date),
        ),
        ListTile(
          title: Text(LocaleStrings.search.noteFiltersDateModeTitle),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          trailing: DropdownButton<DateFilterMode>(
            items: [
              DropdownMenuItem(
                value: DateFilterMode.after,
                child: Text(
                  DateFilterSelector.stringFromDateMode(DateFilterMode.after),
                ),
              ),
              DropdownMenuItem(
                value: DateFilterMode.before,
                child: Text(
                  DateFilterSelector.stringFromDateMode(DateFilterMode.before),
                ),
              ),
              DropdownMenuItem(
                value: DateFilterMode.only,
                child: Text(
                  DateFilterSelector.stringFromDateMode(DateFilterMode.only),
                ),
              ),
            ],
            value: selectedMode,
            onChanged: (mode) => setState(() => selectedMode = mode!),
          ),
        ),
      ],
    );
    final Widget base = Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 48,
          child: list,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(LocaleStrings.common.cancel),
                ),
                const Spacer(),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    widget.onConfirm?.call(selectedDate, selectedMode);
                    context.pop();
                  },
                  child: Text(LocaleStrings.common.confirm),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return base;
  }
}

class _DateFilterSelectorHeader extends StatelessWidget {
  final DateTime date;
  final VoidCallback? onReset;

  const _DateFilterSelectorHeader(this.date, {this.onReset});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.colorScheme.surface,
      child: Container(
        width: context.mSize.width,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Row(
          children: <Widget>[
            Text(
              DateFormat("EEE, MMM d", context.locale.toLanguageTag())
                  .format(date),
              style: context.theme.textTheme.headline5!.copyWith(
                color: context.theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                onReset?.call();
                context.pop();
              },
              child: Text(LocaleStrings.common.reset),
            ),
          ],
        ),
      ),
    );
  }
}
