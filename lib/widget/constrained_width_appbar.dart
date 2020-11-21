import 'package:flutter/material.dart';

class ConstrainedWidthAppbar extends StatelessWidget with PreferredSizeWidget {
  final Widget? child;
  final double width;

  ConstrainedWidthAppbar({
    required this.child,
    this.width = 1080,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double parentWidth = constraints.maxWidth == double.infinity
            ? MediaQuery.of(context).size.width
            : constraints.maxWidth;
        final _padding = (parentWidth - width) / 2;

        return Container(
          width: parentWidth,
          padding: EdgeInsets.symmetric(
            horizontal: _padding.isNegative ? 0 : _padding,
          ),
          child: child,
        );
      },
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(56.0);
  }
}
