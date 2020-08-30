import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/custom_icons.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/in_app_update.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/shared_prefs.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/note_list_page.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/routes/settings_page.dart';
import 'package:potato_notes/routes/setup/setup_page.dart';
import 'package:potato_notes/widget/base_page_navigation_bar.dart';
import 'package:potato_notes/widget/note_search_delegate.dart';

class BasePage extends StatefulWidget {
  static _BasePageState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BasePageInheritedWidget>()
        ?.state;
  }

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final _pages = [
    NoteListPage(
      key: ValueKey(ReturnMode.NORMAL),
      noteKind: ReturnMode.NORMAL,
    ),
    SearchPage(
      delegate: NoteSearchDelegate(),
    ),
    NoteListPage(
      key: ValueKey(ReturnMode.ARCHIVE),
      noteKind: ReturnMode.ARCHIVE,
    ),
    NoteListPage(
      key: ValueKey(ReturnMode.TRASH),
      noteKind: ReturnMode.TRASH,
    ),
    SettingsPage(),
  ];

  int _currentPage = 0;
  bool _bottomBarEnabled = true;
  Widget _floatingActionButton;
  Widget _appBar;

  Widget get fab => _floatingActionButton;
  Widget get appBar => _appBar;

  void setCurrentPage(int newPage) => setState(() => _currentPage = newPage);
  void setBottomBarEnabled(bool enabled) =>
      setState(() => _bottomBarEnabled = enabled);
  void setFAB(Widget fab) => WidgetsBinding.instance.addPostFrameCallback(
        (_) => setState(() => _floatingActionButton = fab),
      );
  void setAppBar(Widget appBar) => WidgetsBinding.instance.addPostFrameCallback(
        (_) => setState(() => _appBar = appBar),
      );

  @override
  void initState() {
    if (!DeviceInfo.isDesktopOrWeb) {
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

    InAppUpdater.checkForUpdate(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // unfortunately we gotta init sharedPrefs here manually cuz normal preferences aren't ready at this point
      final sharedPrefs = await SharedPrefs.newInstance();

      bool welcomePageSeenV2 = await sharedPrefs.getWelcomePageSeen();
      if (!welcomePageSeenV2) {
        Utils.showSecondaryRoute(
          context,
          SetupPage(),
          allowGestures: false,
          barrierDismissible: false,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      }
    });
    deviceInfo.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool showNavigationRail =
        deviceInfo.isLandscape || deviceInfo.uiSizeFactor > 3;
    return BasePageInheritedWidget(
      state: this,
      child: Row(
        children: [
          showNavigationRail ? getNavbar(true) : Container(),
          showNavigationRail
              ? VerticalDivider(
                  width: 1,
                  color: Theme.of(context).iconTheme.color.withOpacity(0.1),
                )
              : Container(),
          Expanded(
            child: Scaffold(
              appBar: _appBar,
              extendBodyBehindAppBar: true,
              body: PageTransitionSwitcher(
                child: _pages.get(_currentPage),
                transitionBuilder:
                    (child, primaryAnimation, secondaryAnimation) {
                  return FadeThroughTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    fillColor: Colors.transparent,
                    child: child,
                  );
                },
              ),
              bottomNavigationBar: !showNavigationRail ? getNavbar() : null,
              floatingActionButton: _floatingActionButton,
            ),
          ),
        ],
      ),
    );
  }

  Widget getNavbar([bool vertical = false]) {
    return BasePageNavigationBar(
      axis: vertical ? Axis.vertical : Axis.horizontal,
      items: [
        AdaptiveNavigationDestination(
          icon: Icon(CustomIcons.notes),
          label: Text("Notes"),
        ),
        AdaptiveNavigationDestination(
          icon: Icon(Icons.search_outlined),
          label: Text(LocaleStrings.mainPage.search),
        ),
        AdaptiveNavigationDestination(
          icon: Icon(MdiIcons.archiveOutline),
          label: Text(LocaleStrings.mainPage.titleArchive),
        ),
        AdaptiveNavigationDestination(
          icon: Icon(Icons.delete_outlined),
          label: Text(LocaleStrings.mainPage.titleTrash),
        ),
        AdaptiveNavigationDestination(
          icon: Icon(CustomIcons.settings_outline),
          label: Text(LocaleStrings.mainPage.settings),
        ),
      ],
      index: _currentPage,
      enabled: _bottomBarEnabled,
      onPageChanged: setCurrentPage,
    );
  }
}

class BasePageInheritedWidget extends InheritedWidget {
  BasePageInheritedWidget({
    Key key,
    Widget child,
    this.state,
  }) : super(key: key, child: child);

  final _BasePageState state;

  @override
  bool updateShouldNotify(BasePageInheritedWidget oldWidget) {
    return oldWidget.state != state;
  }
}

extension SafeGetList<T> on List<T> {
  T get(int index) {
    if (index >= length) {
      return last;
    } else
      return this[index];
  }
}
