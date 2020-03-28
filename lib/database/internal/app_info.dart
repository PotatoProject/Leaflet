import 'package:flutter/material.dart';
import 'package:potato_notes/database/bloc/bloc_provider.dart';
import 'package:potato_notes/database/bloc/notes_bloc.dart';

class AppInfoProvider extends ChangeNotifier {
  AppInfoProvider(BuildContext context) {
    notesBloc = BlocProvider.of<NotesBloc>(context);
  }

  NotesBloc _notesBloc;

  NotesBloc get notesBloc => _notesBloc;

  set notesBloc(NotesBloc newBloc) {
    _notesBloc = newBloc;
    notifyListeners();
  }
}