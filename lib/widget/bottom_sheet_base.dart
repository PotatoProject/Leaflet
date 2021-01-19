import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

// ignore_for_file: invalid_use_of_protected_member
class BottomSheetRoute<T> extends PopupRoute<T> {
  BottomSheetRoute({
    @required this.child,
    this.backgroundColor,
    this.elevation = 0,
    this.shape = const RoundedRectangleBorder(),
    this.clipBehavior = Clip.none,
    this.maintainState = true,
  });

  final Widget child;
  final Color backgroundColor;
  final double elevation;
  final ShapeBorder shape;
  final Clip clipBehavior;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _BottomSheetBase(
      child: child,
      route: this,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
    );
  }

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => Duration(milliseconds: 250);

  @override
  bool get barrierDismissible => true;

  @override
  Curve get barrierCurve => decelerateEasing;
}

class _BottomSheetBase extends StatefulWidget {
  final Widget child;
  final BottomSheetRoute route;
  final Color backgroundColor;
  final double elevation;
  final ShapeBorder shape;
  final Clip clipBehavior;

  _BottomSheetBase({
    @required this.child,
    @required this.route,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
  });

  @override
  _BottomSheetBaseState createState() => _BottomSheetBaseState();
}

class _BottomSheetBaseState extends State<_BottomSheetBase> {
  GlobalKey _childKey = GlobalKey();
  Curve _curve = decelerateEasing;

  double get _childHeight {
    RenderBox box = _childKey.currentContext.findRenderObject();
    return box.size.height;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.route.animation,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double shortestSide = 600;
            int roundedShortestSide = (shortestSide / 10).round() * 10;

            final _constraints = BoxConstraints(
              minWidth: 0,
              maxWidth: roundedShortestSide.toDouble(),
              minHeight: 0.0,
              maxHeight: deviceInfo.isLandscape ? 600 : constraints.maxHeight,
            );
            bool _useDesktopLayout = deviceInfo.uiSizeFactor > 3;

            return GestureDetector(
              onVerticalDragStart: !_useDesktopLayout
                  ? (details) {
                      _curve = Curves.linear;
                    }
                  : null,
              onVerticalDragUpdate: !_useDesktopLayout
                  ? (details) {
                      widget.route.controller.value -=
                          details.primaryDelta / _childHeight;
                    }
                  : null,
              onVerticalDragEnd: !_useDesktopLayout
                  ? (details) {
                      _curve = SuspendedCurve(
                        widget.route.animation.value,
                        curve: decelerateEasing,
                      );

                      if (details.primaryVelocity > 350) {
                        final _animForward = widget.route.controller.status ==
                                AnimationStatus.forward ||
                            widget.route.controller.status ==
                                AnimationStatus.completed;
                        if (!_animForward)
                          widget.route.navigator?.pop();
                        else
                          widget.route.controller.fling(velocity: 1);
                      }

                      if (widget.route.controller.value > 0.5) {
                        widget.route.controller.fling(velocity: 1);
                      } else {
                        widget.route.navigator?.pop();
                      }
                    }
                  : null,
              child: AnimatedAlign(
                duration: Duration(milliseconds: 300),
                curve: decelerateEasing,
                alignment: _useDesktopLayout
                    ? Alignment.center
                    : Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: _constraints,
                  child: Builder(
                    builder: (context) {
                      final Widget commonChild = Material(
                        key: _childKey,
                        color: widget.backgroundColor,
                        shape: _useDesktopLayout
                            ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              )
                            : widget.shape,
                        elevation: widget.elevation ?? 1,
                        clipBehavior: widget.clipBehavior ?? Clip.antiAlias,
                        child: AnimatedPadding(
                          duration: Duration(milliseconds: 300),
                          curve: decelerateEasing,
                          padding: EdgeInsets.only(
                            bottom: !_useDesktopLayout
                                ? MediaQuery.of(context).padding.bottom
                                : 0,
                          ),
                          child: MediaQuery.removeViewPadding(
                            context: context,
                            removeLeft: _useDesktopLayout,
                            removeRight: _useDesktopLayout,
                            child: widget.child,
                          ),
                        ),
                      );

                      if (_useDesktopLayout) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            curve: Curves.easeOut,
                            parent: widget.route.animation,
                          ),
                          child: commonChild,
                        );
                      } else {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 1),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              curve: _curve,
                              parent: widget.route.animation,
                            ),
                          ),
                          child: commonChild,
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
