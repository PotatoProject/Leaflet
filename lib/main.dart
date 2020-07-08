import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/database/shared.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/themes.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/main_page.dart';
import 'package:quick_actions/quick_actions.dart';

AppDatabase db;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = AppDatabase(constructDb());
  helper = db.noteHelper;
  runApp(
    ProviderScope(
      child: PotatoNotes(),
    ),
  );
}

class PotatoNotes extends StatelessWidget {
  static final EventChannel accentStreamChannel =
      EventChannel('potato_notes_accents');

  @override
  Widget build(BuildContext context) {
    return Consumer((context, read) {
      _initProviders(read);

      Loggy.generateAppLabel();
      Loggy.setLogLevel(prefs.logLevel);

      return StreamBuilder(
        stream: !kIsWeb
            ? accentStreamChannel.receiveBroadcastStream()
            : Stream.empty(),
        initialData: Colors.blueAccent.value,
        builder: (context, snapshot) {
          Color accentColor;

          if (prefs.useCustomAccent || kIsWeb) {
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
              if (appInfo.quickActions == null && !kIsWeb) {
                appInfo.quickActions = QuickActions();

                appInfo.quickActions.setShortcutItems([
                  const ShortcutItem(
                      type: 'new_text',
                      localizedTitle: 'New note',
                      icon: 'note_shortcut'),
                  const ShortcutItem(
                      type: 'new_list',
                      localizedTitle: 'New list',
                      icon: 'list_shortcut'),
                  const ShortcutItem(
                      type: 'new_image',
                      localizedTitle: 'New image',
                      icon: 'image_shortcut'),
                  const ShortcutItem(
                      type: 'new_drawing',
                      localizedTitle: 'New drawing',
                      icon: 'drawing_shortcut'),
                ]);
              }

              appInfo.updateIllustrations(Theme.of(context).brightness);

              return child;
            },
            themeMode: prefs.themeMode,
            home: MainPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      );
    });
  }

  void _initProviders(Reader read) {
    if (appInfo == null) {
      appInfo = read(ChangeNotifierProvider((_) => AppInfoProvider()));
    }

    if (prefs == null) {
      prefs = read(ChangeNotifierProvider((_) => Preferences()));
    }
  }
}
