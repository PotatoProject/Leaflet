import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/default_app_bar.dart';

class DependentScaffold extends StatelessWidget {
  const DependentScaffold({
    Key key,
    this.appBar = const DefaultAppBar(),
    this.secondaryAppBar,
    this.useAppBarAsSecondary = false,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
  })  : assert(primary != null),
        assert(extendBody != null),
        assert(extendBodyBehindAppBar != null),
        assert(drawerDragStartBehavior != null),
        super(key: key);

  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget appBar;
  final Widget secondaryAppBar;
  final bool useAppBarAsSecondary;
  final Widget body;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final List<Widget> persistentFooterButtons;
  final Widget drawer;
  final Widget endDrawer;
  final Color drawerScrimColor;
  final Color backgroundColor;
  final Widget bottomNavigationBar;
  final Widget bottomSheet;
  final bool resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final double drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;

  @override
  Widget build(BuildContext context) {
    final state = context.basePage;

    if (state != null) {
      context.basePage.setFAB(floatingActionButton);
      context.basePage.setAppBar(appBar);

      if (secondaryAppBar != null) {
        if (!(secondaryAppBar is DefaultAppBar)) {
          context.basePage.setSecondaryAppBar(secondaryAppBar);
        } else {
          context.basePage.setSecondaryAppBar(null);
        }
      } else if (useAppBarAsSecondary && appBar != null) {
        if (!(appBar is DefaultAppBar)) {
          context.basePage.setSecondaryAppBar(appBar);
        } else {
          context.basePage.setSecondaryAppBar(null);
        }
      } else {
        context.basePage.setSecondaryAppBar(null);
      }
    }

    return ScaffoldMessenger(
      child: Scaffold(
        appBar: state == null ? appBar : null,
        floatingActionButton: state == null ? floatingActionButton : null,
        body: body,
        persistentFooterButtons: persistentFooterButtons,
        drawer: drawer,
        endDrawer: endDrawer,
        drawerScrimColor: drawerScrimColor,
        backgroundColor: state != null ? Colors.transparent : backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        primary: primary,
        drawerDragStartBehavior: drawerDragStartBehavior,
        drawerEdgeDragWidth: drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
        extendBodyBehindAppBar: true,
      ),
    );
  }
}
