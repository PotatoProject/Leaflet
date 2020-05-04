import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/routes/main_page.dart';
import 'package:provider/provider.dart';
import 'package:spicy_components/spicy_components.dart';

List<Note> initialNotes = [];

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initialNotes = await AppDatabase().noteHelper.listNotes(ReturnMode.NORMAL);
  runApp(PotatoNotes());
}

class PotatoNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(
          value: AppDatabase(),
        ),
        Provider.value(
          value: AppDatabase().noteHelper,
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
                home: MainPage(initialNotes: initialNotes),
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        ),
      ),
    );
  }
}
