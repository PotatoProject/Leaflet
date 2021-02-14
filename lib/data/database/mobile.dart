import 'dart:ffi';
import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:sqflite/sqflite.dart';
import 'package:sqlite3/open.dart';

QueryExecutor constructDb({bool logStatements = false}) {
  open.overrideFor(OperatingSystem.windows, _openOnWindows);

  if (Platform.isIOS || Platform.isAndroid) {
    final LazyDatabase executor = LazyDatabase(() async {
      final String dataDir = await getDatabasesPath();
      final File dbFile = File(p.join(dataDir, 'notes.sqlite'));
      return VmDatabase(dbFile, logStatements: logStatements);
    });
    return executor;
  }

  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    final LazyDatabase executor = LazyDatabase(() async {
      final Directory dataDir =
          await pathProvider.getApplicationSupportDirectory();
      final File dbFile = File(p.join(dataDir.path, 'notes.sqlite'));
      return VmDatabase(dbFile, logStatements: logStatements);
    });
    return executor;
  }
  return VmDatabase.memory(logStatements: logStatements);
}

DynamicLibrary _openOnWindows() {
  final libraryNextToScript = File('sqlite3.dll');
  return DynamicLibrary.open(libraryNextToScript.path);
}
