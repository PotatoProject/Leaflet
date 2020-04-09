import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/routes/main_page.dart';
import 'package:provider/provider.dart';
import 'package:spicy_components/spicy_components.dart';

List<Note> initialNotes = [];

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initialNotes = await AppDatabase().noteHelper.listNotes();
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
          value: AppInfoProvider(context),
        ),
        ChangeNotifierProvider.value(
          value: Preferences(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final appInfo = Provider.of<AppInfoProvider>(context);

          appInfo.barManager.lightNavBarColor =
              SpicyThemes.light(appInfo.mainColor).cardColor;
          appInfo.barManager.darkNavBarColor =
              SpicyThemes.dark(appInfo.mainColor).cardColor;
          appInfo.barManager.lightIconColor = Brightness.light;
          appInfo.barManager.darkIconColor = Brightness.dark;
          appInfo.barManager.updateColors();
          appInfo.updateIllustrations();

          return MaterialApp(
            title: "PotatoNotes",
            theme: SpicyThemes.light(appInfo.mainColor),
            darkTheme: SpicyThemes.dark(appInfo.mainColor),
            home: MainPage(initialNotes: initialNotes),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
