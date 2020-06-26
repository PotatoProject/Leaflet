import 'package:flutter/material.dart';
import 'package:potato_notes/widget/drawer_list_tile.dart';

class DrawerList extends StatelessWidget {
  final Widget header;
  final List<DrawerListTileData> items;
  final List<DrawerListTileData> secondaryItems;
  final Widget footer;
  final int currentIndex;
  final void Function(int index) onTap;

  DrawerList({
    this.header,
    @required this.items,
    this.secondaryItems,
    this.footer,
    this.currentIndex = 0,
    this.onTap,
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
      list.add(generateDrawerListTiles(items));
    }

    if (secondaryItems != null) {
      list.add(generateDrawerListTiles(secondaryItems));
    }

    return list;
  }

  Widget generateDrawerListTiles(List<DrawerListTileData> items) => Column(
        children: List.generate(
          items.length,
          (index) => DrawerListTile(
            icon: items[index].icon,
            activeIcon: items[index].activeIcon,
            title: items[index].title,
            onTap: () => onTap(index),
            active: currentIndex == index,
          ),
        ),
      );
}
