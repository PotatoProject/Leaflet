import 'package:json_annotation/json_annotation.dart';

part 'notification_payload.g.dart';

@JsonSerializable()
class NotificationPayload {
  int id;
  String noteId;
  NotificationAction action;

  NotificationPayload({
    required this.id,
    required this.noteId,
    required this.action,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPayloadToJson(this);
}

enum NotificationAction {
  PIN,
  REMINDER,
}
