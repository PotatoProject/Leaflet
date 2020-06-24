import 'package:flutter/material.dart';

class DismissiblePageRoute extends PageRoute {
  DismissiblePageRoute({
    @required this.builder,
  });

  final WidgetBuilder builder;

  @override
  final bool maintainState = true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => SlideTransition(
        child: DismissibleRoute(
          child: builder(context),
          maxWidth: MediaQuery.of(context).size.width,
        ),
        position: animation
            .drive(
              CurveTween(
                  curve: animation.status == AnimationStatus.reverse
                      ? Curves.ease
                      : Curves.easeOut),
            )
            .drive(
              Tween<Offset>(
                begin: Offset(1, 0),
                end: Offset(0, 0),
              ),
            ),
      ),
    );
  }
}

class DismissibleRoute extends StatefulWidget {
  final Widget child;
  final double maxWidth;

  DismissibleRoute({
    @required this.child,
    @required this.maxWidth,
  });

  @override
  _DismissibleRouteState createState() {
    return _DismissibleRouteState();
  }
}

class _DismissibleRouteState extends State<DismissibleRoute>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      value: 1,
      duration: Duration(milliseconds: 350),
      reverseDuration: Duration(milliseconds: 350),
    );

    //controller.animateTo(1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void close() async {
    await controller.animateBack(0);
    Navigator.pop(context);
  }

  @override
  void didChangeDependencies() {
    context.dependOnInheritedWidgetOfExactType();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Animation<Offset> offset = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
        reverseCurve: Curves.ease,
      ),
    );

    return SafeArea(
      top: false,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) {
          controller.value -= details.primaryDelta / widget.maxWidth;
        },
        onHorizontalDragEnd: (details) async {
          if (details.primaryVelocity > 345) {
            await controller.animateBack(0);
            Navigator.pop(context);
          } else {
            if (controller.value < 0.5) {
              await controller.animateBack(0);
              Navigator.pop(context);
            } else {
              await controller.animateTo(1);
            }
          }
        },
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: [
                SizedBox.expand(
                  child: FadeTransition(
                    opacity:
                        Tween<double>(begin: 0, end: 1).animate(controller),
                    child: Container(color: Colors.black54),
                  ),
                ),
                SlideTransition(
                  position: offset,
                  child: Material(
                    elevation: 16,
                    child: SizedBox(
                      width: widget.maxWidth,
                      height: MediaQuery.of(context).size.height,
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
