import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';

class NoteViewStatusbar extends StatelessWidget {
  final Note note;

  NoteViewStatusbar({@required this.note});

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = getIcons(context);

    return Visibility(
      visible: icons.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.only(bottom: note.title != "" ? 16 : 0),
        child: IconTheme(
          data: Theme.of(context).iconTheme.copyWith(size: 16),
          child: Wrap(
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
    );
  }

  List<Widget> getIcons(BuildContext context) {
    List<MapEntry<String, IconData>> iconData = [
      MapEntry<String, IconData>(
          "Content hidden", CommunityMaterialIcons.eye_off_outline),
      MapEntry<String, IconData>(
          "Note locked", note.usesBiometrics
              ? CommunityMaterialIcons.fingerprint
              : CommunityMaterialIcons.lock_outline),
      MapEntry<String, IconData>("Reminders set", CommunityMaterialIcons.alarm),
      MapEntry<String, IconData>("Synced", CommunityMaterialIcons.sync_icon),
    ];

    List<int> iconDataIndexes = [];
    List<Widget> icons = [];

    if (note.hideContent) iconDataIndexes.add(0);

    if (note.lockNote) iconDataIndexes.add(1);

    if (note.reminders.reminders.isNotEmpty) iconDataIndexes.add(2);

    if (note.synced) iconDataIndexes.add(3);

    if (iconDataIndexes.length > 2) {
      iconDataIndexes.forEach((item) => icons.add(Icon(iconData[item].value)));
    } else {
      for(int i = 0; i < iconDataIndexes.length; i++) {
        if(i == iconDataIndexes.length - 1) {
          icons.add(Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(iconData[iconDataIndexes[i]].value),
              SizedBox(width: 4),
              Text(
                iconData[iconDataIndexes[i]].key,
                style: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                  fontSize: 12,
                ),
              ),
            ],
          ));
        } else {
          icons.add(Icon(iconData[iconDataIndexes[i]].value));
        }
      }
    }

    return icons;
  }
}
