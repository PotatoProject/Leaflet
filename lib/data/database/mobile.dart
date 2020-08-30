import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:sqflite/sqflite.dart';

QueryExecutor constructDb({bool logStatements = false}) {
  if (Platform.isIOS || Platform.isAndroid) {
    final executor = LazyDatabase(() async {
      final dataDir = await getDatabasesPath();
      final dbFile = File(p.join(dataDir, 'notes.sqlite'));
      return VmDatabase(dbFile, logStatements: logStatements);
    });
    return executor;
  }
  if (Platform.isMacOS || Platform.isLinux) {
    final executor = LazyDatabase(() async {
      final dataDir = await pathProvider.getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dataDir.path, '.notes.sqlite'));
      return VmDatabase(dbFile, logStatements: logStatements);
    });
    return executor;
  }
  // if (Platform.isWindows) {
  //   final file = File('db.sqlite');
  //   return Database(VMDatabase(file, logStatements: logStatements));
  // }
  return VmDatabase.memory(logStatements: logStatements);
}
