import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite3/open.dart';

QueryExecutor constructDb({bool logStatements = false}) {
  open.overrideFor(
    OperatingSystem.windows,
    () => DynamicLibrary.open('sqlcipher.dll'),
  );
  open.overrideFor(
    OperatingSystem.android,
    () => DynamicLibrary.open('libsqlcipher.so'),
  );
  sqfliteFfiInit();

  final LazyDatabase executor = LazyDatabase(() async {
    final Directory dataDir = DeviceInfo.isDesktop
        ? await path_provider.getApplicationSupportDirectory()
        : Directory(await getDatabasesPath());
    final File dbFile = File(p.join(dataDir.path, 'notes.sqlite'));

    String? databaseKey = await keystore.getDatabaseKey();
    if (databaseKey == null) {
      final List<int> key =
          List.generate(64, (_) => Random.secure().nextInt(255));
      final String hexKey = hex(key);
      await keystore.setDatabaseKey(hexKey);
      databaseKey = hexKey;
    }

    return VmDatabase(
      dbFile,
      logStatements: logStatements,
      setup: (database) {
        database.execute("PRAGMA key = '$databaseKey';");
      },
    );
  });
  return executor;
}
