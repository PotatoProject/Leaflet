import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

bool _gestureStartAllowed = false;

class DismissiblePageRoute<T> extends PageRoute<T> {
  DismissiblePageRoute({
    @required this.builder,
    this.allowGestures = false,
  });

  final WidgetBuilder builder;
  final bool allowGestures;

  @override
  final bool maintainState = false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => Duration(milliseconds: 250);

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get canPop => true;

  static bool isPopGestureInProgress(PageRoute<dynamic> route) {
    return _gestureStartAllowed;
  }

  static bool _isPopGestureEnabled<T>(PageRoute<T> route) {
    if (route.isFirst) return false;

    if (route.willHandlePopInternally) return false;

    if (!route.canPop) return false;

    if (route.fullscreenDialog) return false;

    if (route.animation.status != AnimationStatus.completed) return false;

    if (route.secondaryAnimation.status != AnimationStatus.dismissed)
      return false;

    return true;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget child = builder(context);
    final Widget result = Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: child,
    );
    assert(() {
      if (child == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'The builder for route "${settings.name}" returned null.'),
          ErrorDescription('Route builders must never return null.'),
        ]);
      }
      return true;
    }());
    return result;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return buildPageTransitions(
        this, context, animation, secondaryAnimation, child,
        allowGestures: allowGestures);
  }

  static Widget buildPageTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child, {
    bool allowGestures = true,
  }) {
    return DismissiblePageTransition(
      child: _DismissibleRoute(
        child: child,
        maxWidth: MediaQuery.of(context).size.width,
        enableGesture: allowGestures && _isPopGestureEnabled(route),
        controller: route.controller,
        navigator: route.navigator,
      ),
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      linearTransition: isPopGestureInProgress(route),
    );
  }
}

class DismissiblePageTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final bool linearTransition;

  DismissiblePageTransition({
    @required this.child,
    @required this.animation,
    @required this.secondaryAnimation,
    this.linearTransition = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    Animation<Offset> fgAnimation = CurvedAnimation(
      parent: animation,
      curve: linearTransition ? Curves.linear : Curves.easeOut,
      reverseCurve: linearTransition ? Curves.linear : Curves.easeIn,
    ).drive(Tween<Offset>(
      begin: Offset(textDirection == TextDirection.rtl ? -1 : 1, 0),
      end: Offset(0, 0),
    ));

    Animation<Offset> bgAnimation = CurvedAnimation(
      parent: secondaryAnimation,
      curve: linearTransition ? Curves.linear : Curves.easeOut,
      reverseCurve: linearTransition ? Curves.linear : Curves.easeIn,
    ).drive(Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-0.3, 0),
    ));

    return SlideTransition(
      position: bgAnimation,
      textDirection: textDirection,
      transformHitTests: false,
      child: SlideTransition(
        position: fgAnimation,
        child: child,
      ),
    );
  }
}

class DismissiblePageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      DismissiblePageRoute.buildPageTransitions(
          route, context, animation, secondaryAnimation, child);
}

class _DismissibleRoute extends StatefulWidget {
  final Widget child;
  final double maxWidth;
  final bool enableGesture;
  final AnimationController controller;
  final NavigatorState navigator;

  _DismissibleRoute({
    @required this.child,
    @required this.maxWidth,
    this.enableGesture = true,
    @required this.controller,
    @required this.navigator,
  });

  @override
  _DismissibleRouteState createState() => _DismissibleRouteState();
}

class _DismissibleRouteState extends State<_DismissibleRoute> {
  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    return SafeArea(
      top: false,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        dragStartBehavior: DragStartBehavior.down,
        onHorizontalDragStart: widget.enableGesture
            ? (details) {
                setState(() => _gestureStartAllowed = true);
              }
            : null,
        onHorizontalDragUpdate: _gestureStartAllowed
            ? (details) {
                widget.controller.value -= (textDirection == TextDirection.rtl
                        ? -details.primaryDelta
                        : details.primaryDelta) /
                    widget.maxWidth;
              }
            : null,
        onHorizontalDragEnd: _gestureStartAllowed
            ? (details) async {
                setState(() => _gestureStartAllowed = false);
                if (details.primaryVelocity > 345) {
                  await widget.controller.animateBack(0);
                  Navigator.pop(context);
                } else {
                  if (widget.controller.value < 0.5) {
                    await widget.controller.animateBack(0);
                    Navigator.pop(context);
                  } else {
                    await widget.controller.animateTo(1);
                  }
                }
              }
            : null,
        child: Material(
          elevation: 16,
          child: widget.child,
        ),
      ),
    );
  }
}
