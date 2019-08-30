import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/methods.dart';
import 'package:potato_notes/routes/easteregg_route.dart';

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

class SettingsRoute extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<SettingsRoute> {

  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
              height: 70,
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
                          "Settings",
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
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 70),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 70),
                  child: Text(
                    "Themes",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.brightness_5),
                  title: Text('App theme'),
                  trailing: DropdownButton(
                    value: appInfo.themeMode,
                    underline: Container(),
                    items: <DropdownMenuItem>[
                      DropdownMenuItem(
                        child: Text("Light"),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        child: Text("Dark"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("Black"),
                        value: 2,
                      ),
                    ],
                    onChanged: (newValue) {
                      appInfo.themeMode = newValue;
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.color_lens),
                  trailing: CircleColor(
                    color: Theme.of(context).accentColor,
                    circleSize: 24.0,
                    elevation: 0,
                  ),
                  title: Text('Accent color'),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      Color currentColor = Theme.of(context).accentColor;
                      return AlertDialog(
                        title: Text("Accent color selector"),
                        content: MaterialColorPicker(
                          circleSize: 70.0,
                          allowShades: true,
                          onColorChange: (color) {
                            currentColor = color;
                          },
                          onMainColorChange: (ColorSwatch color) {
                            // Handle main color changes
                          },
                          selectedColor: currentColor,
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Theme.of(context).accentColor),
                            ),
                            onPressed: () => Navigator.pop(context),
                            textColor: appInfo.mainColor,
                            hoverColor: appInfo.mainColor,
                          ),
                          FlatButton(
                            child: Text(
                             "Confirm",
                              style: TextStyle(color: Theme.of(context).accentColor),
                            ),
                            onPressed: () {
                              appInfo.mainColor = currentColor;
                              Navigator.pop(context);
                            },
                            textColor: appInfo.mainColor,
                            hoverColor: appInfo.mainColor,
                          ),
                        ],
                      );
                    }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 70),
                  child: Text(
                    "Gestures",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).accentColor,
                  secondary: Icon(Icons.star),
                  title: Text('Quick starred gesture'),
                  subtitle: Text("If enabled, you can just double tap on a note to star it"),
                  value: appInfo.isQuickStarredGestureOn,
                  onChanged: (value) => appInfo.isQuickStarredGestureOn = value,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 70),
                  child: Text(
                    "About",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text("About PotatoNotes"),
                  onTap: () => showNoteAboutDialog(),
                ),
                ListTile(
                  leading: Icon(Icons.code),
                  title: Text("PotatoNotes source code"),
                  onTap: () => launchUrl("https://github.com/HrX03/PotatoNotes"),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 70),
                  child: Text(
                    "Developer options",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).accentColor,
                  secondary: Icon(Icons.label),
                  title: Text('Show id labels'),
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
                    if(easterEggCounter == 9) {
                      easterEggCounter = 0;
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EasterEggRoute()));
                    } else easterEggCounter++;
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                      fit: BoxFit.fill,
                        image: AssetImage('assets/notes_round.png'),
                      ),
                    )
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
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 29, right: 29),
                child: Text("Developed and mantained by HrX03"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 29, right: 29),
                child: Text("App icon, design and app branding by RshBfn")
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 30, 24, 4),
                child: Row(
                  children: <Widget>[
                    Text(
                      "PotatoProject 2019",
                      style: TextStyle(
                        color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                            .withAlpha(0.5)
                            .toColor(),
                        fontSize: 14
                      ),
                    ),
                    Spacer(),
                    Text(
                      "v0.5.0-1",
                      style: TextStyle(
                        color: HSLColor.fromColor(Theme.of(context).textTheme.title.color)
                            .withAlpha(0.5)
                            .toColor(),
                        fontSize: 14
                      ),
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
      }
    );
  }
}