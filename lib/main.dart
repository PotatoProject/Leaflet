import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/database/shared.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/themes.dart';
import 'package:potato_notes/locator.dart';
import 'package:potato_notes/routes/main_page.dart';
import 'package:provider/provider.dart';
import 'package:spicy_components/spicy_components.dart';

AppDatabase db;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = AppDatabase(constructDb());
  setupLocator();
  locator<Preferences>().loadData();
  runApp(PotatoNotes());
}

class PotatoNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(
          value: db,
        ),
        Provider.value(
          value: db.noteHelper,
        ),
        ChangeNotifierProvider.value(
          value: Preferences(),
        ),
      ],
      child: Builder(
        builder: (context) => ChangeNotifierProvider.value(
          value: AppInfoProvider(),
          child: Builder(
            builder: (context) {
              final appInfo = Provider.of<AppInfoProvider>(context);
              final prefs = locator<Preferences>();

              Loggy.generateAppLabel();
              Loggy.setLogLevel(prefs.logLevel);

              Themes.provideAppInfo(appInfo);

              return MaterialApp(
                title: "PotatoNotes",
                theme: Themes.light,
                darkTheme: prefs.useAmoled
                    ? Themes.black
                    : Themes.dark,
                builder: (context, child) {
                  appInfo.barManager.lightNavBarColor =
                      Themes.light.cardColor;
                  appInfo.barManager.darkNavBarColor = prefs.useAmoled
                      ? Themes.black.cardColor
                      : Themes.dark.cardColor;
                  appInfo.barManager.lightIconColor = Brightness.light;
                  appInfo.barManager.darkIconColor = Brightness.dark;
                  appInfo.barManager.updateColors();
                  appInfo.updateIllustrations();

                  return child;
                },
                themeMode: prefs.themeMode,
                home: MainPage(),
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        ),
      ),
    );
  }
}
