import 'dart:math';

import 'package:flutter/material.dart';
import 'package:potato_notes/internal/utils.dart';

class AppbarNavigation extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int index;
  final bool enabled;
  final ValueChanged<int> onPageChanged;

  AppbarNavigation({
    @required this.items,
    @required this.index,
    this.enabled = true,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.5,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Row(
          children: List.generate(
            items.length,
            (index) => _NavigationButton(
              item: items[index],
              selected: this.index == index,
              selectedColor: context.theme.accentColor,
              onTap: () => onPageChanged(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatefulWidget {
  final BottomNavigationBarItem item;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  _NavigationButton({
    @required this.item,
    this.selected = false,
    this.selectedColor,
    this.onTap,
  });

  @override
  _NavigationButtonState createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<_NavigationButton>
    with SingleTickerProviderStateMixin {
  AnimationController _ac;

  @override
  void initState() {
    _ac = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    super.initState();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _NavigationButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ac.animateTo(widget.selected ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    final AlignmentGeometry alignment = AlignmentDirectional(-1.0, -1.0);
    final Animation<double> _curvedAnim = CurvedAnimation(
      parent: _ac,
      curve: Curves.linear,
      reverseCurve: Curves.easeIn,
    );

    return InkWell(
      onTap: widget.onTap,
      customBorder: StadiumBorder(),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            IconTheme.merge(
              data: IconThemeData(
                size: 24,
                color: widget.selected
                    ? widget.selectedColor
                    : context.theme.iconTheme.color,
                opacity: 1,
              ),
              child: widget.item.icon,
            ),
            AnimatedBuilder(
              animation: _curvedAnim,
              builder: (context, _) {
                return Opacity(
                  opacity: _curvedAnim.value,
                  child: ClipRect(
                    child: Align(
                      alignment: alignment,
                      widthFactor: max(_curvedAnim.value, 0.0),
                      heightFactor: 1.0,
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Text(
                            widget.item.label,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  widget.selected ? widget.selectedColor : null,
                              fontWeight: widget.selected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
