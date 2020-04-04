import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'reminder_list.g.dart';

@JsonSerializable()
class ReminderList {
  List<DateTime> reminders;

  ReminderList(this.reminders);

  factory ReminderList.fromJson(Map<String, dynamic> json) =>
      _$ReminderListFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderListToJson(this);
}

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
