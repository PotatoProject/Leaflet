import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor constructDb({bool logStatements = false}) {
  return LazyDatabase(() async {
    return WebDatabase.withStorage(
      await DriftWebStorage.indexedDbIfSupported('db'),
      logStatements: logStatements,
    );
  });
}
