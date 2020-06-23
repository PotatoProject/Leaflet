import 'package:get_it/get_it.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/preferences.dart';

import 'main.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<Preferences>(Preferences());
  locator.registerLazySingleton<NoteHelper>(() => db.noteHelper);
}
