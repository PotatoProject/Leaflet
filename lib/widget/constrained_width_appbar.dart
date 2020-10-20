import 'package:flutter/material.dart';

class ConstrainedWidthAppbar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget child;

  ConstrainedWidthAppbar({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final _padding = (constraints.maxWidth - 1080) / 2;

        return Container(
          margin: EdgeInsets.symmetric(
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
