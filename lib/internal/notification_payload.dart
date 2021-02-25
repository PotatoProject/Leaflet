// @dart=2.12

import 'package:json_annotation/json_annotation.dart';

part 'notification_payload.g.dart';

@JsonSerializable()
class NotificationPayload {
  final int id;
  final String noteId;
  final NotificationAction action;

  const NotificationPayload({
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
