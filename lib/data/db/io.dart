import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';

QueryExecutor constructDb({bool logStatements = false}) {
  applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
  open.overrideFor(
    OperatingSystem.windows,
    () => DynamicLibrary.open('sqlcipher.dll'),
  );
  open.overrideFor(OperatingSystem.linux, () {
    final executableDir = Platform.resolvedExecutable.split('/');
    executableDir.removeLast();

    final libPath = p.join(
      executableDir.join('/'),
      'lib/libsqlcipher.so',
    );

    return DynamicLibrary.open(libPath);
  });
  open.overrideFor(
    OperatingSystem.android,
    openCipherOnAndroid,
  );
  sqfliteFfiInit();

  final LazyDatabase executor = LazyDatabase(() async {
    final Directory dataDir = DeviceInfo.isDesktop
        ? appDirectories.supportDirectory
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
