import 'package:flutter/material.dart';

class BottomSheetBase extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double elevation;
  final ShapeBorder shape;
  final Clip clipBehavior;

  BottomSheetBase({
    @required this.child,
    this.backgroundColor,
    this.elevation = 0,
    this.shape = const RoundedRectangleBorder(),
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double shortestSide = MediaQuery.of(context).size.shortestSide;
    double padding = (width - shortestSide) / 2;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: padding),
        child: GestureDetector(
          onTapDown: (_) {},
          child: Material(
            color: backgroundColor,
            shape: shape,
            elevation: elevation ?? 1,
            clipBehavior: clipBehavior ?? Clip.none,
            child: child,
          ),
        ),
      ),
    );
  }
}
