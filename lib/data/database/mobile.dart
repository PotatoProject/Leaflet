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
    final executor = LazyDatabase(() async {
      final dataDir = await getDatabasesPath();
      final dbFile = File(p.join(dataDir, 'notes.sqlite'));
      return VmDatabase(dbFile, logStatements: logStatements);
    });
    return executor;
  }

  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    final executor = LazyDatabase(() async {
      final dataDir = await pathProvider.getApplicationSupportDirectory();
      final dbFile = File(p.join(dataDir.path, 'notes.sqlite'));
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
