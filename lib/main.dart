import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/database/shared.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/themes.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/locator.dart';
import 'package:potato_notes/routes/main_page.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';

AppDatabase db;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = AppDatabase(constructDb());
  setupLocator();
  runApp(PotatoNotes());
}

class PotatoNotes extends StatelessWidget {
  static final EventChannel accentStreamChannel =
      EventChannel('potato_notes_accents');

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AppInfoProvider(context),
        ),
        ChangeNotifierProvider.value(
          value: Preferences(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final appInfo = Provider.of<AppInfoProvider>(context);
          final prefs = Provider.of<Preferences>(context);

          Loggy.generateAppLabel();
          Loggy.setLogLevel(prefs.logLevel);

          return StreamBuilder(
            stream: accentStreamChannel.receiveBroadcastStream(),
            initialData: Colors.blueAccent.value,
            builder: (context, snapshot) {
              Color accentColor;

              if(prefs.useCustomAccent) {
                accentColor = prefs.customAccent ?? Utils.defaultAccent;
              } else {
                accentColor = Color(snapshot.data);
              }

              Themes themes = Themes(accentColor);

              return MaterialApp(
                title: "PotatoNotes",
                theme: themes.light,
                darkTheme: prefs.useAmoled ? themes.black : themes.dark,
                builder: (context, child) {
                  if(appInfo.quickActions == null) {
                    appInfo.quickActions = QuickActions();

                    appInfo.quickActions.setShortcutItems([
                      const ShortcutItem(type: 'new_text', localizedTitle: 'New note', icon: 'note_shortcut'),
                      const ShortcutItem(type: 'new_list', localizedTitle: 'New list', icon: 'list_shortcut'),
                      const ShortcutItem(type: 'new_image', localizedTitle: 'New image', icon: 'image_shortcut'),
                      const ShortcutItem(type: 'new_drawing', localizedTitle: 'New drawing', icon: 'drawing_shortcut'),
                    ]);
                  }
                  appInfo.updateIllustrations();

                  return child;
                },
                themeMode: prefs.themeMode,
                home: MainPage(),
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
