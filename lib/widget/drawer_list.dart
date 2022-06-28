import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/widget/drawer_list_tile.dart';

class DrawerList extends StatelessWidget {
  final Widget? header;
  final List<BottomNavigationBarItem> items;
  final List<BottomNavigationBarItem>? secondaryItems;
  final Widget? secondaryItemsFooter;
  final Widget? footer;
  final int currentIndex;
  final bool showTitles;
  final bool enabled;
  final ValueChanged<int>? onTap;
  final ValueChanged<int>? onSecondaryTap;

  const DrawerList({
    this.header,
    required this.items,
    this.secondaryItems,
    this.secondaryItemsFooter,
    this.footer,
    this.currentIndex = 0,
    this.showTitles = true,
    this.enabled = true,
    this.onTap,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.theme.appBarTheme.systemOverlayStyle!,
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                indent: 8,
                endIndent: 8,
              ),
              itemBuilder: (context, index) => drawerSections[index],
              itemCount: drawerSections.length,
              padding: EdgeInsets.only(
                top: context.padding.top,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: context.viewInsets.bottom,
            ),
            child: footer ?? Container(),
          ),
        ],
      ),
    );
  }

  List<Widget> get drawerSections {
    final List<Widget> list = [];

    if (header != null) {
      list.add(header!);
    }

    list.add(generateDrawerListTiles(items, false));

    if (secondaryItems != null) {
      list.add(generateDrawerListTiles(secondaryItems!, true));
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
          duration: const Duration(milliseconds: 200),
          curve: decelerateEasing,
          child: Column(
            children: [
              ...List.generate(
                items.length,
                (index) => DrawerListTile(
                  icon: items[index].icon,
                  activeIcon: items[index].activeIcon,
                  title: Text(items[index].label!),
                  onTap: secondary
                      ? () => onSecondaryTap?.call(index)
                      : () => onTap?.call(index),
                  active: secondary
                      ? currentIndex == (index + (this.items.length))
                      : currentIndex == index,
                  showTitle: showTitles,
                ),
              ),
              if (secondary) secondaryItemsFooter ?? Container(),
            ],
          ),
        ),
      );
}

class DrawerListItem {
  final Widget icon;
  final Widget selectedIcon;
  final String label;
  final Color? color;
  final Color? selectedColor;

  const DrawerListItem({
    required this.icon,
    Widget? selectedIcon,
    required this.label,
    this.color,
    this.selectedColor,
  }) : selectedIcon = selectedIcon ?? icon;
}
