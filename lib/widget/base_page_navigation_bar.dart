import 'package:flutter/material.dart';
import 'package:potato_notes/internal/providers.dart';

class BasePageNavigationBar extends StatelessWidget {
  final List<AdaptiveNavigationDestination> items;
  final int index;
  final bool enabled;
  final ValueChanged<int> onPageChanged;
  final Axis axis;

  BasePageNavigationBar({
    @required this.items,
    this.index = 0,
    this.enabled = true,
    this.axis = Axis.horizontal,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool extended = deviceInfo.uiSizeFactor > 4;

    switch (axis) {
      case Axis.vertical:
        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: IgnorePointer(
                      ignoring: !enabled,
                      child: AnimatedOpacity(
                        opacity: enabled ? 1.0 : 0.5,
                        duration: Duration(milliseconds: 300),
                        child: NavigationRail(
                          backgroundColor: Theme.of(context).cardColor,
                          destinations: items
                              .map(
                                (e) => NavigationRailDestination(
                                  icon: e.icon,
                                  label: e.label,
                                  selectedIcon: e.activeIcon,
                                ),
                              )
                              .toList(),
                          elevation: 8,
                          selectedIndex: index,
                          minWidth: extended ? 64 : 72,
                          extended: extended,
                          labelType: extended
                              ? NavigationRailLabelType.none
                              : NavigationRailLabelType.all,
                          groupAlignment: -1,
                          onDestinationSelected: onPageChanged,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      case Axis.horizontal:
      default:
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0.5),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.039),
              ),
              BoxShadow(
                offset: Offset(0, 3.75),
                blurRadius: 11,
                color: Colors.black.withOpacity(0.19),
              ),
            ],
          ),
          child: Material(
            elevation: 0,
            color: Theme.of(context).canvasColor,
            child: IgnorePointer(
              ignoring: !enabled,
              child: AnimatedOpacity(
                opacity: enabled ? 1.0 : 0.5,
                duration: Duration(milliseconds: 300),
                child: BottomNavigationBar(
                  items: items
                      .map(
                        (e) => BottomNavigationBarItem(
                          icon: e.icon,
                          title: e.label,
                          activeIcon: e.activeIcon,
                        ),
                      )
                      .toList(),
                  backgroundColor: Colors.transparent,
                  selectedFontSize: 12,
                  currentIndex: index,
                  onTap: onPageChanged,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Theme.of(context).accentColor,
                  unselectedItemColor:
                      Theme.of(context).textTheme.caption.color,
                  elevation: 0,
                ),
              ),
            ),
          ),
        );
    }
  }
}

@immutable
class AdaptiveNavigationDestination {
  final Widget icon;
  final Widget activeIcon;
  final Widget label;

  AdaptiveNavigationDestination({
    @required this.icon,
    this.activeIcon,
    this.label,
  });
}
