import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/data/dao/note_helper.dart';

class MainPageBar extends StatelessWidget {
  final ReturnMode currentMode;
  final bool enabled;
  final Function(ReturnMode) onReturnModeChange;

  MainPageBar({
    this.currentMode = ReturnMode.NORMAL,
    this.enabled = true,
    this.onReturnModeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      color: Theme.of(context).canvasColor,
      child: IgnorePointer(
        ignoring: !enabled,
        child: AnimatedOpacity(
          opacity: enabled ? 1.0 : 0.5,
          duration: Duration(milliseconds: 300),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(CommunityMaterialIcons.home_variant_outline),
                activeIcon: Icon(CommunityMaterialIcons.home_variant),
                title: Text("Home"),
              ),
              BottomNavigationBarItem(
                icon: Icon(MdiIcons.archiveOutline),
                activeIcon: Icon(MdiIcons.archive),
                title: Text("Archive"),
              ),
              BottomNavigationBarItem(
                icon: Icon(CommunityMaterialIcons.trash_can_outline),
                activeIcon: Icon(CommunityMaterialIcons.trash_can),
                title: Text("Trash"),
              ),
              BottomNavigationBarItem(
                icon: Icon(CommunityMaterialIcons.heart_multiple_outline),
                activeIcon: Icon(CommunityMaterialIcons.heart_multiple),
                title: Text("Favourites"),
              ),
            ],
            backgroundColor: Colors.transparent,
            selectedFontSize: 12,
            currentIndex: currentMode.index - 1,
            onTap: (index) => onReturnModeChange(ReturnMode.values[index + 1]),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
