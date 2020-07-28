import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FakeFab extends StatefulWidget {
  final Key key;
  final ScrollController controller;
  final Widget child;
  final double elevation;
  final ShapeBorder shape;
  final void Function() onTap;
  final void Function() onLongPress;

  FakeFab({
    this.key,
    @required this.controller,
    this.child,
    this.elevation = 2,
    this.shape,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  _FakeFabState createState() => _FakeFabState();
}

class _FakeFabState extends State<FakeFab> with SingleTickerProviderStateMixin {
  AnimationController controller;

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

    return SlideTransition(
      position: pos,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: widget.elevation,
        clipBehavior: Clip.antiAlias,
        shape: widget.shape,
        child: InkWell(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
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
    );
  }
}
