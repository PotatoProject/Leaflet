import 'package:moor/backends.dart';
import 'package:moor/moor_web.dart';

QueryExecutor constructDb({bool logStatements = false}) {
  return WebDatabase.withStorage(
    MoorWebStorage.indexedDbIfSupported('notes'),
    logStatements: logStatements,
  );
}
