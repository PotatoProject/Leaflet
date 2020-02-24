import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/easteregg_route.dart';
import 'package:potato_notes/ui/list_label_divider.dart';
import 'package:potato_notes/ui/rgb_color_picker.dart';
import 'package:provider/provider.dart';

class SettingsRoute extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<SettingsRoute> {
  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  AppLocalizations locales;

  bool showLoadingOverlay = false;

  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);
    locales = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, bottom: 60),
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                ListLabelDivider(
                  label: locales.settingsRoute_themes,
                ),
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
                ListTile(
                  leading: Icon(OMIcons.language),
                  title: Text("App language"),
                  trailing: DropdownButton(
                    value: appInfo.customLocale,
                    underline: Container(),
                    items: List.generate(AppInfoProvider.supportedLocales.length + 1, (index) {
                      return DropdownMenuItem(
                        child: Text(
                          index == 0
                              ? "System"
                              : Locale(AppInfoProvider.supportedLocales[index - 1]).toLanguageTag()
                        ),
                        value: index - 1,
                      );
                    }),
                    onChanged: (newLocale) => appInfo.customLocale = newLocale,
                  ),
                ),
                ListLabelDivider(
                  label: locales.settingsRoute_gestures,
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).accentColor,
                  secondary: Icon(OMIcons.starBorder),
                  title: Text(locales.settingsRoute_gestures_quickStar),
                  value: appInfo.isQuickStarredGestureOn,
                  onChanged: (value) => appInfo.isQuickStarredGestureOn = value,
                ),
                ListLabelDivider(
                  label: locales.settingsRoute_backupAndRestore,
                ),
                ListTile(
                  leading: Icon(OMIcons.backup),
                  title: Text(locales.settingsRoute_backupAndRestore_backup),
                  onTap: () async {
                    if (appInfo.storageStatus == PermissionStatus.granted) {
                      DateTime now = DateTime.now();

                      bool backupDirExists = await Directory(
                              '/storage/emulated/0/PotatoNotes/backups')
                          .exists();

                      if (!backupDirExists) {
                        await Directory(
                                '/storage/emulated/0/PotatoNotes/backups')
                            .create(recursive: true);
                      }

                      String databaseBackupPath =
                          '/storage/emulated/0/PotatoNotes/backups/notes_backup_' +
                              DateFormat("HH-mm_dd-MM-yyyy").format(now) +
                              '.db';

                      await NoteHelper.backupDatabaseToPath(databaseBackupPath);

                      scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(locales
                              .settingsRoute_backupAndRestore_backup_done(
                                  databaseBackupPath))));
                    } else {
                      await PermissionHandler()
                          .requestPermissions([PermissionGroup.storage]);
                      appInfo.storageStatus = await PermissionHandler()
                          .checkPermissionStatus(PermissionGroup.storage);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(OMIcons.restore),
                  title: Text(locales.settingsRoute_backupAndRestore_restore),
                  onTap: () async {
                    String path = await FilePicker.getFilePath();

                    if (path != null) {
                      int status = await NoteHelper.validateDatabase(path);

                      if (status == 0) {
                        await NoteHelper.restoreDatabaseToPath(path);

                        if (appInfo.userToken != null) {
                          setState(() => showLoadingOverlay = true);

                          List<Note> list = appInfo.notes;

                          await post(
                              "https://sync.potatoproject.co/api/notes/deleteall",
                              headers: {"Authorization": appInfo.userToken});

                          for (int i = 0; i < list.length; i++) {
                            await OnlineNoteHelper.save(list[i]);
                          }

                          setState(() => showLoadingOverlay = false);
                        }

                        scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(locales
                                .settingsRoute_backupAndRestore_restore_success)));
                      } else {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(locales
                                .settingsRoute_backupAndRestore_restore_fail)));
                      }
                    }
                  },
                ),
                ListTile(
                  title: Text(
                      locales.settingsRoute_backupAndRestore_regenDbEntries),
                  leading: Icon(OMIcons.list),
                  onTap: () async {
                    await NoteHelper.recreateDB();
                    scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text(locales.done)));
                  },
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
                ListLabelDivider(
                  label: locales.settingsRoute_about,
                ),
                ListTile(
                  leading: Icon(OMIcons.info),
                  title: Text(locales.settingsRoute_about_potatonotes),
                  onTap: () => showNoteAboutDialog(),
                ),
                ListTile(
                  leading: Icon(OMIcons.code),
                  title: Text(locales.settingsRoute_about_sourceCode),
                  onTap: () =>
                      Utils.launchUrl("https://github.com/HrX03/PotatoNotes"),
                ),
                ListLabelDivider(
                  label: locales.settingsRoute_dev,
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).accentColor,
                  secondary: Icon(OMIcons.label),
                  title: Text(locales.settingsRoute_dev_idLabels),
                  value: appInfo.devShowIdLabels,
                  onChanged: (value) => appInfo.devShowIdLabels = value,
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).accentColor,
                  secondary: Icon(OMIcons.removeRedEye),
                  title: Text("Show welcome screen on next startup"),
                  value: !appInfo.welcomeScreenSeen,
                  onChanged: (value) => appInfo.welcomeScreenSeen = !value,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        tooltip: "Back",
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: showLoadingOverlay,
            child: SizedBox.expand(
                child: AnimatedOpacity(
              opacity: showLoadingOverlay ? 1 : 0,
              duration: Duration(milliseconds: 300),
              child: Container(
                color: Colors.black45,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  void showNoteAboutDialog() {
    final appInfo = Provider.of<AppInfoProvider>(context);
    int easterEggCounter = 0;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            contentPadding: EdgeInsets.fromLTRB(8, 24, 8, 10),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(80)),
                    onTap: () {
                      if (easterEggCounter == 9) {
                        easterEggCounter = 0;
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EasterEggRoute()));
                      } else
                        easterEggCounter++;
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: new BoxDecoration(
                        color: Color(0xFFFF9800),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image(
                          image: AssetImage('assets/notes_round.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "PotatoNotes",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 24, right: 24),
                  child:
                      Text(locales.settingsRoute_about_potatonotes_development),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 24, right: 24),
                  child: Text(locales.settingsRoute_about_potatonotes_design),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 30, 24, 4),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "PotatoProject 2019",
                        style: TextStyle(
                            color: HSLColor.fromColor(
                                    Theme.of(context).textTheme.headline6.color)
                                .withAlpha(0.5)
                                .toColor(),
                            fontSize: 14),
                      ),
                      Spacer(),
                      Text(
                        appInfo.version,
                        style: TextStyle(
                            color: HSLColor.fromColor(
                                    Theme.of(context).textTheme.headline6.color)
                                .withAlpha(0.5)
                                .toColor(),
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Close"),
                      onPressed: () => Navigator.pop(context),
                      textColor: appInfo.mainColor,
                      hoverColor: appInfo.mainColor,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
