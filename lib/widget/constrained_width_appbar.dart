import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';

class ConstrainedWidthAppbar extends StatelessWidget with PreferredSizeWidget {
  final Widget? child;
  final double width;
  final MediaQueryData? mediaQueryData;

  ConstrainedWidthAppbar({
    required this.child,
    this.width = 1080,
    this.mediaQueryData,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: mediaQueryData ?? context.mediaQuery,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double parentWidth = constraints.maxWidth == double.infinity
              ? context.mSize.width
              : constraints.maxWidth;
          final double _padding = (parentWidth - width) / 2;

          return Container(
            width: parentWidth,
            padding: EdgeInsets.symmetric(
              horizontal: _padding.isNegative ? 0 : _padding,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(56.0);
  }
}
