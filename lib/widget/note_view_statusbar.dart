import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/tag_chip.dart';

class NoteViewStatusbar extends StatelessWidget {
  final Note note;
  final EdgeInsets padding;
  final double width;

  NoteViewStatusbar({
    @required this.note,
    this.padding,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = getIcons(context);

    return Visibility(
      visible: icons.isNotEmpty || note.tags.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: note.tags.isNotEmpty,
            child: Container(
              width: width,
              padding: padding ?? const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.start,
                children: List.generate(
                  note.tags.length > 3 ? 4 : note.tags.length,
                  (index) {
                    if (index != 3) {
                      Tag tag;

                      try {
                        tag = prefs.tags
                            .firstWhere((tag) => tag.id == note.tags[index]);
                      } on StateError {
                        return Container();
                      }

                      return TagChip(
                        title: tag.name,
                        color: tag.color,
                      );
                    } else {
                      return TagChip(
                        title: "+${note.tags.length - 3}",
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
              width: width,
              padding: padding ??
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

  List<Widget> getIcons(BuildContext context) {
    List<IconData> iconData = [
      Icons.visibility_off_outlined,
      note.usesBiometrics ? Icons.fingerprint : Icons.lock_outlined,
      Icons.alarm_outlined,
      Icons.cloud_outlined,
      Icons.favorite_border
    ];

    List<int> iconDataIndexes = [];
    List<Widget> icons = [];

    if (note.hideContent) iconDataIndexes.add(0);

    if (note.lockNote) iconDataIndexes.add(1);

    if (note.reminders.isNotEmpty) iconDataIndexes.add(2);

    if (note.synced) iconDataIndexes.add(3);

    if (note.starred) iconDataIndexes.add(4);

    for (int i = 0; i < iconDataIndexes.length; i++) {
      icons.add(Icon(iconData[iconDataIndexes[i]]));
    }

    return icons;
  }
}
