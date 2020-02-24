import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/routes/notes_main_page_route.dart';
import 'package:potato_notes/routes/sync_login_route.dart';
import 'package:potato_notes/ui/custom_icons.dart';
import 'package:potato_notes/ui/rgb_color_picker.dart';
import 'package:provider/provider.dart';

class WelcomeRoute extends StatefulWidget {
  @override
  _WelcomeRouteState createState() => _WelcomeRouteState();
}

class _WelcomeRouteState extends State<WelcomeRoute> {
  static const int totalPages = 4;

  PageController controller = PageController();
  int currentPage = 0;

  AppInfoProvider appInfo;
  AppLocalizations locales;

  bool loginSuccess = false;

  @override
  Widget build(BuildContext context) {
    appInfo = Provider.of<AppInfoProvider>(context);
    locales = AppLocalizations.of(context);

    return SafeArea(
      top: false,
      child: Material(
        color: Theme.of(context).cardColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: controller,
                children: <Widget>[
                  Container(
                    child: firstPage(context),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                    child: secondPage(context),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                    child: appInfo.userToken != null
                        ? thirdPageSuccess(context)
                        : thirdPage(context),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                    child: fourthPage(context),
                  ),
                ],
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page;
                  });
                },
              ),
            ),
            Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      iconSize: 28,
                      icon: Icon(Icons.chevron_left),
                      tooltip: "Previous page",
                      onPressed: currentPage != 0
                          ? () => controller.previousPage(
                              curve: Curves.easeInOutCubic,
                              duration: Duration(milliseconds: 700))
                          : null,
                    ),
                    Spacer(),
                    PageIndicator(
                      page: currentPage,
                      totalPages: totalPages,
                    ),
                    Spacer(),
                    IconButton(
                      iconSize: 28,
                      icon: currentPage != (totalPages - 1)
                          ? Icon(Icons.chevron_right)
                          : Icon(Icons.done),
                      tooltip: currentPage != (totalPages - 1)
                          ? "Next page"
                          : "Exit setup",
                      onPressed: currentPage != (totalPages - 1)
                          ? () => controller.nextPage(
                              curve: Curves.easeInOutCubic,
                              duration: Duration(milliseconds: 700))
                          : () async {
                              appInfo.welcomeScreenSeen = true;
                              appInfo.notes = await NoteHelper.getNotes(
                                  appInfo.sortMode, NotesReturnMode.NORMAL);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotesMainPageRoute(),
                                  ));
                            },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget firstPage(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/notes_orange.png",
            height: 90,
          ),
          Divider(
            color: Colors.transparent,
            height: 70,
          ),
          Text(
            "PotatoNotes",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: "GoogleSans",
                fontSize: 30),
          ),
          Divider(
            color: Colors.transparent,
            height: 12,
          ),
          Text(
            locales.welcomeRoute_firstPage_catchPhrase,
            style: TextStyle(
                fontSize: 20,
                fontFamily: "GoogleSans",
                color:
                    Theme.of(context).textTheme.headline6.color.withOpacity(0.7)),
          ),
        ],
      );

  Widget secondPage(BuildContext context) => Column(
        children: <Widget>[
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              locales.welcomeRoute_secondPage_title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: "GoogleSans",
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                SwitchListTile(
                  secondary: Icon(OMIcons.brightnessMedium),
                  title: Text(locales.settingsRoute_themes_followSystem),
                  onChanged: (val) {
                    appInfo.followSystemTheme = val;
                  },
                  value: appInfo.followSystemTheme,
                  activeColor: appInfo.mainColor,
                ),
                ListTile(
                  enabled: appInfo.followSystemTheme,
                  leading: Icon(OMIcons.brightness3),
                  title: Text(locales.settingsRoute_themes_systemDarkMode),
                  trailing: DropdownButton(
                    value: appInfo.darkThemeMode,
                    underline: Container(),
                    disabledHint: appInfo.darkThemeMode == 0
                        ? Text(locales.dark)
                        : Text(locales.black),
                    items: <DropdownMenuItem>[
                      DropdownMenuItem(
                        child: Text(locales.dark),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        child: Text(locales.black),
                        value: 1,
                      ),
                    ],
                    onChanged: appInfo.followSystemTheme
                        ? (newValue) {
                            appInfo.darkThemeMode = newValue;
                          }
                        : null,
                  ),
                ),
                ListTile(
                  enabled: !appInfo.followSystemTheme,
                  leading: Icon(OMIcons.brightness5),
                  title: Text(locales.settingsRoute_themes_appTheme),
                  trailing: DropdownButton(
                    value: appInfo.themeMode,
                    disabledHint: appInfo.themeMode == 0
                        ? Text(locales.light)
                        : appInfo.themeMode == 1
                            ? Text(locales.dark)
                            : Text(locales.black),
                    underline: Container(),
                    items: <DropdownMenuItem>[
                      DropdownMenuItem(
                        child: Text(locales.light),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        child: Text(locales.dark),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text(locales.black),
                        value: 2,
                      ),
                    ],
                    onChanged: appInfo.followSystemTheme
                        ? null
                        : (newValue) {
                            appInfo.themeMode = newValue;
                          },
                  ),
                ),
                SwitchListTile(
                  secondary: Icon(OMIcons.opacity),
                  title: Text(locales.settingsRoute_themes_useCustomAccent),
                  onChanged: appInfo.supportsSystemAccent
                      ? (val) {
                          appInfo.useCustomMainColor = val;
                        }
                      : null,
                  value: appInfo.useCustomMainColor,
                  activeColor: appInfo.mainColor,
                ),
                ListTile(
                  leading: Icon(OMIcons.colorLens),
                  title: Text(locales.settingsRoute_themes_customAccentColor),
                  enabled: appInfo.useCustomMainColor,
                  trailing: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                        color: appInfo.customMainColor,
                        borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      Color currentColor = appInfo.customMainColor;
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        content: SingleChildScrollView(
                          child: RGBColorPicker(
                            initialColor: appInfo.customMainColor,
                            onColorChange: (color) {
                              currentColor = color;
                            },
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              locales.reset,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            onPressed: () {
                              appInfo.customMainColor = Color(0xFFFF9100);
                              Navigator.pop(context);
                            },
                            textColor: appInfo.mainColor,
                            hoverColor: appInfo.mainColor,
                          ),
                          FlatButton(
                            child: Text(
                              locales.cancel,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            onPressed: () => Navigator.pop(context),
                            textColor: appInfo.mainColor,
                            hoverColor: appInfo.mainColor,
                          ),
                          FlatButton(
                            child: Text(
                              locales.confirm,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            onPressed: () {
                              appInfo.customMainColor = currentColor;
                              Navigator.pop(context);
                            },
                            textColor: appInfo.mainColor,
                            hoverColor: appInfo.mainColor,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).accentColor,
                  secondary: Icon(OMIcons.starBorder),
                  title: Text(locales.settingsRoute_gestures_quickStar),
                  value: appInfo.isQuickStarredGestureOn,
                  onChanged: (value) => appInfo.isQuickStarredGestureOn = value,
                ),
                SwitchListTile(
                  secondary: Icon(OMIcons.sort),
                  title: Text(locales.userInfoRoute_sortByDate),
                  value: appInfo.sortMode == SortMode.DATE,
                  onChanged: (value) {
                    SortMode sortMode;

                    if (value) {
                      sortMode = SortMode.DATE;
                    } else {
                      sortMode = SortMode.ID;
                    }

                    appInfo.sortMode = sortMode;
                  },
                  activeColor: appInfo.mainColor,
                ),
              ],
            ),
          ),
        ],
      );

  Widget thirdPage(BuildContext context) => Column(
        children: <Widget>[
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              "PotatoSync",
              style: TextStyle(
                fontSize: 22,
                fontFamily: "GoogleSans",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Spacer(),
                Icon(
                  CustomIcons.potato_sync,
                  size: 190,
                  color: Theme.of(context).iconTheme.color.withOpacity(0.2),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    locales.welcomeRoute_thirdPage_description,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Spacer(),
                FlatButton(
                  child: Text(locales.welcomeRoute_thirdPage_getStarted),
                  textColor: Theme.of(context).cardColor,
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SyncLoginRoute()));
                  },
                ),
              ],
            ),
          ),
        ],
      );

  Widget thirdPageSuccess(BuildContext context) => Column(
        children: <Widget>[
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              "PotatoSync",
              style: TextStyle(
                fontSize: 22,
                fontFamily: "GoogleSans",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Spacer(),
                Icon(
                  OMIcons.done,
                  size: 190,
                  color: Theme.of(context).iconTheme.color.withOpacity(0.2),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    locales.welcomeRoute_thirdPage_success,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      );

  Widget fourthPage(BuildContext context) => Column(
        children: <Widget>[
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              locales.welcomeRoute_fourthPage_title,
              style: TextStyle(
                fontSize: 22,
                fontFamily: "GoogleSans",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                    locales.welcomeRoute_fourthPage_description,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    locales.welcomeRoute_fourthPage_thankyou,
                    style: TextStyle(fontSize: 18, letterSpacing: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class PageIndicator extends StatelessWidget {
  final int page;
  final int totalPages;

  PageIndicator({
    @required this.page,
    @required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Page ${page + 1} of $totalPages",
      child: Row(
        children: dots(context),
      ),
    );
  }

  List<Widget> dots(BuildContext context) {
    List<Widget> widgets = [];

    for (int i = 0; i < totalPages; i++) {
      widgets.add(Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: i == page
              ? Theme.of(context).accentColor
              : Theme.of(context).accentColor.withOpacity(0.4),
        ),
      ));

      widgets.add(VerticalDivider(
        width: 10,
      ));
    }

    widgets.removeLast();

    return widgets;
  }
}
