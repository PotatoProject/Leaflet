import 'dart:convert';

import 'package:moor/moor.dart';

class ReminderListConverter extends TypeConverter<List<DateTime>, String> {
  const ReminderListConverter();
  @override
  List<DateTime>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }

    List<dynamic> decoded = json.decode(fromDb);
    return List.generate(
      decoded.length,
      (index) => DateTime.fromMillisecondsSinceEpoch(
        json.decode(decoded[index]),
      ),
    );
  }

  @override
  String? mapToSql(List<DateTime>? value) {
    if (value == null) {
      return null;
    }
    return json.encode(
      List.generate(
        value.length,
        (index) => value[index].millisecondsSinceEpoch,
      ),
    );
  }
}
