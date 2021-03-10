// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'notification_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPayload _$NotificationPayloadFromJson(Map<String, dynamic> json) {
  return NotificationPayload(
    id: json['id'] as int,
    noteId: json['noteId'] as String,
    action: _$enumDecode(_$NotificationActionEnumMap, json['action']),
  );
}

Map<String, dynamic> _$NotificationPayloadToJson(
        NotificationPayload instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noteId': instance.noteId,
      'action': _$NotificationActionEnumMap[instance.action],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$NotificationActionEnumMap = {
  NotificationAction.pin: 'pin',
  NotificationAction.reminder: 'reminder',
};
