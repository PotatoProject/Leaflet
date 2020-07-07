import 'package:flutter/material.dart';
import 'package:potato_notes/widget/drawer_list_tile.dart';

class DrawerList extends StatelessWidget {
  final Widget header;
  final List<DrawerListItem> items;
  final List<DrawerListItem> secondaryItems;
  final Widget secondaryItemsFooter;
  final Widget footer;
  final int currentIndex;
  final bool showTitles;
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
            padding: EdgeInsets.all(0),
          ),
        ),
        footer ?? Container(),
      ],
    );
  }

  List<Widget> get drawerSections {
    List<Widget> list = [];

    if (header != null) {
      list.add(
        Column(
          children: <Widget>[
            SizedBox(height: 8),
            header,
          ],
        ),
      );
    }

    if (items != null) {
      list.add(generateDrawerListTiles(items, false));
    }

    if (secondaryItems != null) {
      list.add(generateDrawerListTiles(secondaryItems, true));
    }

    return list;
  }

  Widget generateDrawerListTiles(List<DrawerListItem> items, bool secondary) =>
      Column(
        children: [
          ...List.generate(
            items.length,
            (index) => DrawerListTile(
              icon: items[index].icon,
              activeIcon: items[index].selectedIcon,
              title: items[index].label,
              onTap: secondary
                  ? () => onSecondaryTap(index)
                  : () => onTap(index),
              active: secondary
                  ? currentIndex == (index + (this.items.length))
                  : currentIndex == index,
              showTitle: showTitles,
              iconColor: items[index].color,
              activeColor: items[index].selectedColor,
            ),
          ),
          secondary
              ? secondaryItemsFooter ?? Container()
              : Container(),
        ],
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
