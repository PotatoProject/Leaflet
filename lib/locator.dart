import 'package:get_it/get_it.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/sync/controller/account_controller.dart';
import 'package:potato_notes/internal/sync/controller/note_controller.dart';
import 'package:potato_notes/internal/sync/sync_routine.dart';

import 'main.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<Preferences>(Preferences());
  locator.registerLazySingleton<NoteHelper>(() => NoteHelper(db));
  locator.registerLazySingleton<SyncRoutine>(() => SyncRoutine());
  locator.registerLazySingleton<NoteController>(() => NoteController());
  locator.registerLazySingleton<AccountController>(() => AccountController());
}
