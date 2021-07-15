import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

// ignore_for_file: invalid_use_of_protected_member
class BottomSheetRoute<T> extends PopupRoute<T> {
  BottomSheetRoute({
    required this.child,
    this.backgroundColor,
    this.elevation = 0,
    this.shape = const RoundedRectangleBorder(),
    this.clipBehavior = Clip.none,
    this.maintainState = true,
    this.enableDismiss = true,
    this.enableGestures = true,
  });

  final Widget child;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final bool enableDismiss;
  final bool enableGestures;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _BottomSheetBase(
      route: this,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      enableGestures: enableGestures,
      child: child,
    );
  }

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 250);

  @override
  bool get barrierDismissible => enableDismiss;

  @override
  Curve get barrierCurve => decelerateEasing;
}

class _BottomSheetBase extends StatefulWidget {
  final Widget child;
  final BottomSheetRoute route;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final bool enableGestures;

  const _BottomSheetBase({
    required this.child,
    required this.route,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.enableGestures = true,
  });

  @override
  _BottomSheetBaseState createState() => _BottomSheetBaseState();
}

class _BottomSheetBaseState extends State<_BottomSheetBase> {
  final GlobalKey _childKey = GlobalKey();
  Curve _curve = decelerateEasing;

  double get _childHeight {
    final RenderBox box =
        _childKey.currentContext!.findRenderObject()! as RenderBox;
    return box.size.height;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.route.animation!,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            const double shortestSide = 480;
            final int roundedShortestSide = (shortestSide / 10).round() * 10;

            final BoxConstraints _constraints = BoxConstraints(
              maxWidth: roundedShortestSide.toDouble(),
              maxHeight:
                  min(600.0 + context.viewInsets.bottom, context.mSize.height),
            );
            final bool _useDesktopLayout = deviceInfo.uiSizeFactor > 3;

            return GestureDetector(
              onVerticalDragStart: !_useDesktopLayout && widget.enableGestures
                  ? (details) {
                      _curve = Curves.linear;
                    }
                  : null,
              onVerticalDragUpdate: !_useDesktopLayout && widget.enableGestures
                  ? (details) {
                      widget.route.controller!.value -=
                          details.primaryDelta! / _childHeight;
                    }
                  : null,
              onVerticalDragEnd: !_useDesktopLayout && widget.enableGestures
                  ? (details) {
                      _curve = SuspendedCurve(
                        widget.route.animation!.value,
                        curve: decelerateEasing,
                      );

                      if (details.primaryVelocity! > 350) {
                        final bool _closeSheet =
                            details.velocity.pixelsPerSecond.dy > 0;
                        if (_closeSheet) {
                          widget.route.navigator?.pop();
                        } else {
                          widget.route.controller!.fling();
                        }

                        return;
                      }

                      if (widget.route.controller!.value > 0.5) {
                        widget.route.controller!.fling();
                      } else {
                        widget.route.navigator?.pop();
                      }
                    }
                  : null,
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: decelerateEasing,
                alignment: _useDesktopLayout
                    ? Alignment.center
                    : Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(
                    top: _useDesktopLayout ? 16 : 48,
                    bottom:
                        _useDesktopLayout ? context.viewInsets.bottom + 16 : 0,
                  ),
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
                          duration: const Duration(milliseconds: 300),
                          curve: decelerateEasing,
                          padding: EdgeInsets.only(
                            bottom:
                                !_useDesktopLayout ? context.padding.bottom : 0,
                          ),
                          child: MediaQuery(
                            data: context.mediaQuery.copyWith(
                              viewInsets: context.viewInsets.copyWith(
                                bottom: _useDesktopLayout
                                    ? 0
                                    : context.viewInsets.bottom,
                              ),
                            ),
                            child: MediaQuery.removePadding(
                              context: context,
                              removeLeft: _useDesktopLayout,
                              removeRight: _useDesktopLayout,
                              child: widget.child,
                            ),
                          ),
                        ),
                      );

                      if (_useDesktopLayout) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            curve: Curves.easeOut,
                            parent: widget.route.animation!,
                          ),
                          child: commonChild,
                        );
                      } else {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              curve: _curve,
                              parent: widget.route.animation!,
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
