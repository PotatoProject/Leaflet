import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

QueryExecutor constructDb({bool logStatements = false}) {
  if (Platform.isIOS || Platform.isAndroid) {
    final executor = LazyDatabase(() async {
      final dataDir = await getDatabasesPath();
      final dbFile = File(p.join(dataDir, 'notes_database.db'));
      return VmDatabase(dbFile, logStatements: logStatements);
    });
    return executor;
  } else return null;
}