import 'package:crayola/crayola.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/database/shared.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/locales/generated_asset_loader.g.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/locales/locales.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/shared_prefs.dart';
import 'package:potato_notes/internal/themes.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/base_page.dart';
import 'package:potato_notes/widget/notes_app.dart';
import 'package:quick_actions/quick_actions.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  await SharedPrefs.init();
  if (DeviceInfo.isAndroid) {
    await FlutterDownloader.initialize(
      debug: kDebugMode,
    );
  }
  AppDatabase _db = AppDatabase(constructDb(logStatements: kDebugMode));
  helper = _db.noteHelper;
  tagHelper = _db.tagHelper;
  if (DeviceInfo.isAndroid) {
    Loggy.generateAppLabel();
  }

  final sharedPrefs = SharedPrefs.instance;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  final isDarkSystemTheme = data.platformBrightness == Brightness.dark;
  final themeMode = await sharedPrefs.getThemeMode();
  final useAmoled = await sharedPrefs.getUseAmoled();

  Color color = Themes.lightSecondaryColor;

  if (themeMode == ThemeMode.system && isDarkSystemTheme ||
      themeMode == ThemeMode.dark) {
    color = useAmoled ? Themes.blackSecondaryColor : Themes.darkSecondaryColor;
  }

  runApp(
    EasyLocalization(
      child: PotatoNotes(),
      supportedLocales: Locales.supported,
      fallbackLocale: Locale("en", "US"),
      assetLoader: GeneratedAssetLoader(),
      path: "assets/locales",
      preloaderColor: color,
    ),
  );
}

class PotatoNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        Loggy.setLogLevel(prefs.logLevel);

        Color accentColor;
        bool canUseSystemAccent = true;

        if (DeviceInfo.isAndroid) {
          if (appInfo.accentData == -1) {
            canUseSystemAccent = false;
          } else {
            canUseSystemAccent = true;
          }
        } else {
          canUseSystemAccent = false;
        }

        if (prefs.useCustomAccent || !canUseSystemAccent) {
          accentColor = prefs.customAccent ?? Utils.defaultAccent;
        } else {
          accentColor = Color(appInfo.accentData);
        }

        Themes themes = Themes(accentColor.withOpacity(1));

        return NotesApp(
          title: "Leaflet",
          theme: themes.light,
          darkTheme: prefs.useAmoled ? themes.black : themes.dark,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          builder: (context, child) {
            if (DeviceInfo.isMacOS) {
              Crayola.setTitleVisibility(false);
            }

            if (appInfo.quickActions == null && !DeviceInfo.isDesktopOrWeb) {
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

            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ),
            );

            return child;
          },
          themeMode: prefs.themeMode,
          home: BasePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
