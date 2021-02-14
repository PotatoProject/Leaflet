import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/tag_chip.dart';

class NoteViewStatusbar extends StatefulWidget {
  final Note note;
  final EdgeInsets padding;
  final double width;

  NoteViewStatusbar({
    @required this.note,
    this.padding,
    this.width,
  });

  @override
  _NoteViewStatusbarState createState() => _NoteViewStatusbarState();
}

class _NoteViewStatusbarState extends State<NoteViewStatusbar> {
  final List<Widget> icons = [];

  @override
  void initState() {
    super.initState();
    if (DeviceInfo.isAndroid) {
      reaction(
        (_) => appInfo.activeNotifications,
        (msg) => _updateIcons(),
      );
    } else {
      _updateIcons();
    }
  }

  @override
  void didUpdateWidget(covariant NoteViewStatusbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note != widget.note) {
      _updateIcons();
    }
  }

  void _updateIcons() {
    icons.clear();
    icons.addAll(getIcons(context));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: icons.isNotEmpty || widget.note.tags.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: widget.note.tags.isNotEmpty,
            child: Container(
              width: widget.width,
              padding:
                  widget.padding ?? const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.start,
                children: List.generate(
                  widget.note.tags.length > 3 ? 4 : widget.note.tags.length,
                  (index) {
                    if (index != 3) {
                      Tag tag;

                      try {
                        tag = prefs.tags.firstWhere(
                            (tag) => tag.id == widget.note.tags[index]);
                      } on StateError {
                        return Container();
                      }

                      return TagChip(
                        title: tag.name,
                      );
                    } else {
                      return TagChip(
                        title: "+${widget.note.tags.length - 3}",
                        showIcon: false,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Visibility(
            visible: icons.isNotEmpty,
            child: Container(
              width: widget.width,
              padding: widget.padding ??
                  EdgeInsets.only(
                    left: 16 + Theme.of(context).visualDensity.horizontal,
                    right: 16 + Theme.of(context).visualDensity.horizontal,
                    bottom: 16 + Theme.of(context).visualDensity.vertical,
                  ),
              child: IconTheme(
                data: Theme.of(context).iconTheme.copyWith(size: 16),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: List.generate(
                    icons.isNotEmpty ? icons.length + icons.length - 1 : 0,
                    (index) {
                      if (index % 2 == 0)
                        return icons[index ~/ 2];
                      else
                        return VerticalDivider(
                          width: 4,
                          color: Colors.transparent,
                        );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getIcons(
    BuildContext context,
  ) {
    final List<IconData> iconData = [
      Icons.visibility_off_outlined,
      widget.note.usesBiometrics ? Icons.fingerprint : Icons.lock_outlined,
      Icons.alarm_outlined,
      Icons.favorite_border,
      Icons.push_pin_outlined,
    ];

    final List<int> iconDataIndexes = [];
    final List<Widget> icons = [];

    if (widget.note.hideContent) iconDataIndexes.add(0);

    if (widget.note.lockNote) iconDataIndexes.add(1);

    if (widget.note.reminders.isNotEmpty) iconDataIndexes.add(2);

    if (widget.note.starred) iconDataIndexes.add(3);

    if (widget.note.pinned) iconDataIndexes.add(4);

    for (int i = 0; i < iconDataIndexes.length; i++) {
      icons.add(
        Icon(
          iconData[iconDataIndexes[i]],
          size: 14,
        ),
      );
    }

    return icons;
  }
}
