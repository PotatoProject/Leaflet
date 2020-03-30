// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderList _$ReminderListFromJson(Map<String, dynamic> json) {
  return ReminderList(
    (json['reminders'] as List)
        ?.map((e) => e == null ? null : DateTime.parse(e as String))
        ?.toList(),
  );
}

Map<String, dynamic> _$ReminderListToJson(ReminderList instance) =>
    <String, dynamic>{
      'reminders':
          instance.reminders?.map((e) => e?.toIso8601String())?.toList(),
    };
