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

AppDatabase db;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = AppDatabase(constructDb());
  setupLocator();
  runApp(PotatoNotes());
}

class PotatoNotes extends StatelessWidget {
  static final EventChannel accentStreamChannel =
      EventChannel('potato_notes_accents');

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
          final prefs = Provider.of<Preferences>(context);

          Loggy.generateAppLabel();
          Loggy.setLogLevel(prefs.logLevel);

          return StreamBuilder(
            stream: accentStreamChannel.receiveBroadcastStream(),
            initialData: Colors.blueAccent.value,
            builder: (context, snapshot) {
              print("bruh");
              Themes themes = Themes(Color(snapshot.data));

              return MaterialApp(
                title: "PotatoNotes",
                theme: themes.light,
                darkTheme: prefs.useAmoled ? themes.black : themes.dark,
                builder: (context, child) {
                  appInfo.updateIllustrations();

                  return child;
                },
                themeMode: prefs.themeMode,
                home: MainPage(),
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
