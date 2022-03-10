import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/generated_asset_loader.g.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/locales/locales.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/home_page.dart';
import 'package:potato_notes/routes/splash_page.dart';
import 'package:potato_notes/widget/notes_app.dart';
import 'package:potato_notes/widget/window_frame.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await windowManager.ensureInitialized();
  await initKeystore();
  GestureBinding.instance!.resamplingEnabled = true;
  await initCriticalProviders();

  if (DeviceInfo.isDesktop) {
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle("hidden");
      await windowManager.setMinimumSize(const Size(360, 520));
      await windowManager.show();
      await windowManager.setSkipTaskbar(false);
    });
  }

  runApp(
    EasyLocalization(
      supportedLocales: Locales.supported,
      fallbackLocale: const Locale("en", "US"),
      useFallbackTranslations: true,
      assetLoader: GeneratedAssetLoader(),
      path: "assets/locales",
      child: SplashPage(
        child: PotatoNotes(),
        future: () => initProviders(),
      ),
    ),
  );
}

class PotatoNotes extends StatefulWidget {
  @override
  State<PotatoNotes> createState() => _PotatoNotesState();
}

class _PotatoNotesState extends State<PotatoNotes> {
  @override
  void initState() {
    super.initState();
    monet.addListener(() {
      appInfo.refreshThemes();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        Loggy.instance.logLevel = LogLevel.values[prefs.logLevel];

        return NotesApp(
          title: "Leaflet",
          theme: appInfo.lightTheme,
          darkTheme: appInfo.darkTheme,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          scrollBehavior: const MaterialScrollBehavior(
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
          ),
          builder: (context, child) {
            if (appInfo.quickActions == null && !DeviceInfo.isDesktopOrWeb) {
              appInfo.quickActions = const QuickActions();

              appInfo.quickActions!.setShortcutItems([
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

            deviceInfo.updateDeviceInfo(context.mediaQuery, true);

            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            SystemChrome.setSystemUIOverlayStyle(
              context.theme.appBarTheme.systemOverlayStyle!,
            );

            return WindowFrame(child: child!);
          },
          themeMode: prefs.themeMode,
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
          color: Utils.getMainColorFromTheme(),
        );
      },
    );
  }
}
