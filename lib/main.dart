import 'package:flutter/material.dart';
import 'package:potato_notes/database/bloc/bloc_provider.dart';
import 'package:potato_notes/database/bloc/notes_bloc.dart';
import 'package:potato_notes/routes/main_page.dart';

main() => runApp(PotatoNotes());

class PotatoNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PotatoNotes",
      home: BlocProvider(
        child: MainPage(),
        bloc: NotesBloc()
      ),
    );
  }
}