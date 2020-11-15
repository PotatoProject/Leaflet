import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/routes/base_page.dart';
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
    final state = BasePage.of(context);

    if (state != null) {
      BasePage.of(context).setFAB(floatingActionButton);
      BasePage.of(context).setAppBar(appBar);

      if (secondaryAppBar != null) {
        if (!(secondaryAppBar is DefaultAppBar)) {
          BasePage.of(context).setSecondaryAppBar(secondaryAppBar);
        } else {
          BasePage.of(context).setSecondaryAppBar(null);
        }
      } else if (useAppBarAsSecondary && appBar != null) {
        if (!(appBar is DefaultAppBar)) {
          BasePage.of(context).setSecondaryAppBar(appBar);
        } else {
          BasePage.of(context).setSecondaryAppBar(null);
        }
      } else {
        BasePage.of(context).setSecondaryAppBar(null);
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
