import 'dart:convert';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/widget/pass_challenge.dart';
import 'package:potato_notes/widget/settings_category.dart';
import 'package:provider/provider.dart';
import 'package:spicy_components/spicy_components.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Preferences prefs;
  @override
  Widget build(BuildContext context) {
    if (prefs == null) prefs = Provider.of<Preferences>(context);

    return Scaffold(
      body: ListView(
        children: [
          SettingsCategory(
            header: "Privacy",
            children: [
              SwitchListTile(
                value: prefs.passType != PassType.NONE,
                onChanged: (value) async {
                  if (prefs.passType == PassType.NONE) {
                    showMasterPassChoiceSheet(context);
                  } else {
                    bool confirm = await showPassChallengeSheet(context, prefs.passType, false) ?? false;

                    if(confirm) {
                      prefs.passType = PassType.NONE;
                      prefs.masterPassword = null;
                      prefs.masterPin = null;
                    }
                  }
                },
                secondary: Icon(OMIcons.vpnKey),
                title: Text("Use master pass"),
                activeColor: Theme.of(context).accentColor,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 32, vertical: 4),
              ),
              ListTile(
                leading: Icon(CommunityMaterialIcons.textbox_password),
                title: Text("Modify password"),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                enabled: prefs.passType == PassType.PASSWORD,
                onTap: () async {
                  bool confirm = await showPassChallengeSheet(context, prefs.passType, false) ?? false;
                  if(confirm)
                    showPassChallengeSheet(context, PassType.PASSWORD);
                },
              ),
              ListTile(
                leading: Icon(CommunityMaterialIcons.dialpad),
                title: Text("Modify pin"),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                enabled: prefs.passType == PassType.PIN,
                onTap: () async {
                  bool confirm = await showPassChallengeSheet(context, prefs.passType, false) ?? false;
                  if(confirm)
                    showPassChallengeSheet(context, PassType.PIN);
                },
              ),
            ],
          ),
        ],
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      ),
      bottomNavigationBar: SpicyBottomBar(
        leftItems: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            padding: EdgeInsets.all(0),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }

  void showMasterPassChoiceSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                  "Warning: if you ever forget the pass you can't reset it, you'll need to uninstall the app, hence getting all the notes erased, and reinstall it. Please write it down somewhere.")),
          ListTile(
            leading: Icon(CommunityMaterialIcons.textbox_password),
            title: Text("Password"),
            contentPadding: EdgeInsets.symmetric(horizontal: 32),
            onTap: () {
              Navigator.pop(context);
              showPassChallengeSheet(context, PassType.PASSWORD);
            },
          ),
          ListTile(
            leading: Icon(CommunityMaterialIcons.dialpad),
            title: Text("Pin"),
            contentPadding: EdgeInsets.symmetric(horizontal: 32),
            onTap: () {
              Navigator.pop(context);
              showPassChallengeSheet(context, PassType.PIN);
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> showPassChallengeSheet(BuildContext context, PassType passType, [bool editMode = true]) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PassChallenge(
        passType: passType,
        editMode: editMode,
        onChallengeSuccess: () => Navigator.pop(context, true),
        onSave: (text) async {
          String hash = sha256.convert(utf8.encode(text)).toString();
          if (passType == PassType.PASSWORD) {
            prefs.passType = PassType.PASSWORD;
            prefs.masterPassword = hash;
            prefs.masterPin = null;
          } else {
            prefs.passType = PassType.PIN;
            prefs.masterPassword = null;
            prefs.masterPin = hash;
          }

          Navigator.pop(context);
        },
      ),
    );
  }
}
