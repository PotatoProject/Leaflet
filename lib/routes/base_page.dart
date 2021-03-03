import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/custom_icons.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/in_app_update.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/sync/image/files_controller.dart';
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
        .dependOnInheritedWidgetOfExactType<BasePageInheritedWidget>()
        ?.state;
  }

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState extends State<BasePage>
    with SingleTickerProviderStateMixin {
  static const double drawerClosedWidth = 72.0;
  static const double drawerOpenedWidth = 300.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageStorageBucket _bucket = PageStorageBucket();
  final List<Widget> _pages = [
    NoteListPage(
      key: PageStorageKey(ReturnMode.NORMAL),
      noteKind: ReturnMode.NORMAL,
      selectionOptions: Utils.getSelectionOptionsForMode(ReturnMode.NORMAL),
    ),
    NoteListPage(
      key: PageStorageKey(ReturnMode.ARCHIVE),
      noteKind: ReturnMode.ARCHIVE,
      selectionOptions: Utils.getSelectionOptionsForMode(ReturnMode.ARCHIVE),
    ),
    SearchPage(
      key: PageStorageKey('search'),
      delegate: NoteSearchDelegate(),
    ),
    NoteListPage(
      key: PageStorageKey(ReturnMode.TRASH),
      noteKind: ReturnMode.TRASH,
      selectionOptions: Utils.getSelectionOptionsForMode(ReturnMode.TRASH),
    ),
    SettingsPage(key: PageStorageKey('settings')),
  ];

  int _currentPage = 0;
  bool _bottomBarEnabled = true;
  Widget _floatingActionButton;
  Widget _appBar;
  Widget _secondaryAppBar;
  AnimationController _ac;
  DefaultDrawerMode _defaultDrawerMode = DefaultDrawerMode.COLLAPSED;
  bool _collapsedDrawer = false;

  Widget get fab => _floatingActionButton;
  Widget get appBar => _appBar;
  Widget get secondaryAppBar => _secondaryAppBar;

  void setCurrentPage(int newPage) {
    if (_defaultDrawerMode == DefaultDrawerMode.COLLAPSED) {
      _collapsedDrawer = true;
    }
    _currentPage = newPage;
    setState(() {});
  }

  void setBottomBarEnabled(bool enabled) {
    setState(() => _bottomBarEnabled = enabled);
  }

  void setFAB(Widget fab) {
    _floatingActionButton = fab;
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void setAppBar(Widget appBar) {
    _appBar = appBar;
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void setSecondaryAppBar(Widget secondaryAppBar) async {
    if (secondaryAppBar.runtimeType != _secondaryAppBar.runtimeType) {
      if (secondaryAppBar is DefaultAppBar || secondaryAppBar == null)
        await _ac.animateBack(0);
      else {
        await _ac.animateBack(0);
        _ac.animateTo(1);
      }
    }
    _secondaryAppBar = secondaryAppBar;

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void hideCurrentSnackBar() => context.scaffoldMessenger.hideCurrentSnackBar();
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackBar,
  ) =>
      context.scaffoldMessenger.showSnackBar(snackBar);

  List<BottomNavigationBarItem> get _items => [
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.notes),
          label: "Notes",
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.archiveOutline),
          label: LocaleStrings.mainPage.titleArchive,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: LocaleStrings.mainPage.search,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.delete_outlined),
          label: LocaleStrings.mainPage.titleTrash,
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.settings_outline),
          label: LocaleStrings.mainPage.settings,
        ),
      ];

  @override
  void initState() {
    if (!DeviceInfo.isDesktop) {
      appInfo.quickActions.initialize((shortcutType) async {
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
      duration: Duration(milliseconds: 150),
    );

    InAppUpdater.checkForUpdate(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!prefs.welcomePageSeen) {
        Utils.showSecondaryRoute(
          context,
          SetupPage(),
          allowGestures: false,
          pushImmediate: true,
        );
      }

      await FilesController.getStats();
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
      _defaultDrawerMode = DefaultDrawerMode.EXPANDED;
    } else {
      _collapsedDrawer = true;
      _defaultDrawerMode = DefaultDrawerMode.COLLAPSED;
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
                          ? _defaultDrawerMode == DefaultDrawerMode.EXPANDED
                              ? _collapsedDrawer
                                  ? drawerClosedWidth
                                  : drawerOpenedWidth
                              : drawerClosedWidth
                          : 0,
                    ),
                    duration: Duration(milliseconds: 200),
                    curve: decelerateEasing,
                    child: Scaffold(
                      key: _scaffoldKey,
                      backgroundColor: Colors.transparent,
                      appBar: ConstrainedWidthAppbar(
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
                        width: 1920,
                      ),
                      extendBody: useDesktopLayout,
                      extendBodyBehindAppBar: true,
                      body: PageTransitionSwitcher(
                        child: _pages.get(_currentPage),
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
                            ),
                            child: PageStorage(
                              bucket: _bucket,
                              child: child,
                            ),
                          ),
                        ),
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
                  visible: _defaultDrawerMode == DefaultDrawerMode.COLLAPSED,
                  child: IgnorePointer(
                    ignoring: _collapsedDrawer,
                    child: GestureDetector(
                      onTap: () => setState(() => _collapsedDrawer = true),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
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
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: decelerateEasing,
                    width: _collapsedDrawer
                        ? drawerClosedWidth
                        : drawerOpenedWidth,
                    child: Material(
                      elevation: 12,
                      child: DrawerList(
                        items: _items,
                        currentIndex: _currentPage,
                        onTap: setCurrentPage,
                        showTitles: !_collapsedDrawer,
                        enabled: _bottomBarEnabled,
                        header: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: DrawerListTile(
                                icon: Illustration.leaflet(
                                  height: 32,
                                ),
                                title: Text(
                                  "leaflet",
                                  style: TextStyle(
                                    fontFamily: "ValeraRound",
                                    fontSize: 22,
                                  ),
                                ),
                                showTitle: !_collapsedDrawer,
                              ),
                            ),
                            DrawerListTile(
                              icon: AccountAvatar(),
                              title: Text(
                                prefs.accessToken != null
                                    ? prefs.username ?? "Guest"
                                    : LocaleStrings.mainPage.account,
                              ),
                              onTap: () {
                                Utils.showNotesModalBottomSheet(
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
  BasePageInheritedWidget({
    Key key,
    Widget child,
    this.state,
  }) : super(key: key, child: child);

  final BasePageState state;

  @override
  bool updateShouldNotify(BasePageInheritedWidget oldWidget) {
    return oldWidget.state != state;
  }
}

enum DefaultDrawerMode {
  COLLAPSED,
  EXPANDED,
}

class _SecondaryAppBar extends StatelessWidget {
  final AnimationController animationController;
  final Widget child;

  _SecondaryAppBar({
    @required this.animationController,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: context.viewInsets.bottom,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: accelerateEasing,
            reverseCurve: decelerateEasing,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 16,
            bottom: 16,
          ),
          child: ConstrainedWidthAppbar(
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              color: context.theme.cardColor,
              child: SizedBox(
                height: 48,
                child: Theme(
                  data: context.theme.copyWith(
                    appBarTheme: context.theme.appBarTheme.copyWith(
                      color: context.theme.cardColor,
                    ),
                  ),
                  child: child ?? Container(),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 8,
            ),
            width: min(640, context.mSize.width - 32),
          ),
        ),
      ),
    );
  }
}
