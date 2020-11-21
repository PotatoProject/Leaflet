// GENERATED CODE - DO NOT MODIFY BY HAND

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

T _$enumDecode<T>(
  Map<T, Object> enumValues,
  Object? source, {
  T? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  final value = enumValues.entries
      .cast<MapEntry<T, Object>?>()
      .singleWhere((e) => e!.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError(
      '`$source` is not one of the supported values: '
      '${enumValues.values.join(', ')}',
    );
  }
  return value ?? unknownValue!;
}

const _$NotificationActionEnumMap = {
  NotificationAction.PIN: 'PIN',
  NotificationAction.REMINDER: 'REMINDER',
};
