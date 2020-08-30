import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loggy/loggy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/sync/note_controller.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/in_app_update.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/migration_task.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/about_page.dart';
import 'package:potato_notes/widget/dependent_scaffold.dart';
import 'package:potato_notes/widget/pass_challenge.dart';
import 'package:potato_notes/widget/rgb_color_picker.dart';
import 'package:potato_notes/widget/settings_category.dart';
import 'package:potato_notes/widget/settings_tile.dart';
import 'package:potato_notes/widget/sync_url_editor.dart';

class SettingsPage extends StatefulWidget {
  final bool trimmed;

  SettingsPage({
    this.trimmed = false,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool removingMasterPass = false;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (widget.trimmed) return commonSettings;

        return WillPopScope(
          onWillPop: () async => !removingMasterPass,
          child: DependentScaffold(
            body: ListView(
              children: [
                commonSettings,
                SettingsCategory(
                  header: LocaleStrings.settingsPage.infoTitle,
                  children: <Widget>[
                    SettingsTile(
                      icon: Icon(MdiIcons.informationOutline),
                      title: Text(LocaleStrings.settingsPage.infoAboutApp),
                      onTap: () => Utils.showSecondaryRoute(
                        context,
                        AboutPage(),
                        sidePadding: kTertiaryRoutePadding,
                      ),
                    ),
                    SettingsTile(
                      icon: Icon(MdiIcons.update),
                      title: Text("Check for app updates"),
                      onTap: () => InAppUpdater.checkForUpdate(
                        context,
                        showNoUpdatesAvailable: true,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: kDebugMode,
                  child: SettingsCategory(
                    header: LocaleStrings.settingsPage.debugTitle,
                    children: [
                      SettingsTile.withSwitch(
                        icon: Icon(MdiIcons.humanGreeting),
                        title: Text(
                          LocaleStrings.settingsPage.debugShowSetupScreen,
                        ),
                        value: !prefs.welcomePageSeen,
                        activeColor: Theme.of(context).accentColor,
                        onChanged: (value) async {
                          prefs.welcomePageSeen = !value;
                        },
                      ),
                      SettingsTile(
                        icon: Icon(MdiIcons.databaseRemove),
                        title:
                            Text(LocaleStrings.settingsPage.debugClearDatabase),
                        onTap: () async {
                          await helper.deleteAllNotes();
                          await NoteController.deleteAll();
                        },
                      ),
                      SettingsTile(
                        icon: Icon(MdiIcons.databaseImport),
                        title: Text(
                            LocaleStrings.settingsPage.debugMigrateDatabase),
                        onTap: () async {
                          bool canMigrate =
                              await MigrationTask.migrationAvailable;

                          if (canMigrate) {
                            showDialog(
                              context: context,
                              builder: (context) => StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text("Migrating..."),
                                    content: StreamBuilder<double>(
                                      stream: MigrationTask.migrate(),
                                      initialData: 0.0,
                                      builder: (context, snapshot) {
                                        return LinearProgressIndicator(
                                          value: snapshot.data,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                      SettingsTile(
                        icon: Icon(MdiIcons.text),
                        title: Text(LocaleStrings.settingsPage.debugLogLevel),
                        onTap: () {
                          showDropdownSheet(
                            context: context,
                            itemBuilder: (context, index) {
                              bool selected =
                                  prefs.logLevel == logEntryValues[index];

                              return dropDownTile(
                                selected: selected,
                                title: Text(
                                  getLogEntryName(logEntryValues[index]),
                                ),
                                onTap: () {
                                  prefs.logLevel = logEntryValues[index];
                                  Navigator.pop(context);
                                },
                              );
                            },
                            itemCount: logEntryValues.length,
                          );
                        },
                        subtitle: Text(getLogEntryName(prefs.logLevel)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget get commonSettings {
    String currentLocaleName = firstLetterToUppercase(
      LocaleNamesLocalizationsDelegate
          .nativeLocaleNames[context.locale.languageCode],
    );

    return Column(
      children: <Widget>[
        SettingsCategory(
          header: LocaleStrings.settingsPage.personalizationTitle,
          children: [
            SettingsTile(
              icon: Icon(OMIcons.brightnessMedium),
              title: Text(LocaleStrings.settingsPage.personalizationThemeMode),
              onTap: () {
                showDropdownSheet(
                  context: context,
                  itemBuilder: (context, index) {
                    bool selected = prefs.themeMode == ThemeMode.values[index];

                    return dropDownTile(
                      selected: selected,
                      title: Text(
                        getThemeModeName(ThemeMode.values[index]),
                      ),
                      onTap: () {
                        prefs.themeMode = ThemeMode.values[index];
                        Navigator.pop(context);
                      },
                    );
                  },
                  itemCount: ThemeMode.values.length,
                );
              },
              subtitle: Text(getThemeModeName(prefs.themeMode)),
            ),
            SettingsTile.withSwitch(
              value: prefs.useAmoled,
              onChanged: (value) => prefs.useAmoled = value,
              title: Text(LocaleStrings.settingsPage.personalizationUseAmoled),
              icon: Icon(OMIcons.brightness2),
              activeColor: Theme.of(context).accentColor,
            ),
            SettingsTile.withSwitch(
              value: !deviceInfo.canUseSystemAccent
                  ? false
                  : !prefs.useCustomAccent,
              onChanged: (value) => prefs.useCustomAccent = !value,
              title: Text(
                LocaleStrings.settingsPage.personalizationUseCustomAccent,
              ),
              icon: Icon(OMIcons.colorLens),
              activeColor: Theme.of(context).accentColor,
              enabled: deviceInfo.canUseSystemAccent,
            ),
            SettingsTile(
              title: Text(
                LocaleStrings.settingsPage.personalizationCustomAccent,
              ),
              icon: Icon(OMIcons.colorize),
              enabled: DeviceInfo.isDesktopOrWeb ? true : prefs.useCustomAccent,
              trailing: AnimatedOpacity(
                opacity:
                    (DeviceInfo.isDesktopOrWeb ? true : prefs.useCustomAccent)
                        ? 1
                        : 0.5,
                duration: Duration(milliseconds: 200),
                child: SizedBox(
                  width: 60,
                  child: Icon(
                    Icons.brightness_1,
                    color: prefs.customAccent ?? Utils.defaultAccent,
                    size: 28,
                  ),
                ),
              ),
              onTap: () async {
                int result = await Utils.showNotesModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => RGBColorPicker(
                    initialColor: Theme.of(context).accentColor,
                  ),
                );

                if (result != null) {
                  if (result == -1) {
                    prefs.customAccent = null;
                  } else {
                    prefs.customAccent = Color(result);
                  }
                }
              },
            ),
            SettingsTile.withSwitch(
              value: prefs.useGrid,
              onChanged: (value) => prefs.useGrid = value,
              title: Text(LocaleStrings.settingsPage.personalizationUseGrid),
              icon: Icon(MdiIcons.viewDashboardOutline),
              activeColor: Theme.of(context).accentColor,
            ),
            SettingsTile(
              icon: Icon(Icons.translate),
              title: Text(LocaleStrings.settingsPage.personalizationLocale),
              onTap: () {
                showDropdownSheet(
                  context: context,
                  scrollable: true,
                  itemBuilder: (context, index) {
                    Locale locale = context.supportedLocales[index];
                    String localizedName = firstLetterToUppercase(
                      LocaleNames.of(context).nameOf(locale.languageCode),
                    );
                    String nativeName = firstLetterToUppercase(
                      LocaleNamesLocalizationsDelegate
                          .nativeLocaleNames[locale.languageCode],
                    );
                    bool selected = context.locale == locale;

                    return dropDownTile(
                      title: Text(localizedName),
                      subtitle: Text(nativeName),
                      selected: selected,
                      onTap: () {
                        context.locale = locale;
                        Navigator.pop(context);
                      },
                    );
                  },
                  itemCount: context.supportedLocales.length,
                );
              },
              subtitle: Text(currentLocaleName),
            ),
            SettingsTile(
              icon: Icon(Icons.autorenew),
              title: Text("Change sync API url"),
              onTap: () async {
                bool status = await showInfoSheet(
                  context,
                  content:
                      "If you decide to change the sync api url every note will get deleted to prevent conflicts. Do this only if you know what are you doing.",
                  buttonAction: LocaleStrings.common.goOn,
                );
                if (status)
                  Utils.showNotesModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SyncUrlEditor(),
                  );
              },
            )
          ],
        ),
        SettingsCategory(
          header: LocaleStrings.settingsPage.privacyTitle,
          children: [
            SettingsTile.withSwitch(
              value: prefs.masterPass != "",
              onChanged: (value) async {
                if (prefs.masterPass == "") {
                  bool status = await showInfoSheet(
                    context,
                    content: LocaleStrings
                        .settingsPage.privacyUseMasterPassDisclaimer,
                    buttonAction: LocaleStrings.common.goOn,
                  );
                  if (status) showPassChallengeSheet(context);
                } else {
                  bool confirm =
                      await showPassChallengeSheet(context, false) ?? false;

                  if (confirm) {
                    prefs.masterPass = "";

                    List<Note> notes = await helper.listNotes(ReturnMode.LOCAL);

                    setState(() => removingMasterPass = true);
                    for (int i = 0; i < notes.length; i++) {
                      final note = notes[i];
                      if (note.lockNote) {
                        await helper.saveNote(Utils.markNoteChanged(note)
                            .copyWith(lockNote: false));
                      }
                    }
                    setState(() => removingMasterPass = false);
                  }
                }
              },
              icon: Icon(OMIcons.vpnKey),
              title: Text(LocaleStrings.settingsPage.privacyUseMasterPass),
              activeColor: Theme.of(context).accentColor,
              subtitle: removingMasterPass ? LinearProgressIndicator() : null,
            ),
            SettingsTile(
              icon: Icon(MdiIcons.formTextboxPassword),
              title: Text(LocaleStrings.settingsPage.privacyModifyMasterPass),
              enabled: prefs.masterPass != "",
              onTap: () async {
                bool confirm =
                    await showPassChallengeSheet(context, false) ?? false;
                if (confirm) showPassChallengeSheet(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<bool> showInfoSheet(BuildContext context,
      {String content, String buttonAction}) async {
    return await Utils.showNotesModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(content),
              ),
              ListTile(
                leading: Icon(MdiIcons.arrowRight),
                title: Text(buttonAction),
                onTap: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<dynamic> showDropdownSheet({
    @required BuildContext context,
    @required IndexedWidgetBuilder itemBuilder,
    int itemCount,
    bool scrollable = false,
  }) async {
    final list = ListView.builder(
      shrinkWrap: true,
      physics: scrollable ? null : NeverScrollableScrollPhysics(),
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );

    return await Utils.showNotesModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.shortestSide,
        ),
        child: scrollable
            ? Scrollbar(
                child: list,
              )
            : list,
      ),
    );
  }

  Widget dropDownTile({
    @required Widget title,
    Widget subtitle,
    @required bool selected,
    VoidCallback onTap,
  }) {
    return ListTile(
      selected: selected,
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
      title: title,
      subtitle: subtitle,
      trailing: selected ? Icon(Icons.check) : null,
      onTap: onTap,
    );
  }

  String getThemeModeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return LocaleStrings.settingsPage.personalizationThemeModeLight;
      case ThemeMode.dark:
        return LocaleStrings.settingsPage.personalizationThemeModeDark;
      case ThemeMode.system:
      default:
        return LocaleStrings.settingsPage.personalizationThemeModeSystem;
    }
  }

  Future<dynamic> showPassChallengeSheet(BuildContext context,
      [bool editMode = true]) async {
    return await Utils.showNotesModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PassChallenge(
        editMode: editMode,
        onChallengeSuccess: () => Navigator.pop(context, true),
        onSave: (text) async {
          prefs.masterPass = text;

          Navigator.pop(context);
        },
      ),
    );
  }

  String firstLetterToUppercase(String origin) {
    String firstLetter = origin.substring(0, 1);
    String restOfTheString = origin.substring(1);

    return firstLetter.toUpperCase() + restOfTheString;
  }

  List<int> get logEntryValues => [
        LogEntry.VERBOSE,
        LogEntry.DEBUG,
        LogEntry.INFO,
        LogEntry.WARN,
        LogEntry.ERROR,
        LogEntry.WTF,
      ];

  String getLogEntryName(int entry) {
    switch (entry) {
      case LogEntry.DEBUG:
        return "Debug";
      case LogEntry.INFO:
        return "Info";
      case LogEntry.WARN:
        return "Warn";
      case LogEntry.ERROR:
        return "Error";
      case LogEntry.WTF:
        return "WTF";
      case LogEntry.VERBOSE:
      default:
        return "Verbose";
    }
  }
}
