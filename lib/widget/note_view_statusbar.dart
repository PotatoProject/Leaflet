import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liblymph/database.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/tag_chip.dart';

class NoteViewStatusbar extends StatefulWidget {
  final Note note;
  final EdgeInsets? padding;
  final List<Tag>? overrideTags;

  const NoteViewStatusbar({
    required this.note,
    this.padding,
    this.overrideTags,
  });

  @override
  _NoteViewStatusbarState createState() => _NoteViewStatusbarState();
}

class _NoteViewStatusbarState extends State<NoteViewStatusbar> {
  static const Map<String, IconData> iconData = {
    'visible': Icons.visibility_off_outlined,
    'locked': Icons.lock_outlined,
    'hasBiometrics': Icons.fingerprint,
    'hasReminders': Icons.alarm_outlined,
    'starred': Icons.favorite_border,
    'pinned': Icons.push_pin_outlined,
  };

  final List<Widget> icons = [];

  @override
  void initState() {
    super.initState();
    if (DeviceInfo.isAndroid) {
      reaction(
        (_) => appInfo.activeNotifications,
        (msg) => _updateIcons(),
      );
      _updateIcons();
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
    final List<String> actualTags =
        widget.note.getActualTags(overrideTags: widget.overrideTags);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
          visible: actualTags.isNotEmpty,
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(
                actualTags.length > 3 ? 4 : actualTags.length,
                (index) {
                  if (index != 3) {
                    final List<Tag> tags = widget.overrideTags ?? prefs.tags;
                    final Tag tag = tags.firstWhere(
                      (tag) => tag.id == actualTags[index],
                    );

                    return TagChip(
                      title: tag.name,
                    );
                  } else {
                    return TagChip(
                      title: "+${actualTags.length - 3}",
                      showIcon: false,
                    );
                  }
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: widget.padding ??
              EdgeInsets.only(
                left: 16 + context.theme.visualDensity.horizontal,
                right: 16 + context.theme.visualDensity.horizontal,
                bottom: 16 + context.theme.visualDensity.vertical,
              ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat("d MMMM y", context.locale.toString())
                      .format(widget.note.creationDate),
                  style: TextStyle(
                    color: context.theme.iconTheme.color!.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
              Visibility(
                visible: icons.isNotEmpty,
                child: IconTheme(
                  data: context.theme.iconTheme.copyWith(size: 16),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: List.generate(
                      icons.isNotEmpty ? icons.length + icons.length - 1 : 0,
                      (index) {
                        return index.isEven
                            ? icons[index ~/ 2]
                            : const VerticalDivider(
                                width: 4,
                                color: Colors.transparent,
                              );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> getIcons(
    BuildContext context,
  ) {
    final List<String> icons = [];

    if (widget.note.hideContent) icons.add('visible');

    if (widget.note.lockNote && prefs.masterPass != "") icons.add('locked');

    if (widget.note.usesBiometrics && prefs.masterPass != "") {
      icons.add('hasBiometrics');
    }

    if (widget.note.reminders.isNotEmpty) icons.add('hasReminders');

    if (widget.note.starred) icons.add('starred');

    if (widget.note.pinned) icons.add('pinned');

    return icons
        .map(
          (e) => Icon(
            iconData[e],
            size: 14,
          ),
        )
        .toList();
  }
}
