import 'package:moor/moor.dart';
import 'package:moor/moor_web.dart';

QueryExecutor constructDb({bool logStatements = false}) {
  return LazyDatabase(() async {
    return WebDatabase.withStorage(
      await MoorWebStorage.indexedDbIfSupported('db'),
      logStatements: logStatements,
    );
  });
}
