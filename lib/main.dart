import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/routes/main_page.dart';
import 'package:provider/provider.dart';
import 'package:spicy_components/spicy_components.dart';

import 'data/database/shared.dart';

AppDatabase db;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = AppDatabase(constructDb());
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
          value: AppInfoProvider(context),
          child: Builder(
            builder: (context) {
              final appInfo = Provider.of<AppInfoProvider>(context);
              final prefs = Provider.of<Preferences>(context);

              return MaterialApp(
                title: "PotatoNotes",
                theme: SpicyThemes.light(appInfo.mainColor),
                darkTheme: prefs.useAmoled
                    ? SpicyThemes.black(appInfo.mainColor)
                    : SpicyThemes.dark(appInfo.mainColor),
                builder: (context, child) {
                  appInfo.barManager.lightNavBarColor =
                      SpicyThemes.light(appInfo.mainColor).cardColor;
                  appInfo.barManager.darkNavBarColor = prefs.useAmoled
                      ? SpicyThemes.black(appInfo.mainColor).cardColor
                      : SpicyThemes.dark(appInfo.mainColor).cardColor;
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
