
import 'dart:convert';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:potato_notes/data/model/reminder_list.dart';

class ReminderListConverter extends TypeConverter<ReminderList, String> {
  const ReminderListConverter();
  @override
  ReminderList mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return ReminderList.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String mapToSql(ReminderList value) {
    if (value == null) {
      return null;
    }

    return json.encode(value.toJson());
  }
}