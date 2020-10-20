import 'package:flutter/material.dart';

import 'package:potato_notes/internal/providers.dart';

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
    double shortestSide = 600;
    int roundedShortestSide = (shortestSide / 10).round() * 10;
    double padding = (width - roundedShortestSide) / 2;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: SafeArea(
        child: Container(
          width: width,
          margin: EdgeInsets.only(
            left: padding.isNegative ? 0 : padding,
            right: padding.isNegative ? 0 : padding,
          ),
          constraints: BoxConstraints(
            maxHeight: deviceInfo.isLandscape ? 600 : double.infinity,
          ),
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
      ),
    );
  }
}
