import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FakeFab extends StatefulWidget {
  final Key key;
  final Object heroTag;
  final Widget child;
  final ShapeBorder shape;
  final void Function() onTap;
  final void Function() onLongPress;

  FakeFab({
    this.key,
    this.heroTag = "defaultTag",
    this.child,
    this.shape,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  _FakeFabState createState() => _FakeFabState();
}

class _FakeFabState extends State<FakeFab> {
  bool _hovered = false;
  bool _focused = false;
  bool _highlighted = false;
  double _elevation;

  @override
  Widget build(BuildContext context) {
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

    return Hero(
      tag: widget.heroTag,
      child: Material(
        color: theme.accentColor,
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
                    color: theme.scaffoldBackgroundColor,
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
