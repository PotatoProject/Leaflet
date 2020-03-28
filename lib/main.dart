import 'package:flutter/material.dart';
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
          child: MaterialApp(
            title: "PotatoNotes",
            theme: SpicyThemes.light(Colors.orangeAccent),
            home: MainPage(),
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}