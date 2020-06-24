import 'package:flutter/material.dart';

class FakeFab extends StatelessWidget {
  final Key key;
  final Widget child;
  final double elevation;
  final ShapeBorder shape;
  final void Function() onTap;
  final void Function() onLongPress;

  FakeFab({
    this.key,
    this.child,
    this.elevation = 2,
    this.shape,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: elevation,
      clipBehavior: Clip.antiAlias,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          width: 56,
          height: 56,
          child: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: Theme.of(context).iconTheme.copyWith(
                color: Theme.of(context).accentColor,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}