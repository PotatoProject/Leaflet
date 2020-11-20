import 'package:flutter/material.dart';
import 'package:potato_notes/widget/drawer_list_tile.dart';

class DrawerList extends StatelessWidget {
  final Widget header;
  final List<BottomNavigationBarItem> items;
  final List<BottomNavigationBarItem> secondaryItems;
  final Widget secondaryItemsFooter;
  final Widget footer;
  final int currentIndex;
  final bool showTitles;
  final bool enabled;
  final void Function(int index) onTap;
  final void Function(int index) onSecondaryTap;

  DrawerList({
    this.header,
    @required this.items,
    this.secondaryItems,
    this.secondaryItemsFooter,
    this.footer,
    this.currentIndex = 0,
    this.showTitles = true,
    this.enabled,
    this.onTap,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              indent: 8,
              endIndent: 8,
            ),
            itemBuilder: (context, index) => drawerSections[index],
            itemCount: drawerSections.length,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
          ),
        ),
        footer ?? Container(),
      ],
    );
  }

  List<Widget> get drawerSections {
    List<Widget> list = [];

    if (header != null) {
      list.add(header);
    }

    if (items != null) {
      list.add(generateDrawerListTiles(items, false));
    }

    if (secondaryItems != null) {
      list.add(generateDrawerListTiles(secondaryItems, true));
    }

    return list;
  }

  Widget generateDrawerListTiles(
    List<BottomNavigationBarItem> items,
    bool secondary,
  ) =>
      IgnorePointer(
        ignoring: !enabled,
        child: AnimatedOpacity(
          opacity: enabled ? 1 : 0.5,
          duration: Duration(milliseconds: 200),
          curve: decelerateEasing,
          child: Column(
            children: [
              ...List.generate(
                items.length,
                (index) => DrawerListTile(
                  icon: items[index].icon,
                  activeIcon: items[index].activeIcon,
                  title: Text(items[index].label),
                  onTap: secondary
                      ? () => onSecondaryTap(index)
                      : () => onTap(index),
                  active: secondary
                      ? currentIndex == (index + (this.items.length))
                      : currentIndex == index,
                  showTitle: showTitles,
                ),
              ),
              secondary ? secondaryItemsFooter ?? Container() : Container(),
            ],
          ),
        ),
      );
}

class DrawerListItem {
  final Widget icon;
  final Widget selectedIcon;
  final String label;
  final Color color;
  final Color selectedColor;

  const DrawerListItem({
    @required this.icon,
    Widget selectedIcon,
    this.label,
    this.color,
    this.selectedColor,
  })  : selectedIcon = selectedIcon ?? icon,
        assert(icon != null);
}
