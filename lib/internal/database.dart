import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:drift/backends.dart';
import 'package:flutter/foundation.dart';
import 'package:liblymph/database.dart';
import 'package:path/path.dart' as p;
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';

QueryExecutor constructLeafletDb() {
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

  return constructDb(
    databaseFolder: () async => DeviceInfo.isDesktop
        ? appDirectories.supportDirectory.path
        : await getDatabasesPath(),
    databaseName: databaseFileName,
    databaseKey: () async {
      String? databaseKey = await keystore.getDatabaseKey();
      if (databaseKey == null) {
        final List<int> key =
            List.generate(64, (_) => Random.secure().nextInt(255));
        final String hexKey = hex(key);
        await keystore.setDatabaseKey(hexKey);
        databaseKey = hexKey;
      }

      return databaseKey;
    },
    logStatements: kDebugMode,
  );
}

/// databaseFileName returns the file name to use for the database. We use
/// a different file name in debug builds as windows' implementation of secure
/// keystore keeps debug and release keys seperate.
String get databaseFileName {
  if (kDebugMode) {
    return 'notes_dbg.sqlite';
  }

  if (kProfileMode) {
    return 'notes_profile.sqlite';
  }

  return 'notes.sqlite';
}
