import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/routes/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:spicy_components/spicy_components.dart';

class MainPageBar extends StatelessWidget {
  final AnimationController controller;
  final ReturnMode currentMode;
  final Function(ReturnMode) onReturnModeChange;

  MainPageBar({
    @required this.controller,
    this.currentMode = ReturnMode.NORMAL,
    this.onReturnModeChange,
  });

  @override
  Widget build(BuildContext context) {
    Preferences prefs = Provider.of<Preferences>(context);

    return SpicyBottomBar(
      leftItems: [
        IconButton(
          icon: Icon(Icons.menu),
          padding: EdgeInsets.all(0),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => navigationSheet,
          ),
        ),
        IconButton(
          icon: Icon(
            prefs.useGrid
                ? OMIcons.viewAgenda
                : CommunityMaterialIcons.view_dashboard_outline,
          ),
          padding: EdgeInsets.all(0),
          onPressed: () async {
            if (controller.status == AnimationStatus.completed) {
              await controller.animateBack(0);
              prefs.useGrid = !prefs.useGrid;
              await controller.animateTo(1);
            }
          },
        ),
      ],
      elevation: 12,
      notched: true,
    );
  }

  Widget get navigationSheet => Builder(
        builder: (context) => Material(
          color: Theme.of(context).cardColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  currentMode == ReturnMode.NORMAL ? Icons.home : OMIcons.home,
                  color: currentMode == ReturnMode.NORMAL
                      ? Theme.of(context).accentColor
                      : null,
                ),
                title: Text(
                  "Home",
                  style: TextStyle(
                    color: currentMode == ReturnMode.NORMAL
                        ? Theme.of(context).accentColor
                        : null,
                  ),
                ),
                onTap: () {
                  onReturnModeChange(ReturnMode.NORMAL);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  currentMode == ReturnMode.ARCHIVE
                      ? Icons.archive
                      : OMIcons.archive,
                  color: currentMode == ReturnMode.ARCHIVE
                      ? Theme.of(context).accentColor
                      : null,
                ),
                title: Text(
                  "Archive",
                  style: TextStyle(
                    color: currentMode == ReturnMode.ARCHIVE
                        ? Theme.of(context).accentColor
                        : null,
                  ),
                ),
                onTap: () {
                  onReturnModeChange(ReturnMode.ARCHIVE);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  currentMode == ReturnMode.TRASH ? Icons.delete : OMIcons.delete,
                  color: currentMode == ReturnMode.TRASH
                      ? Theme.of(context).accentColor
                      : null,
                ),
                title: Text(
                  "Trash",
                  style: TextStyle(
                    color: currentMode == ReturnMode.TRASH
                        ? Theme.of(context).accentColor
                        : null,
                  ),
                ),
                onTap: () {
                  onReturnModeChange(ReturnMode.TRASH);
                  Navigator.pop(context);
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(OMIcons.settings),
                title: Text("Settings"),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    )),
              ),
            ],
          ),
        )
      );
}
