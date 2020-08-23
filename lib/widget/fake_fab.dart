import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FakeFab extends StatefulWidget {
  final Key key;
  final ScrollController controller;
  final Widget child;
  final ShapeBorder shape;
  final void Function() onTap;
  final void Function() onLongPress;

  FakeFab({
    this.key,
    @required this.controller,
    this.child,
    this.shape,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  _FakeFabState createState() => _FakeFabState();
}

class _FakeFabState extends State<FakeFab> with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool _hovered = false;
  bool _focused = false;
  bool _highlighted = false;
  double _elevation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    widget.controller.addListener(updatePosition);

    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(updatePosition);
    super.dispose();
  }

  void updatePosition() {
    ScrollPosition position = widget.controller.position;

    if (!controller.isAnimating) {
      if (position.userScrollDirection == ScrollDirection.reverse) {
        controller.forward();
      } else if (position.userScrollDirection == ScrollDirection.forward) {
        controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Animation<Offset> pos = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    ).drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0, 2),
      ),
    );
    ThemeData theme = Theme.of(context);

    if (_highlighted) {
      _elevation = 12;
    } else if (_hovered) {
      _elevation = 10;
    } else if (_focused) {
      _elevation = 8;
    } else {
      _elevation = 6;
    }

    return SlideTransition(
      position: pos,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: _elevation,
        clipBehavior: Clip.antiAlias,
        shape: widget.shape,
        child: GestureDetector(
          onSecondaryTap: widget.onLongPress,
          child: InkWell(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            onHover: (value) => setState(() {
              _hovered = value;
            }),
            onFocusChange: (value) => setState(() {
              _focused = value;
            }),
            onHighlightChanged: (value) => setState(() {
              _highlighted = value;
            }),
            customBorder: widget.shape,
            child: Container(
              width: 56,
              height: 56,
              child: Theme(
                data: theme.copyWith(
                  iconTheme: theme.iconTheme.copyWith(
                    color: theme.accentColor,
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
