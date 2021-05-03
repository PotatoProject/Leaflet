import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/custom_icons.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/in_app_update.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/note_list_page.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/routes/settings_page.dart';
import 'package:potato_notes/routes/setup/setup_page.dart';
import 'package:potato_notes/widget/account_avatar.dart';
import 'package:potato_notes/widget/account_info.dart';
import 'package:potato_notes/widget/appbar_navigation.dart';
import 'package:potato_notes/widget/base_page_navigation_bar.dart';
import 'package:potato_notes/widget/constrained_width_appbar.dart';
import 'package:potato_notes/widget/default_app_bar.dart';
import 'package:potato_notes/widget/drawer_list.dart';
import 'package:potato_notes/widget/drawer_list_tile.dart';
import 'package:potato_notes/widget/illustrations.dart';
import 'package:potato_notes/widget/note_search_delegate.dart';

class BasePage extends StatefulWidget {
  static BasePageState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BasePageInheritedWidget>()!
        .state;
  }

  static BasePageState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BasePageInheritedWidget>()
        ?.state;
  }

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState extends State<BasePage>
    with SingleTickerProviderStateMixin {
  static const double _drawerClosedWidth = 72.0;
  static const double _drawerOpenedWidth = 300.0;

  final PageStorageBucket _bucket = PageStorageBucket();
  final List<Widget> _pages = [
    NoteListPage(
      key: const PageStorageKey(ReturnMode.normal),
      noteKind: ReturnMode.normal,
      selectionOptions: Utils.getSelectionOptionsForMode(ReturnMode.normal),
    ),
    NoteListPage(
      key: const PageStorageKey(ReturnMode.archive),
      noteKind: ReturnMode.archive,
      selectionOptions: Utils.getSelectionOptionsForMode(ReturnMode.archive),
    ),
    SearchPage(
      key: const PageStorageKey('search'),
      delegate: NoteSearchDelegate(),
    ),
    NoteListPage(
      key: const PageStorageKey(ReturnMode.trash),
      noteKind: ReturnMode.trash,
      selectionOptions: Utils.getSelectionOptionsForMode(ReturnMode.trash),
    ),
    const SettingsPage(key: PageStorageKey('settings')),
  ];

  int _currentPage = 0;
  bool _bottomBarEnabled = true;
  Widget? _floatingActionButton;
  Widget? _appBar;
  Widget? _secondaryAppBar;
  late AnimationController _ac;
  DefaultDrawerMode _defaultDrawerMode = DefaultDrawerMode.collapsed;
  bool _collapsedDrawer = false;

  Widget? get fab => _floatingActionButton;
  Widget? get appBar => _appBar;
  Widget? get secondaryAppBar => _secondaryAppBar;

  void setCurrentPage(int newPage) {
    if (_defaultDrawerMode == DefaultDrawerMode.collapsed) {
      _collapsedDrawer = true;
    }
    _currentPage = newPage;
    setState(() {});
  }

  void setBottomBarEnabled(bool enabled) {
    setState(() => _bottomBarEnabled = enabled);
  }

  void setFAB(Widget? fab) {
    _floatingActionButton = fab;
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
  }

  void setAppBar(Widget? appBar) {
    _appBar = appBar;
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> setSecondaryAppBar(Widget? secondaryAppBar) async {
    if (secondaryAppBar.runtimeType != _secondaryAppBar.runtimeType) {
      if (secondaryAppBar is DefaultAppBar || secondaryAppBar == null) {
        await _ac.animateBack(0);
      } else {
        if (_ac.value == 0) {
          _ac.animateTo(1);
        }
      }
    }
    _secondaryAppBar = secondaryAppBar != null
        ? KeyedSubtree(
            key: ValueKey(secondaryAppBar.runtimeType),
            child: secondaryAppBar,
          )
        : null;

    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
  }

  void hideCurrentSnackBar() => context.scaffoldMessenger.hideCurrentSnackBar();
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackBar,
  ) =>
      context.scaffoldMessenger.showSnackBar(snackBar);

  List<BottomNavigationBarItem> get _items => [
        const BottomNavigationBarItem(
          icon: Icon(CustomIcons.notes),
          label: "Notes",
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.inventory_2_outlined),
          label: LocaleStrings.mainPage.titleArchive,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search_outlined),
          label: LocaleStrings.mainPage.search,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.delete_outlined),
          label: LocaleStrings.mainPage.titleTrash,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CustomIcons.settings_outline),
          label: LocaleStrings.mainPage.settings,
        ),
      ];

  @override
  void initState() {
    if (!DeviceInfo.isDesktopOrWeb) {
      appInfo.quickActions?.initialize((shortcutType) async {
        switch (shortcutType) {
          case 'new_text':
            Utils.newNote(context);
            break;
          case 'new_image':
            Utils.newImage(context, ImageSource.gallery);
            break;
          case 'new_drawing':
            Utils.newDrawing(context);
            break;
          case 'new_list':
            Utils.newList(context);
            break;
        }
      });
    }

    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 75),
    );

    InAppUpdater.checkForUpdate(context);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (!prefs.welcomePageSeen) {
        Utils.showSecondaryRoute(
          context,
          SetupPage(),
          allowGestures: false,
          pushImmediate: true,
        );
      }
    });

    reaction(
      (_) => deviceInfo.uiSizeFactor,
      (msg) {
        _updateDrawer();
        setState(() {});
      },
    );

    _updateDrawer();
    super.initState();
  }

  void _updateDrawer() {
    if (deviceInfo.uiSizeFactor > 5) {
      _collapsedDrawer = false;
      _defaultDrawerMode = DefaultDrawerMode.expanded;
    } else {
      _collapsedDrawer = true;
      _defaultDrawerMode = DefaultDrawerMode.collapsed;
    }
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final bool useDesktopLayout =
            deviceInfo.isLandscape || deviceInfo.uiSizeFactor > 3;
        final bool useDynamicDrawer = deviceInfo.uiSizeFactor > 3;

        return BasePageInheritedWidget(
          state: this,
          child: Material(
            color: context.theme.scaffoldBackgroundColor,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedPadding(
                    padding: EdgeInsetsDirectional.only(
                      start: useDynamicDrawer
                          ? (_defaultDrawerMode == DefaultDrawerMode.expanded
                                  ? _collapsedDrawer
                                      ? _drawerClosedWidth
                                      : _drawerOpenedWidth
                                  : _drawerClosedWidth) +
                              context.viewPaddingDirectional.start
                          : 0,
                    ),
                    duration: const Duration(milliseconds: 200),
                    curve: decelerateEasing,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: ConstrainedWidthAppbar(
                        width: 1920,
                        child: !useDynamicDrawer
                            ? !deviceInfo.isLandscape
                                ? _appBar
                                : DefaultAppBar(
                                    extraActions: [
                                      AppbarNavigation(
                                        items: _items,
                                        index: _currentPage,
                                        enabled: _bottomBarEnabled,
                                        onPageChanged: setCurrentPage,
                                      ),
                                    ],
                                  )
                            : null,
                      ),
                      extendBody: useDesktopLayout,
                      extendBodyBehindAppBar: true,
                      body: PageTransitionSwitcher(
                        transitionBuilder: (
                          child,
                          primaryAnimation,
                          secondaryAnimation,
                        ) =>
                            FadeThroughTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          fillColor: Colors.transparent,
                          child: MediaQuery(
                            data: context.mediaQuery.copyWith(
                              padding: context.padding.copyWith(
                                top: useDynamicDrawer
                                    ? context.padding.top
                                    : context.padding.top + 56,
                              ),
                              viewPadding: useDynamicDrawer
                                  ? EdgeInsetsDirectional.only(
                                      top: context.viewPaddingDirectional.top,
                                      bottom:
                                          context.viewPaddingDirectional.bottom,
                                      end: context.viewPaddingDirectional.end,
                                    ).resolve(context.directionality)
                                  : null,
                            ),
                            child: PageStorage(
                              bucket: _bucket,
                              child: child,
                            ),
                          ),
                        ),
                        child: _pages.get(_currentPage),
                      ),
                      resizeToAvoidBottomInset: false,
                      bottomNavigationBar: !useDesktopLayout
                          ? BasePageNavigationBar(
                              items: _items,
                              index: _currentPage,
                              enabled: _bottomBarEnabled,
                              onPageChanged: setCurrentPage,
                            )
                          : _SecondaryAppBar(
                              animationController: _ac,
                              child: _secondaryAppBar,
                            ),
                      floatingActionButton:
                          !useDesktopLayout ? _floatingActionButton : null,
                    ),
                  ),
                ),
                Visibility(
                  visible: _defaultDrawerMode == DefaultDrawerMode.collapsed,
                  child: IgnorePointer(
                    ignoring: _collapsedDrawer,
                    child: GestureDetector(
                      onTap: () => setState(() => _collapsedDrawer = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: decelerateEasing,
                        color: _collapsedDrawer
                            ? Colors.transparent
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: useDynamicDrawer,
                  child: Material(
                    elevation: 12,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: decelerateEasing,
                      width: _collapsedDrawer
                          ? _drawerClosedWidth
                          : _drawerOpenedWidth,
                      margin: EdgeInsetsDirectional.only(
                          start: context.viewPaddingDirectional.start),
                      child: DrawerList(
                        items: _items,
                        currentIndex: _currentPage,
                        onTap: setCurrentPage,
                        showTitles: !_collapsedDrawer,
                        enabled: _bottomBarEnabled,
                        header: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: DrawerListTile(
                                icon: const Illustration.leaflet(height: 32),
                                title: const Text(
                                  "leaflet",
                                  style: TextStyle(
                                    fontFamily: "ValeraRound",
                                    fontSize: 22,
                                  ),
                                ),
                                showTitle: !_collapsedDrawer,
                              ),
                            ),
                            if (AppInfo.supportsNotesApi)
                              DrawerListTile(
                                icon: const AccountAvatar(),
                                title: Text(
                                  prefs.accessToken != null
                                      ? prefs.username ?? "Guest"
                                      : LocaleStrings.mainPage.account,
                                ),
                                onTap: () {
                                  Utils.showModalBottomSheet(
                                    context: context,
                                    builder: (context) => AccountInfo(),
                                  );
                                },
                                showTitle: !_collapsedDrawer,
                              ),
                          ],
                        ),
                        footer: DrawerListTile(
                          icon: Icon(
                            _collapsedDrawer
                                ? Icons.chevron_right
                                : Icons.chevron_left,
                          ),
                          title: Text(
                            _collapsedDrawer ? "Expand" : "Collapse",
                          ),
                          onTap: () => setState(
                              () => _collapsedDrawer = !_collapsedDrawer),
                          showTitle: !_collapsedDrawer,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BasePageInheritedWidget extends InheritedWidget {
  const BasePageInheritedWidget({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  final BasePageState state;

  @override
  bool updateShouldNotify(BasePageInheritedWidget oldWidget) {
    return oldWidget.state != state;
  }
}

enum DefaultDrawerMode {
  collapsed,
  expanded,
}

class _SecondaryAppBar extends StatelessWidget {
  final AnimationController animationController;
  final Widget? child;

  const _SecondaryAppBar({
    required this.animationController,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        end: context.viewPaddingDirectional.end,
      ),
      child: MediaQuery.removeViewPadding(
        context: context,
        removeLeft: true,
        removeRight: true,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: context.viewInsets.bottom,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animationController,
                curve: accelerateEasing,
                reverseCurve: decelerateEasing,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
              ),
              child: ConstrainedWidthAppbar(
                width: min(640, context.mSize.width - 32),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: context.theme.cardColor,
                  clipBehavior: Clip.antiAlias,
                  elevation: 8,
                  child: SizedBox(
                    height: 48,
                    child: Theme(
                      data: context.theme.copyWith(
                        appBarTheme: context.theme.appBarTheme.copyWith(
                          color: context.theme.cardColor,
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        switchInCurve: decelerateEasing,
                        switchOutCurve: decelerateEasing,
                        child: child ?? Container(),
                      ),
                    ),
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
