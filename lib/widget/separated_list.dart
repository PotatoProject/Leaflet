import 'package:flutter/material.dart';

class SeparatedList extends StatelessWidget {
  final List<Widget> children;
  final Widget separator;
  final Axis axis;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const SeparatedList({
    required this.children,
    required this.separator,
    this.axis = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = children.isNotEmpty
        ? List.generate(children.length * 2 - 1, (index) {
            if (index.isEven) {
              return children[index ~/ 2];
            } else {
              return separator;
            }
          })
        : [];

    switch (axis) {
      case Axis.horizontal:
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: _children,
        );
      case Axis.vertical:
      default:
        return Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: _children,
        );
    }
  }
}
