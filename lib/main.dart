import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/database/bloc/bloc_provider.dart';
import 'package:potato_notes/database/bloc/notes_bloc.dart';
import 'package:potato_notes/database/internal/app_info.dart';
import 'package:potato_notes/routes/main_page.dart';
import 'package:provider/provider.dart';
import 'package:spicy_components/spicy_components.dart';

main() => runApp(PotatoNotes());

class PotatoNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: NotesBloc(),
      child: Builder(
        builder: (context) => ChangeNotifierProvider.value(
          value: AppInfoProvider(context),
          child: Builder(
            builder: (context) {
              final appInfo = Provider.of<AppInfoProvider>(context);

              switch(appInfo.systemTheme) {
                case Brightness.light:
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    systemNavigationBarColor: SpicyThemes.light(appInfo.mainColor).cardColor,
                    statusBarColor: Colors.transparent,
                    systemNavigationBarIconBrightness: Brightness.dark,
                    statusBarIconBrightness: Brightness.dark,
                  ));
                  break;
                case Brightness.dark:
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    systemNavigationBarColor: SpicyThemes.dark(appInfo.mainColor).cardColor,
                    statusBarColor: Colors.transparent,
                    systemNavigationBarIconBrightness: Brightness.light,
                    statusBarIconBrightness: Brightness.light,
                  ));
                  break;
              }

              return MaterialApp(
                title: "PotatoNotes",
                theme: SpicyThemes.light(appInfo.mainColor),
                darkTheme: SpicyThemes.dark(appInfo.mainColor),
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