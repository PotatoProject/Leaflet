import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/locale.dart' as intl;
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/home_page.dart';
import 'package:potato_notes/routes/splash_page.dart';
import 'package:potato_notes/widget/notes_app.dart';
import 'package:potato_notes/widget/window_frame.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yatl_flutter/yatl_flutter.dart' hide Locale;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initProvidersInstance();
  await initKeystore();
  GestureBinding.instance.resamplingEnabled = true;
  await initCriticalProviders();

  if (DeviceInfo.isDesktop) {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      await windowManager.setMinimumSize(const Size(360, 520));
      await windowManager.show();
      await windowManager.setSkipTaskbar(false);
    });
  }

  runApp(
    YatlApp(
      core: yatl,
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
          localizationsDelegates: [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            context.localizationsDelegate,
          ],
          locale: prefs.locale,
          builder: (context, child) {
            if (appInfo.quickActions == null && !DeviceInfo.isDesktopOrWeb) {
              appInfo.quickActions = const QuickActions();

              appInfo.quickActions!.setShortcutItems([
                ShortcutItem(
                  type: 'new_text',
                  localizedTitle: strings.common.newNote,
                  icon: 'note_shortcut',
                ),
                ShortcutItem(
                  type: 'new_list',
                  localizedTitle: strings.common.newList,
                  icon: 'list_shortcut',
                ),
                ShortcutItem(
                  type: 'new_image',
                  localizedTitle: strings.common.newImage,
                  icon: 'image_shortcut',
                ),
                ShortcutItem(
                  type: 'new_drawing',
                  localizedTitle: strings.common.newDrawing,
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
