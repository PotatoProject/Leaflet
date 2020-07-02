import 'package:json_annotation/json_annotation.dart';

part 'notification_payload.g.dart';

@JsonSerializable()
class NotificationPayload {

  String noteId;
  NotificationAction action;
  int notificationId;

  NotificationPayload({
    this.noteId,
    this.action,
    this.notificationId
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPayloadToJson(this);
}

enum NotificationAction {
  PIN,
  REMINDER,
}
