// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPayload _$NotificationPayloadFromJson(Map<String, dynamic> json) =>
    NotificationPayload(
      id: json['id'] as int,
      noteId: json['noteId'] as String,
      action: $enumDecode(_$NotificationActionEnumMap, json['action']),
    );

Map<String, dynamic> _$NotificationPayloadToJson(
        NotificationPayload instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noteId': instance.noteId,
      'action': _$NotificationActionEnumMap[instance.action]!,
    };

const _$NotificationActionEnumMap = {
  NotificationAction.pin: 'pin',
  NotificationAction.reminder: 'reminder',
};
