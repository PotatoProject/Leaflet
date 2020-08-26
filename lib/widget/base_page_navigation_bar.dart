import 'package:flutter/material.dart';

class BasePageNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int index;
  final bool enabled;
  final ValueChanged<int> onPageChanged;

  BasePageNavigationBar({
    @required this.items,
    this.index = 0,
    this.enabled = true,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 480,
      ),
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
              items: items,
              backgroundColor: Colors.transparent,
              selectedFontSize: 12,
              currentIndex: index,
              onTap: onPageChanged,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).accentColor,
              unselectedItemColor: Theme.of(context).textTheme.caption.color,
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
