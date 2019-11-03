import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/methods.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/routes/easteregg_route.dart';
import 'package:potato_notes/ui/list_label_divider.dart';
import 'package:provider/provider.dart';

class SettingsRoute extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<SettingsRoute> {
  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  AppLocalizations locales;

  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);
    locales = AppLocalizations.of(context);

    Brightness systemBarsIconBrightness =
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark;

    changeSystemBarsColors(
        Theme.of(context).cardColor, systemBarsIconBrightness);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
              height: 60,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Center(
                        child: Text(
                          locales.settingsRoute_title,
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 70),
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                ListLabelDivider(
                  label: locales.settingsRoute_themes,
                ),
                SwitchListTile(
                  secondary: Icon(Icons.brightness_medium),
                  title: Text(locales.settingsRoute_themes_followSystem),
                  onChanged: (val) {
                    appInfo.followSystemTheme = val;
                  },
                  value: appInfo.followSystemTheme,
                  activeColor: appInfo.mainColor,
                ),
                ListTile(
                  enabled: appInfo.followSystemTheme,
                  leading: Icon(Icons.brightness_3),
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
                  leading: Icon(Icons.brightness_5),
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
                  secondary: Icon(Icons.opacity),
                  title: Text(locales.settingsRoute_themes_useCustomAccent),
                  onChanged: (val) {
                    appInfo.useCustomMainColor = val;
                  },
                  value: appInfo.useCustomMainColor,
                  activeColor: appInfo.mainColor,
                ),
                ListTile(
                  leading: Icon(Icons.color_lens),
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
                                BorderRadius.all(Radius.circular(8.0))),
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ColorPicker(
                              enableAlpha: false,
                              enableLabel: true,
                              displayThumbColor: false,
                              pickerColor: appInfo.customMainColor,
                              onColorChanged: (color) {
                                currentColor = Color(color.value);
                              },
                            )
                          ],
                        ),
                        actions: <Widget>[
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
                ListLabelDivider(
                  label: locales.settingsRoute_gestures,
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).accentColor,
                  secondary: Icon(Icons.star),
                  title: Text(locales.settingsRoute_gestures_quickStar),
                  value: appInfo.isQuickStarredGestureOn,
                  onChanged: (value) => appInfo.isQuickStarredGestureOn = value,
                ),
                ListLabelDivider(
                  label: locales.settingsRoute_backupAndRestore,
                ),
                ListTile(
                  leading: Icon(Icons.backup),
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

                      await NoteHelper()
                          .backupDatabaseToPath(databaseBackupPath);

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
                  leading: Icon(Icons.restore),
                  title: Text(locales.settingsRoute_backupAndRestore_restore),
                  onTap: () async {
                    String path = await FilePicker.getFilePath();

                    if (path != null) {
                      int status = await NoteHelper().validateDatabase(path);
                      if (status == 0) {
                        await NoteHelper().restoreDatabaseToPath(path);
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
                  title: Text(locales.settingsRoute_backupAndRestore_regenDbEntries),
                  leading: Icon(Icons.list),
                  onTap: () async {
                    await NoteHelper().recreateDB();
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(locales.done)));
                  },
                ),
                ListLabelDivider(
                  label: locales.settingsRoute_about,
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text(locales.settingsRoute_about_potatonotes),
                  onTap: () => showNoteAboutDialog(),
                ),
                ListTile(
                  leading: Icon(Icons.code),
                  title: Text(locales.settingsRoute_about_sourceCode),
                  onTap: () =>
                      launchUrl("https://github.com/HrX03/PotatoNotes"),
                ),
                ListLabelDivider(
                  label: locales.settingsRoute_dev,
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).accentColor,
                  secondary: Icon(Icons.label),
                  title: Text(locales.settingsRoute_dev_idLabels),
                  value: appInfo.devShowIdLabels,
                  onChanged: (value) => appInfo.devShowIdLabels = value,
                ),
              ],
            ),
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
                                    Theme.of(context).textTheme.title.color)
                                .withAlpha(0.5)
                                .toColor(),
                            fontSize: 14),
                      ),
                      Spacer(),
                      Text(
                        appInfo.version,
                        style: TextStyle(
                            color: HSLColor.fromColor(
                                    Theme.of(context).textTheme.title.color)
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
