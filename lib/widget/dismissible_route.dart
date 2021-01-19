import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

bool _gestureStartAllowed = false;

class DismissiblePageRoute<T> extends PageRoute<T> {
  DismissiblePageRoute({
    @required this.builder,
    this.allowGestures = false,
    this.pushImmediate = false,
  });

  final WidgetBuilder builder;
  final bool allowGestures;
  final bool pushImmediate;

  @override
  final bool maintainState = false;

  @override
  Duration get transitionDuration =>
      Duration(milliseconds: pushImmediate ? 0 : 250);

  @override
  Duration get reverseTransitionDuration => Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Curve get barrierCurve => Curves.easeIn;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return nextRoute is MaterialPageRoute ||
        nextRoute is CupertinoPageRoute ||
        nextRoute is DismissiblePageRoute;
  }

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return nextRoute is MaterialPageRoute ||
        nextRoute is CupertinoPageRoute ||
        nextRoute is DismissiblePageRoute;
  }

  @override
  bool get canPop => super.canPop;

  @override
  bool get barrierDismissible => false;

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
      this,
      context,
      animation,
      secondaryAnimation,
      child,
      allowGestures: allowGestures,
    );
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
      child: DismissibleRoute(
        child: child,
        maxWidth: MediaQuery.of(context).size.width,
        enableGesture: allowGestures && _isPopGestureEnabled(route),
        controller: route.controller,
        navigator: route.navigator,
        isFirst: route.isFirst,
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
      curve: linearTransition
          ? Curves.linear
          : SuspendedCurve(
              animation.value,
              curve: decelerateEasing,
            ),
      reverseCurve: linearTransition
          ? Curves.linear
          : SuspendedCurve(
              animation.value,
              curve: accelerateEasing,
            ),
    ).drive(Tween<Offset>(
      begin: Offset(textDirection == TextDirection.rtl ? -1 : 1, 0),
      end: Offset(0, 0),
    ));

    Animation<Offset> bgAnimation = CurvedAnimation(
      parent: secondaryAnimation,
      curve: linearTransition
          ? Curves.linear
          : SuspendedCurve(
              secondaryAnimation.value,
              curve: decelerateEasing,
            ),
      reverseCurve: linearTransition
          ? Curves.linear
          : SuspendedCurve(
              secondaryAnimation.value,
              curve: accelerateEasing,
            ),
    ).drive(Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-0.3, 0),
    ));

    if (deviceInfo.uiSizeFactor > 3) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      );
    } else {
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

class DismissibleRoute extends StatefulWidget {
  final Widget child;
  final double maxWidth;
  final bool enableGesture;
  final AnimationController controller;
  final NavigatorState navigator;
  final bool isFirst;

  DismissibleRoute({
    @required this.child,
    @required this.maxWidth,
    this.enableGesture = true,
    @required this.controller,
    @required this.navigator,
    this.isFirst = false,
  });

  @override
  _DismissibleRouteState createState() => _DismissibleRouteState();

  static _DismissibleRouteState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_DismissibleRouteInheritedWidget>()
        ?.state;
  }
}

class _DismissibleRouteState extends State<DismissibleRoute> {
  bool _requestDisableGestures = false;

  set requestDisableGestures(bool disable) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() => _requestDisableGestures = disable),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final _barrierDismissible =
        _requestDisableGestures ? false : widget.enableGesture;
    final _enableGesture =
        deviceInfo.uiSizeFactor > 3 ? false : _barrierDismissible;
    final padding = EdgeInsets.symmetric(
      horizontal: !widget.isFirst && deviceInfo.uiSizeFactor > 3
          ? MediaQuery.of(context).size.width / 8
          : 0,
      vertical: !widget.isFirst && deviceInfo.uiSizeFactor > 3
          ? MediaQuery.of(context).size.height / 16
          : 0,
    );

    final EdgeInsets effectivePadding = (padding ?? EdgeInsets.zero);

    final Widget content = Material(
      elevation: 16,
      shape: !widget.isFirst
          ? deviceInfo.uiSizeFactor > 3
              ? Theme.of(context).dialogTheme.shape
              : RoundedRectangleBorder()
          : RoundedRectangleBorder(),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        dragStartBehavior: DragStartBehavior.down,
        onTap: () {},
        onHorizontalDragStart: _enableGesture
            ? (details) {
                setState(() => _gestureStartAllowed = true);
              }
            : null,
        onHorizontalDragUpdate: _gestureStartAllowed
            ? (details) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
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
                  Navigator.pop(context);
                } else {
                  if (widget.controller.value < 0.5) {
                    Navigator.pop(context);
                  } else {
                    await widget.controller.animateTo(1);
                  }
                }
              }
            : null,
        child: widget.child,
      ),
    );

    return _DismissibleRouteInheritedWidget(
      state: this,
      child: GestureDetector(
        onTap: () {
          if (_barrierDismissible) widget.navigator.pop();
        },
        child: AnimatedContainer(
          color: Colors.black45,
          padding: effectivePadding,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: MediaQuery(
            child: content,
            data: MediaQuery.of(context).copyWith(
              padding: deviceInfo.uiSizeFactor > 3
                  ? EdgeInsets.zero
                  : MediaQuery.of(context).padding,
            ),
          ),
        ),
      ),
    );
  }
}

class _DismissibleRouteInheritedWidget extends InheritedWidget {
  _DismissibleRouteInheritedWidget({
    Key key,
    Widget child,
    this.state,
  }) : super(key: key, child: child);

  final _DismissibleRouteState state;

  @override
  bool updateShouldNotify(_DismissibleRouteInheritedWidget oldWidget) {
    return oldWidget.state != state;
  }
}
