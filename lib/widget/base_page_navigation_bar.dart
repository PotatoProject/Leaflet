import 'package:flutter/material.dart';
import 'package:potato_notes/internal/utils.dart';

class BasePageNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int index;
  final bool enabled;
  final ValueChanged<int>? onPageChanged;

  const BasePageNavigationBar({
    required this.items,
    this.index = 0,
    this.enabled = true,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0.5),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.039),
          ),
          BoxShadow(
            offset: const Offset(0, 3.75),
            blurRadius: 11,
            color: Colors.black.withOpacity(0.19),
          ),
        ],
      ),
      child: Material(
        color: context.theme.canvasColor,
        child: IgnorePointer(
          ignoring: !enabled,
          child: AnimatedOpacity(
            opacity: enabled ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: BottomNavigationBar(
              items: items
                  .map(
                    (e) => BottomNavigationBarItem(
                      icon: e.icon,
                      label: e.label,
                      activeIcon: e.activeIcon,
                      tooltip: "",
                    ),
                  )
                  .toList(),
              backgroundColor: Colors.transparent,
              selectedFontSize: 12,
              currentIndex: index,
              onTap: onPageChanged,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: context.theme.accentColor,
              unselectedItemColor: context.theme.textTheme.caption!.color,
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
