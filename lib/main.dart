import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/database/shared.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/themes.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/internal/android_xml_asset_loader.dart';
import 'package:potato_notes/routes/main_page.dart';
import 'package:quick_actions/quick_actions.dart';

AppDatabase db;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = AppDatabase(constructDb());
  helper = db.noteHelper;
  runApp(
    ProviderScope(
      child: EasyLocalization(
        child: PotatoNotes(),
        supportedLocales: [
          Locale("de", "DE"),
          Locale("en", "US"),
          Locale("es", "ES"),
          Locale("fr", "FR"),
          Locale("hu", "HU"),
          Locale("it", "IT"),
          Locale("nl", "NL"),
          Locale("pl", "PL"),
          Locale("pt", "BR"),
          Locale("ro", "RO"),
          Locale("ru", "RU"),
          Locale("tr", "TR"),
          Locale("uk", "UK"),
          Locale("zh", "CN"),
        ],
        fallbackLocale: Locale("en", "US"),
        assetLoader: AndroidXmlAssetLoader(
          [
            "common",
            "about_page",
            "draw_page",
            "main_page",
            "note_page",
            "search_page",
            "settings_page",
            "setup_page",
          ],
        ),
        path: "assets/locales",
        preloaderColor: Colors.transparent,
      ),
    ),
  );
}

class PotatoNotes extends StatefulWidget {
  @override
  _PotatoNotesState createState() => _PotatoNotesState();
}

class _PotatoNotesState extends State<PotatoNotes> {
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
          bool canUseSystemAccent = true;

          if (kIsWeb) {
            canUseSystemAccent = false;
          } else {
            if ((snapshot.data == -1 && Platform.isAndroid) ||
                !Platform.isAndroid) {
              canUseSystemAccent = false;
            }
          }

          if (prefs.useCustomAccent || !canUseSystemAccent) {
            accentColor = prefs.customAccent ?? Utils.defaultAccent;
          } else {
            accentColor = Color(snapshot.data);
          }

          Themes themes = Themes(accentColor.withOpacity(1));

          return MaterialApp(
            title: "PotatoNotes",
            theme: themes.light,
            darkTheme: prefs.useAmoled ? themes.black : themes.dark,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: [
              ...context.localizationDelegates,
              LocaleNamesLocalizationsDelegate(),
            ],
            locale: context.locale,
            builder: (context, child) {
              if (appInfo.quickActions == null && !kIsWeb) {
                appInfo.quickActions = QuickActions();

                appInfo.quickActions.setShortcutItems([
                  ShortcutItem(
                    type: 'new_text',
                    localizedTitle: LocaleStrings.common.newNote,
                    icon: 'note_shortcut',
                  ),
                  ShortcutItem(
                    type: 'new_list',
                    localizedTitle: LocaleStrings.common.newList,
                    icon: 'list_shortcut',
                  ),
                  ShortcutItem(
                    type: 'new_image',
                    localizedTitle: LocaleStrings.common.newImage,
                    icon: 'image_shortcut',
                  ),
                  ShortcutItem(
                    type: 'new_drawing',
                    localizedTitle: LocaleStrings.common.newDrawing,
                    icon: 'drawing_shortcut',
                  ),
                ]);
              }

              appInfo.updateIllustrations(Theme.of(context).brightness);

              deviceInfo.updateDeviceInfo(
                MediaQuery.of(context),
                canUseSystemAccent,
              );

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

  void _initProviders(Reader read) async {
    if (appInfo == null) {
      appInfo = read(Provider((_) => AppInfo()));
    }
    if (deviceInfo == null) {
      deviceInfo = read(Provider((_) => DeviceInfo()));
    }

    if (prefs == null) {
      prefs = read(ChangeNotifierProvider((_) => Preferences()));
      prefs.addListener(() => setState(() {}));
    }
  }
}
