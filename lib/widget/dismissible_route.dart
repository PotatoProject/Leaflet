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
    return nextRoute is MaterialPageRoute ||
        nextRoute is CupertinoPageRoute ||
        nextRoute is DismissiblePageRoute;
  }

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> nextRoute) {
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

class DismissiblePageTransition extends StatefulWidget {
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
  _DismissiblePageTransitionState createState() =>
      _DismissiblePageTransitionState();
}

class _DismissiblePageTransitionState extends State<DismissiblePageTransition> {
  Curve _curveFg;
  Curve _reverseCurveFg;
  Curve _curveBg;
  Curve _reverseCurveBg;

  @override
  void initState() {
    super.initState();
    _updateCurves();
  }

  @override
  void didUpdateWidget(DismissiblePageTransition old) {
    super.didUpdateWidget(old);
    if (widget.linearTransition != old.linearTransition) {
      _updateCurves();
    }
  }

  void _updateCurves() {
    _curveFg = widget.linearTransition ? Curves.linear : decelerateEasing;
    _reverseCurveFg =
        widget.linearTransition ? Curves.linear : accelerateEasing;
    _curveBg = widget.linearTransition ? Curves.linear : decelerateEasing;
    _reverseCurveBg =
        widget.linearTransition ? Curves.linear : accelerateEasing;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    Animation<Offset> fgAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: _curveFg,
      reverseCurve: _reverseCurveFg,
    ).drive(
      Tween<Offset>(
        begin: Offset(textDirection == TextDirection.rtl ? -1 : 1, 0),
        end: Offset.zero,
      ),
    );

    Animation<Offset> bgAnimation = CurvedAnimation(
      parent: widget.secondaryAnimation,
      curve: _curveBg,
      reverseCurve: _reverseCurveBg,
    ).drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-0.3, 0),
      ),
    );

    if (deviceInfo.uiSizeFactor > 3) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: widget.animation,
          curve: Curves.easeOut,
        ),
        child: widget.child,
      );
    } else {
      return SlideTransition(
        position: bgAnimation,
        textDirection: textDirection,
        transformHitTests: false,
        child: SlideTransition(
          position: fgAnimation,
          child: widget.child,
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
    final bool _barrierDismissible =
        _requestDisableGestures ? false : widget.enableGesture;
    final bool _enableGesture =
        deviceInfo.uiSizeFactor > 3 ? false : _barrierDismissible;
    final EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: context.mediaQuery.size.width / 8,
      vertical: context.mediaQuery.size.height / 16,
    );

    final double width = widget.isFirst || deviceInfo.uiSizeFactor <= 3
        ? context.mediaQuery.size.width
        : (context.mediaQuery.size.width - padding.horizontal)
            .clamp(0.0, 720.0);
    final double height = widget.isFirst || deviceInfo.uiSizeFactor <= 3
        ? context.mediaQuery.size.height
        : (context.mediaQuery.size.height - padding.vertical).clamp(0.0, 580.0);

    final Widget content = Material(
      elevation: 16,
      shape: !widget.isFirst
          ? deviceInfo.uiSizeFactor > 3
              ? context.theme.dialogTheme.shape
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
                widget.controller.value -=
                    (context.directionality == TextDirection.rtl
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
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: Center(
            child: SizedBox(
              width: width,
              height: height,
              child: MediaQuery(
                child: content,
                data: context.mediaQuery.copyWith(
                  padding: deviceInfo.uiSizeFactor > 3 && !widget.isFirst
                      ? EdgeInsets.zero
                      : context.mediaQuery.padding,
                  viewInsets: context.mediaQuery.viewInsets.copyWith(
                    bottom: context.mediaQuery.viewInsets.bottom -
                        ((context.mediaQuery.size.height - height) / 2),
                  ),
                ),
              ),
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
