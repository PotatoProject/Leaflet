import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl_standalone.dart';
import 'package:path/path.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/search_filters.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/notes_main_page_route.dart';
import 'package:potato_notes/routes/welcome_route.dart';
import 'package:potato_notes/ui/no_glow_scroll_behavior.dart';
import 'package:potato_notes/ui/themes.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> database;
AppInfoProvider appInfo;
SearchFiltersProvider searchFilters;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = openDatabase(
    join(await getDatabasesPath(), 'notes_database.db'),
    onCreate: (db, version) {
      return db.execute(
        """
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY,
            title TEXT,
            content TEXT,
            isStarred INTEGER,
            date INTEGER,
            color INTEGER,
            imagePath TEXT,
            isList INTEGER,
            listParseString TEXT,
            reminders TEXT,
            hideContent INTEGER,
            pin TEXT,
            password TEXT,
            isDeleted INTEGER,
            isArchived INTEGER
          )
        """,
      );
    },
    onOpen: (db) async {
      List<String> columnsToAdd = [
        "ALTER TABLE notes ADD COLUMN id INTEGER PRIMARY KEY",
        "ALTER TABLE notes ADD COLUMN title TEXT",
        "ALTER TABLE notes ADD COLUMN content TEXT",
        "ALTER TABLE notes ADD COLUMN isStarred INTEGER",
        "ALTER TABLE notes ADD COLUMN date INTEGER",
        "ALTER TABLE notes ADD COLUMN color INTEGER",
        "ALTER TABLE notes ADD COLUMN imagePath TEXT",
        "ALTER TABLE notes ADD COLUMN isList INTEGER",
        "ALTER TABLE notes ADD COLUMN listParseString TEXT",
        "ALTER TABLE notes ADD COLUMN reminders TEXT",
        "ALTER TABLE notes ADD COLUMN hideContent INTEGER",
        "ALTER TABLE notes ADD COLUMN pin TEXT",
        "ALTER TABLE notes ADD COLUMN password TEXT",
        "ALTER TABLE notes ADD COLUMN isDeleted INTEGER",
        "ALTER TABLE notes ADD COLUMN isArchived INTEGER",
      ];

      for (int i = 0; i < columnsToAdd.length; i++) {
        try {
          await db.execute(columnsToAdd[i]);
        } on DatabaseException {
          //do nothing
        }
      }
    },
    version: 5,
  );

  print(await findSystemLocale());

  Preferences preferences = await Preferences().create();
  List<Note> noteList = await NoteHelper.getNotes(
      preferences.getSortMode(), NotesReturnMode.NORMAL);
  bool showWelcomeScreen = !preferences.getWelcomeScreenSeen();

  runApp(NotesRoot(noteList: noteList, showWelcomeScreen: showWelcomeScreen));
}

class NotesRoot extends StatelessWidget {
  final List<Note> noteList;
  final bool showWelcomeScreen;

  NotesRoot({@required this.noteList, this.showWelcomeScreen});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppInfoProvider>.value(
          value: AppInfoProvider(),
        ),
        ChangeNotifierProvider<SearchFiltersProvider>.value(
          value: SearchFiltersProvider(),
        ),
      ],
      child: Builder(builder: (context) {
        appInfo = Provider.of<AppInfoProvider>(context);
        searchFilters = Provider.of<SearchFiltersProvider>(context);

        if (appInfo.followSystemTheme) {
          switch (appInfo.systemBrightness) {
            case Brightness.light:
              Utils.changeSystemBarsColors(
                  CustomThemes.light(appInfo).scaffoldBackgroundColor,
                  Brightness.dark);
              break;
            case Brightness.dark:
              if (appInfo.darkThemeMode == 0) {
                Utils.changeSystemBarsColors(
                    CustomThemes.dark(appInfo).scaffoldBackgroundColor,
                    Brightness.light);
              } else {
                Utils.changeSystemBarsColors(
                    CustomThemes.black(appInfo).scaffoldBackgroundColor,
                    Brightness.light);
              }
              break;
          }
        } else {
          switch (appInfo.themeMode) {
            case 0:
              Utils.changeSystemBarsColors(
                  CustomThemes.light(appInfo).scaffoldBackgroundColor,
                  Brightness.dark);
              break;
            case 1:
              Utils.changeSystemBarsColors(
                  CustomThemes.dark(appInfo).scaffoldBackgroundColor,
                  Brightness.light);
              break;
            case 2:
              Utils.changeSystemBarsColors(
                  CustomThemes.black(appInfo).scaffoldBackgroundColor,
                  Brightness.light);
              break;
          }
        }

        List<Locale> supportedLocales = [];
        for (int i = 0; i < AppInfoProvider.supportedLocales.length; i++) {
          if (AppInfoProvider.supportedLocales.contains("_")) {
            List<String> localeParts =
                AppInfoProvider.supportedLocales[i].split("_");
            supportedLocales.add(Locale.fromSubtags(
                languageCode: localeParts[0], countryCode: localeParts[1]));
          } else {
            supportedLocales.add(Locale(AppInfoProvider.supportedLocales[i]));
          }
        }

        return MaterialApp(
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: supportedLocales,
          builder: (context, child) => ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: child,
          ),
          home: showWelcomeScreen ? WelcomeRoute() : NotesMainPageRoute(),
          debugShowCheckedModeBanner: false,
          locale: appInfo.customLocale != -1
              ? supportedLocales[appInfo.customLocale]
              : null,
          localeResolutionCallback:
              (Locale locale, Iterable<Locale> supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (locale.toString().split("_")[0] == supportedLocale.toString()) {
                return supportedLocale;
              }  
            }
            print("The " + locale.toString() + " is not supported");
            print("Defaulting to the en locale");
            return Locale("en");
          },
          theme: appInfo.followSystemTheme
              ? CustomThemes.light(appInfo)
              : (appInfo.themeMode == 0
                  ? CustomThemes.light(appInfo)
                  : appInfo.themeMode == 1
                      ? CustomThemes.dark(appInfo)
                      : CustomThemes.black(appInfo)),
          darkTheme: appInfo.darkThemeMode == 0
              ? CustomThemes.dark(appInfo)
              : CustomThemes.black(appInfo),
          themeMode:
              appInfo.followSystemTheme ? ThemeMode.system : ThemeMode.light,
          title: 'Notes',
          color: appInfo.mainColor,
        );
      }),
    );
  }
}
