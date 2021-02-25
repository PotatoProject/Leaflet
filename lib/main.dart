import 'package:crayola/crayola.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/locales/generated_asset_loader.g.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/locales/locales.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/shared_prefs.dart';
import 'package:potato_notes/internal/themes.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/base_page.dart';
import 'package:potato_notes/routes/splash_page.dart';
import 'package:potato_notes/widget/notes_app.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:worker_manager/worker_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (DeviceInfo.isDesktop) {
    sqfliteFfiInit();
  }
  //Executor().warmUp(log: kDebugMode);
  GestureBinding.instance.resamplingEnabled = true;
  await SharedPrefs.init();
  final AppDatabase _db = AppDatabase(
    AppDatabase.constructDb(logStatements: kDebugMode),
  );
  Loggy.generateAppLabel();
  initProviders(_db);

  runApp(
    EasyLocalization(
      supportedLocales: Locales.supported,
      fallbackLocale: Locale("en", "US"),
      useFallbackTranslations: true,
      assetLoader: GeneratedAssetLoader(),
      path: "assets/locales",
      child: SplashPage(
        child: PotatoNotes(),
      ),
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

        final Themes themes = Themes(accentColor.withOpacity(1));

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
