import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/migration_task.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/about_page.dart';
import 'package:potato_notes/widget/pass_challenge.dart';
import 'package:potato_notes/widget/rgb_color_picker.dart';
import 'package:potato_notes/widget/settings_category.dart';

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
    if (widget.trimmed) return commonSettings;

    return WillPopScope(
      onWillPop: () async => !removingMasterPass,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          textTheme: Theme.of(context).textTheme,
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            commonSettings,
            SettingsCategory(
              header: "Info",
              children: <Widget>[
                ListTile(
                  leading: Icon(MdiIcons.informationOutline),
                  title: Text("About PotatoNotes"),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                  onTap: () => Utils.showSecondaryRoute(
                    context,
                    AboutPage(),
                    sidePadding: kTertiaryRoutePadding,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: kDebugMode,
              child: SettingsCategory(
                header: "Debug",
                children: [
                  SwitchListTile(
                    secondary: Icon(MdiIcons.humanGreeting),
                    title: Text("Show setup screen on next startup"),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                    value: !prefs.welcomePageSeen,
                    activeColor: Theme.of(context).accentColor,
                    onChanged: (value) async {
                      prefs.welcomePageSeen = !value;
                    },
                  ),
                  ListTile(
                    leading: Icon(CommunityMaterialIcons.database_remove),
                    title: Text("Flush database"),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                    onTap: () async {
                      List<Note> notes = await helper.listNotes(ReturnMode.ALL);

                      notes.forEach(
                          (element) async => await helper.deleteNote(element));
                    },
                  ),
                  ListTile(
                    leading: Icon(CommunityMaterialIcons.database_import),
                    title: Text("Migrate database"),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                    onTap: () async {
                      bool canMigrate = await MigrationTask.migrationAvailable;

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
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                    leading: Icon(CommunityMaterialIcons.text),
                    title: Text("Log level"),
                    trailing: DropdownButton(
                      items: [
                        DropdownMenuItem(
                          child: Text("Verbose"),
                          value: LogEntry.VERBOSE,
                        ),
                        DropdownMenuItem(
                          child: Text("Debug"),
                          value: LogEntry.DEBUG,
                        ),
                        DropdownMenuItem(
                          child: Text("Info"),
                          value: LogEntry.INFO,
                        ),
                        DropdownMenuItem(
                          child: Text("Warn"),
                          value: LogEntry.WARN,
                        ),
                        DropdownMenuItem(
                          child: Text("Error"),
                          value: LogEntry.ERROR,
                        ),
                        DropdownMenuItem(
                          child: Text("WTF"),
                          value: LogEntry.WTF,
                        ),
                      ],
                      onChanged: (value) => prefs.logLevel = value,
                      value: prefs.logLevel,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get commonSettings {
    return Column(
      children: <Widget>[
        SettingsCategory(
          header: "Personalization",
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
              leading: Icon(CommunityMaterialIcons.theme_light_dark),
              title: Text("Theme mode"),
              trailing: DropdownButton(
                items: [
                  DropdownMenuItem(
                    child: Text("System"),
                    value: ThemeMode.system,
                  ),
                  DropdownMenuItem(
                    child: Text("Light"),
                    value: ThemeMode.light,
                  ),
                  DropdownMenuItem(
                    child: Text("Dark"),
                    value: ThemeMode.dark,
                  ),
                ],
                onChanged: (value) => prefs.themeMode = value,
                value: prefs.themeMode,
              ),
            ),
            SwitchListTile(
              value: prefs.useAmoled,
              onChanged: (value) => prefs.useAmoled = value,
              title: Text("Use AMOLED theme"),
              secondary: Icon(CommunityMaterialIcons.brightness_6),
              activeColor: Theme.of(context).accentColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            ),
            SwitchListTile(
              value: !deviceInfo.canUseSystemAccent
                  ? false
                  : !prefs.useCustomAccent,
              onChanged: !deviceInfo.canUseSystemAccent
                  ? null
                  : (value) => prefs.useCustomAccent = !value,
              title: Text("Follow system accent"),
              secondary: Icon(OMIcons.colorLens),
              activeColor: Theme.of(context).accentColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            ),
            ListTile(
              leading: Icon(OMIcons.colorize),
              title: Text("Pick a custom accent"),
              contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
              enabled: kIsWeb ? true : prefs.useCustomAccent,
              trailing: AnimatedOpacity(
                opacity: (kIsWeb ? true : prefs.useCustomAccent) ? 1 : 0.5,
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
            SwitchListTile(
              value: prefs.useGrid,
              onChanged: (value) => prefs.useGrid = value,
              title: Text("Grid view for notes"),
              secondary: Icon(CommunityMaterialIcons.view_dashboard_outline),
              activeColor: Theme.of(context).accentColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            ),
          ],
        ),
        SettingsCategory(
          header: "Privacy",
          children: [
            SwitchListTile(
              value: prefs.masterPass != "",
              onChanged: (value) async {
                if (prefs.masterPass == "") {
                  bool status = await showInfoSheet(
                    context,
                    content:
                        "Warning: if you ever forget the pass you can't reset it, you'll need to uninstall the app, hence getting all the notes erased, and reinstall it. Please write it down somewhere.",
                    buttonAction: "Go on",
                  );
                  if (status) showPassChallengeSheet(context);
                } else {
                  bool confirm =
                      await showPassChallengeSheet(context, false) ?? false;

                  if (confirm) {
                    prefs.masterPass = "";

                    List<Note> notes = await helper.listNotes(ReturnMode.ALL);

                        setState(() => removingMasterPass = true);
                        for (int i = 0; i < notes.length; i++) {
                          await helper.saveNote(notes[i].copyWith(
                              lockNote: false,
                              synced: false,
                              lastModifyDate: DateTime.now()));
                        }
                        setState(() => removingMasterPass = false);
                      }
                    }
                  },
                  secondary: Icon(OMIcons.vpnKey),
                  title: Text("Use master pass"),
                  activeColor: Theme.of(context).accentColor,
                  subtitle:
                      removingMasterPass ? LinearProgressIndicator() : null,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                ),
                ListTile(
                  leading: Icon(CommunityMaterialIcons.form_textbox_password),
              title: Text("Modify master pass"),
              contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
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
                leading: Icon(CommunityMaterialIcons.arrow_right),
                title: Text(buttonAction),
                contentPadding: EdgeInsets.symmetric(horizontal: 32),
                onTap: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ) ??
        false;
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
}
