import 'dart:io';
import 'dart:math';

import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:liblymph/database.dart';
import 'package:loggy/loggy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/constants.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/file_system_helper.dart';
import 'package:potato_notes/internal/in_app_update.dart';
import 'package:potato_notes/internal/native_names.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/theme/data.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/about_page.dart';
import 'package:potato_notes/routes/backup_and_restore/backup_page.dart';
import 'package:potato_notes/routes/backup_and_restore/restore_page.dart';
import 'package:potato_notes/routes/theme_picker_page.dart';
import 'package:potato_notes/widget/dependent_scaffold.dart';
import 'package:potato_notes/widget/pass_challenge.dart';
import 'package:potato_notes/widget/rgb_color_picker.dart';
import 'package:potato_notes/widget/settings_category.dart';
import 'package:potato_notes/widget/settings_tile.dart';
import 'package:potato_notes/widget/sync_url_editor.dart';
import 'package:recase/recase.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:yatl_flutter/yatl_flutter.dart' hide Locale;

class SettingsPage extends StatefulWidget {
  final bool trimmed;

  const SettingsPage({
    Key? key,
    this.trimmed = false,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool removingMasterPass = false;

  @override
  Widget build(BuildContext context) {
    if (widget.trimmed) return Observer(builder: (context) => commonSettings);

    return DependentScaffold(
      resizeToAvoidBottomInset: false,
      body: Observer(
        builder: (context) {
          return ListView(
            padding: EdgeInsets.only(
              top: context.padding.top,
              bottom: context.viewInsets.bottom,
            ),
            primary: UniversalPlatform.isIOS,
            controller: !UniversalPlatform.isIOS ? ScrollController() : null,
            children: [
              commonSettings,
              SettingsCategory(
                header: strings.settings.backupRestoreTitle,
                children: [
                  SettingsTile(
                    icon: const Icon(Icons.save_outlined),
                    title: Text(strings.settings.backupRestoreBackup),
                    description: Text(strings.settings.backupRestoreBackupDesc),
                    onTap: () async {
                      final List<Note> notes =
                          await noteHelper.listNotes(BuiltInFolders.all);
                      if (notes.isNotEmpty) {
                        await Utils.showModalBottomSheet(
                          context: context,
                          builder: (context) => BackupPage(),
                        );
                      } else {
                        await Utils.showAlertDialog(
                          context: context,
                          title: Text(
                            strings.settings
                                .backupRestoreBackupNothingToRestoreTitle,
                          ),
                          content: Text(
                            strings.settings
                                .backupRestoreBackupNothingToRestoreDesc,
                          ),
                        );
                      }
                    },
                  ),
                  SettingsTile(
                    icon: const Icon(Icons.restart_alt_rounded),
                    title: Text(strings.settings.backupRestoreRestore),
                    description: Text(
                      strings.settings.backupRestoreRestoreDesc,
                    ),
                    onTap: () async {
                      await Utils.showModalBottomSheet(
                        context: context,
                        builder: (context) => const RestoreNotesPage(),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: const Icon(Icons.file_present_outlined),
                    title: Text(strings.settings.backupRestoreImport),
                    description: Text(strings.settings.backupRestoreImportDesc),
                    onTap: () async {
                      await Utils.showModalBottomSheet(
                        context: context,
                        builder: (context) => const ImportNotesPage(),
                      );
                    },
                  ),
                ],
              ),
              SettingsCategory(
                header: strings.settings.infoTitle,
                children: <Widget>[
                  SettingsTile(
                    icon: const Icon(Icons.info_outline),
                    title: Text(strings.settings.infoAboutApp),
                    onTap: () => Utils.showSecondaryRoute(
                      context,
                      AboutPage(),
                    ),
                  ),
                  SettingsTile(
                    icon: const Icon(Icons.update_outlined),
                    title: Text(strings.settings.infoUpdateCheck),
                    onTap: () => InAppUpdater.checkForUpdate(
                      context,
                      showNoUpdatesAvailable: true,
                    ),
                  ),
                  SettingsTile(
                    icon: const Icon(Icons.translate),
                    title: Text(strings.settings.infoTranslate),
                    onTap: () => Utils.launchUrl(
                      "https://crowdin.potatoproject.co/leaflet",
                    ),
                  ),
                  SettingsTile(
                    icon: const Icon(Icons.bug_report_outlined),
                    visible: appConfig.bugReportUrl != null,
                    title: Text(strings.settings.infoBugReport),
                    onTap: () => Utils.launchUrl(appConfig.bugReportUrl!),
                  ),
                ],
              ),
              Visibility(
                // ignore: avoid_redundant_argument_values
                visible: kDebugMode,
                child: SettingsCategory(
                  header: strings.settings.debugTitle,
                  children: [
                    SettingsTile.withSwitch(
                      icon: const Icon(Icons.emoji_people_outlined),
                      title: Text(
                        strings.settings.debugShowSetupScreen,
                      ),
                      value: !prefs.welcomePageSeen,
                      activeColor: context.theme.colorScheme.secondary,
                      onChanged: (value) async {
                        prefs.welcomePageSeen = !value;
                      },
                    ),
                    SettingsTile(
                      icon: const Icon(Icons.timer),
                      title: Text(strings.settings.debugLoadingOverlay),
                      onTap: () {
                        Utils.showLoadingOverlay(context);
                        Future.delayed(
                          const Duration(milliseconds: 5000),
                          () async => Utils.hideLoadingOverlay(context),
                        );
                      },
                    ),
                    SettingsTile(
                      icon: const Icon(MdiIcons.databaseRemoveOutline),
                      title: Text(strings.settings.debugClearDatabase),
                      onTap: () async {
                        await noteHelper.deleteAllNotes();
                        if (AppInfo.supportsNotesApi &&
                            prefs.accessToken != null) {
                          //await Controller.note.deleteAll();
                        }
                      },
                    ),
                    SettingsTile(
                      icon: const Icon(MdiIcons.databasePlusOutline),
                      title: Text(strings.settings.debugGenerateTrash),
                      onTap: () async {
                        for (int i = 0; i < 100; i++) {
                          final Random r = Random();
                          final Note n = NoteX.emptyNote.copyWith(
                            id: Utils.generateId(),
                            title: String.fromCharCodes(
                              List.generate(
                                32,
                                (index) => 33 + r.nextInt(126 - 33),
                              ),
                            ),
                            content: String.fromCharCodes(
                              List.generate(
                                128,
                                (index) => 33 + r.nextInt(126 - 33),
                              ),
                            ),
                            starred: r.nextBool(),
                            color: r.nextInt(10),
                          );
                          await noteHelper.saveNote(n);
                        }
                      },
                    ),
                    SettingsTile(
                      icon: const Icon(Icons.text_snippet_outlined),
                      title: Text(strings.settings.debugLogLevel),
                      onTap: () {
                        showDropdownSheet(
                          context: context,
                          itemBuilder: (context, index) {
                            final bool selected = prefs.logLevel == index;

                            return dropDownTile(
                              selected: selected,
                              title: Text(
                                LogLevel.values[index].name,
                              ),
                              onTap: () {
                                prefs.logLevel = index;
                                context.pop();
                              },
                            );
                          },
                          itemCount: LogLevel.values.length,
                        );
                      },
                      subtitle: Text(LogLevel.values[prefs.logLevel].name),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget get commonSettings {
    return Column(
      children: <Widget>[
        SettingsCategory(
          header: "Themes",
          children: [
            SettingsTile(
              icon: const Icon(Icons.brightness_4_outlined),
              title: Text(strings.settings.personalizationThemeMode),
              onTap: () {
                showDropdownSheet(
                  context: context,
                  itemBuilder: (context, index) {
                    final ThemeMode themeMode = ThemeMode.values[index];
                    final bool selected = prefs.themeMode == themeMode;

                    return dropDownTile(
                      selected: selected,
                      title: Text(
                        getThemeModeName(themeMode),
                      ),
                      onTap: () {
                        prefs.themeMode = themeMode;
                        context.pop();
                      },
                    );
                  },
                  itemCount: ThemeMode.values.length,
                );
              },
              subtitle: Text(getThemeModeName(prefs.themeMode)),
            ),
            SettingsTile(
              icon: const Icon(Icons.light_mode_outlined),
              title: const Text("Light theme"),
              subtitle: Text(
                "${appInfo.lightTheme.name} \u2022 ${appInfo.lightTheme.author}",
              ),
              onTap: () {
                Utils.showModalBottomSheet(
                  context: context,
                  builder: (context) => const ThemePickerPage(
                    pickerMode: Brightness.light,
                  ),
                );
              },
            ),
            SettingsTile(
              icon: const Icon(Icons.dark_mode_outlined),
              title: const Text("Dark theme"),
              subtitle: Text(
                "${appInfo.darkTheme.name} \u2022 ${appInfo.darkTheme.author}",
              ),
              onTap: () {
                Utils.showModalBottomSheet(
                  context: context,
                  builder: (context) => const ThemePickerPage(
                    pickerMode: Brightness.dark,
                  ),
                );
              },
            ),
            SettingsTile(
              icon: const Icon(Icons.note_add_outlined),
              title: const Text("Import theme from file"),
              onTap: () async {
                final String? themePath = await FileSystemHelper.getFile();

                if (themePath == null) return;

                final ImportedTheme? theme =
                    await appInfo.addTheme(File(themePath));

                if (theme != null) {
                  final String themeVariant;
                  switch (theme.data.colors.brightness) {
                    case Brightness.light:
                      themeVariant = "Light";
                      break;
                    case Brightness.dark:
                      themeVariant = "Dark";
                      break;
                  }

                  context.scaffoldMessenger.removeCurrentSnackBar();
                  context.scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Theme "${theme.data.name}" by ${theme.data.author} added to $themeVariant themes',
                      ),
                      width: min(640, context.mSize.width - 32),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  context.scaffoldMessenger.removeCurrentSnackBar();
                  context.scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: const Text('Invalid theme file selected'),
                      width: min(640, context.mSize.width - 32),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            SettingsTile(
              icon: const Icon(Icons.refresh),
              title: const Text("Reload all themes"),
              onTap: () async {
                final DiffResult themeDiffs = await appInfo.refetchThemes();
                final List<DiffUpdate> updates =
                    themeDiffs.getUpdates().toList();
                int insertions = 0;
                int removals = 0;

                for (final DiffUpdate update in updates) {
                  if (update is Insert) {
                    insertions += update.count;
                  } else if (update is Remove) {
                    removals += update.count;
                  }
                }

                context.scaffoldMessenger.removeCurrentSnackBar();
                context.scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Reloaded every theme. Added $insertions themes and removed $removals.',
                    ),
                    width: min(640, context.mSize.width - 32),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
        SettingsCategory(
          header: strings.settings.personalizationTitle,
          children: [
            if (deviceInfo.canUseSystemAccent)
              SettingsTile.withSwitch(
                value: !deviceInfo.canUseSystemAccent
                    ? false
                    : !prefs.useCustomAccent,
                onChanged: (value) => prefs.useCustomAccent = !value,
                title: Text(
                  strings.settings.personalizationUseCustomAccent,
                ),
                icon: const Icon(Icons.color_lens_outlined),
                activeColor: context.theme.colorScheme.secondary,
              ),
            SettingsTile(
              title: Text(
                strings.settings.personalizationCustomAccent,
              ),
              icon: const Icon(Icons.colorize_outlined),
              enabled: !deviceInfo.canUseSystemAccent || prefs.useCustomAccent,
              trailing: AnimatedOpacity(
                opacity: !deviceInfo.canUseSystemAccent || prefs.useCustomAccent
                    ? 1
                    : 0.5,
                duration: const Duration(milliseconds: 200),
                child: SizedBox(
                  width: 60,
                  child: Icon(
                    Icons.brightness_1,
                    color: prefs.customAccent ?? Constants.defaultAccent,
                    size: 28,
                  ),
                ),
              ),
              onTap: () async {
                final int? result = await Utils.showModalBottomSheet(
                  context: context,
                  builder: (context) => RGBColorPicker(
                    initialColor: prefs.customAccent ?? Constants.defaultAccent,
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
              title: Text(strings.settings.personalizationUseGrid),
              icon: const Icon(Icons.dashboard_outlined),
              activeColor: context.theme.colorScheme.secondary,
            ),
            SettingsTile(
              icon: const Icon(Icons.language),
              title: Text(strings.settings.personalizationLocale),
              onTap: () {
                showDropdownSheet(
                  context: context,
                  initialIndex: prefs.locale != null
                      ? context.supportedLocales.indexOf(prefs.locale!) + 1
                      : 0,
                  scrollable: true,
                  itemBuilder: (context, index) {
                    final Locale? locale =
                        index == 0 ? null : context.supportedLocales[index - 1];
                    final String nativeName = locale != null
                        ? firstLetterToUppercase(
                            localeNativeNames[locale.languageCode]!,
                          )
                        : strings.settings.personalizationLocaleDeviceDefault;
                    final bool selected = prefs.locale == locale;
                    final Locale deviceLocale = locales.supportedLocales
                            .contains(appInfo.deviceLocale.toIntlLocale())
                        ? appInfo.deviceLocale
                        : const Locale("en", "US");

                    double? translationPercentage;
                    if (locale != null) {
                      translationPercentage =
                          locales.progressData[locale.toLanguageTag()]! /
                              locales.progressData["en-US"]!;
                    } else {
                      translationPercentage =
                          locales.progressData[deviceLocale.toLanguageTag()]! /
                              locales.progressData["en-US"]!;
                    }

                    return dropDownTile(
                      title: Text(nativeName),
                      subtitle: Text(
                        locale != null
                            ? strings.settings.personalizationLocaleXTranslated(
                                (translationPercentage * 100).round(),
                              )
                            : "${localeNativeNames[deviceLocale.languageCode]!.sentenceCase} \u2022 ${(translationPercentage * 100).round()}%",
                      ),
                      selected: selected,
                      onTap: () {
                        prefs.locale = locale;
                        setState(() {});
                        context.pop();
                      },
                    );
                  },
                  itemCount: context.supportedLocales.length + 1,
                );
              },
              subtitle: Text(
                prefs.locale != null
                    ? firstLetterToUppercase(
                        localeNativeNames[prefs.locale!.languageCode]!,
                      )
                    : strings.settings.personalizationLocaleDeviceDefault,
              ),
            ),
            SettingsTile(
              icon: const Icon(Icons.autorenew),
              title: const Text("Change sync API url"),
              visible: AppInfo.supportsNotesApi,
              onTap: () async {
                final bool? status = await showInfoSheet(
                  context,
                  content:
                      "If you decide to change the sync api url every note will get deleted to prevent conflicts. Do this only if you know what are you doing.",
                  buttonAction: strings.common.goOn,
                );
                if (status ?? false) {
                  Utils.showModalBottomSheet(
                    context: context,
                    builder: (context) => SyncUrlEditor(),
                  );
                }
              },
            )
          ],
        ),
        SettingsCategory(
          header: strings.settings.privacyTitle,
          children: [
            SettingsTile.withSwitch(
              value: prefs.masterPass != "",
              onChanged: (value) async {
                if (prefs.masterPass == "") {
                  final bool? status = await showInfoSheet(
                    context,
                    content: strings.settings.privacyUseMasterPassDisclaimer,
                    buttonAction: strings.common.goOn,
                  );
                  if (status ?? false) showPassChallengeSheet(context);
                } else {
                  final bool? confirm =
                      await showPassChallengeSheet(context, false);

                  if (confirm ?? false) {
                    prefs.masterPass = "";

                    final List<Note> notes =
                        await noteHelper.listNotes(BuiltInFolders.all);

                    setState(() => removingMasterPass = true);
                    //context.basePage!.setNavigationEnabled(false);
                    for (int i = 0; i < notes.length; i++) {
                      final Note note = notes[i];
                      if (note.lockNote) {
                        await noteHelper.saveNote(
                          note.markChanged().copyWith(lockNote: false),
                        );
                      }
                    }
                    //context.basePage!.setNavigationEnabled(true);
                  }
                }
              },
              icon: const Icon(Icons.vpn_key_outlined),
              title: Text(strings.settings.privacyUseMasterPass),
              activeColor: context.theme.colorScheme.secondary,
              subtitle:
                  removingMasterPass ? const LinearProgressIndicator() : null,
            ),
            SettingsTile(
              icon: const Icon(Icons.password_outlined),
              title: Text(strings.settings.privacyModifyMasterPass),
              enabled: prefs.masterPass != "",
              onTap: () async {
                final bool? confirm =
                    await showPassChallengeSheet(context, false);
                if ((confirm ?? false) && mounted) {
                  showPassChallengeSheet(context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<bool?> showInfoSheet(
    BuildContext context, {
    required String content,
    required String buttonAction,
  }) async {
    return await Utils.showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(content),
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward),
                title: Text(buttonAction),
                onTap: () {
                  context.pop(true);
                },
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<dynamic> showDropdownSheet({
    required BuildContext context,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    int initialIndex = 0,
    bool scrollable = false,
  }) async {
    return Utils.showModalBottomSheet(
      context: context,
      builder: (context) => scrollable
          ? ListView.builder(
              itemBuilder: itemBuilder,
              itemCount: itemCount,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                itemCount,
                (index) => itemBuilder(context, index),
              ),
            ),
    );
  }

  Widget dropDownTile({
    required Widget title,
    Widget? subtitle,
    required bool selected,
    VoidCallback? onTap,
  }) {
    return ListTile(
      selected: selected,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: title,
      subtitle: subtitle,
      trailing: selected ? const Icon(Icons.check) : null,
      onTap: onTap,
    );
  }

  String getThemeModeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return strings.settings.personalizationThemeModeLight;
      case ThemeMode.dark:
        return strings.settings.personalizationThemeModeDark;
      case ThemeMode.system:
      default:
        return strings.settings.personalizationThemeModeSystem;
    }
  }

  Future<bool?> showPassChallengeSheet(
    BuildContext context, [
    bool editMode = true,
  ]) async {
    return Utils.showModalBottomSheet(
      context: context,
      builder: (context) => PassChallenge(
        editMode: editMode,
        onChallengeSuccess: () => context.pop(true),
        onSave: (text) async {
          prefs.masterPass = Utils.hashedPass(text);

          context.pop();
        },
      ),
    );
  }

  String firstLetterToUppercase(String origin) {
    return ReCase(origin).sentenceCase;
  }
}

extension _LogLevelName on LogLevel {
  String get name {
    return toString().split(".").last.sentenceCase;
  }
}
