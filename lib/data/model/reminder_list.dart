import 'package:json_annotation/json_annotation.dart';

part 'reminder_list.g.dart';

@JsonSerializable()
class ReminderList {
  List<DateTime> reminders;

  ReminderList(this.reminders);

  factory ReminderList.fromJson(Map<String, dynamic> json) =>
      _$ReminderListFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderListToJson(this);
}