import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:potato_notes/internal/theme/data.dart';

class LeafletTheme extends StatelessWidget {
  final Widget child;
  final LeafletThemeData data;

  const LeafletTheme({
    required this.child,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return _LeafletThemeInheritedWidget(
      data: data,
      child: child,
    );
  }

  static LeafletThemeData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_LeafletThemeInheritedWidget>()!
        .data;
  }

  static LeafletThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_LeafletThemeInheritedWidget>()
        ?.data;
  }
}

class _LeafletThemeInheritedWidget extends InheritedWidget {
  final LeafletThemeData data;

  const _LeafletThemeInheritedWidget({
    required this.data,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant _LeafletThemeInheritedWidget old) {
    return data != old.data;
  }
}

class AnimatedLeafletTheme extends ImplicitlyAnimatedWidget {
  /// Creates an animated theme.
  ///
  /// By default, the theme transition uses a linear curve. The [data] and
  /// [child] arguments must not be null.
  const AnimatedLeafletTheme({
    Key? key,
    required this.data,
    Curve curve = Curves.linear,
    Duration duration = kThemeAnimationDuration,
    VoidCallback? onEnd,
    required this.child,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  /// Specifies the color and typography values for descendant widgets.
  final LeafletThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  AnimatedWidgetBaseState<AnimatedLeafletTheme> createState() =>
      _AnimatedThemeState();
}

class _AnimatedThemeState
    extends AnimatedWidgetBaseState<AnimatedLeafletTheme> {
  LeafletThemeDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(
      _data,
      widget.data,
      (dynamic value) =>
          LeafletThemeDataTween(begin: value as LeafletThemeData),
    )! as LeafletThemeDataTween;
  }

  @override
  Widget build(BuildContext context) {
    return LeafletTheme(
      data: _data!.evaluate(animation),
      child: widget.child,
    );
  }
}
