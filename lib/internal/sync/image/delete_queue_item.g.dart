// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'delete_queue_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteQueueItem _$DeleteQueueItemFromJson(Map<String, dynamic> json) {
  return DeleteQueueItem(
    localPath: json['localPath'] as String,
    savedImage: SavedImage.fromJson(json['savedImage'] as Map<String, dynamic>),
    storageLocation:
        _$enumDecode(_$StorageLocationEnumMap, json['storageLocation']),
  )
    ..status = _$enumDecode(_$QueueItemStatusEnumMap, json['status'])
    ..progress = (json['progress'] as num).toDouble();
}

Map<String, dynamic> _$DeleteQueueItemToJson(DeleteQueueItem instance) =>
    <String, dynamic>{
      'status': _$QueueItemStatusEnumMap[instance.status],
      'progress': instance.progress,
      'localPath': instance.localPath,
      'savedImage': instance.savedImage,
      'storageLocation': _$StorageLocationEnumMap[instance.storageLocation],
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

const _$StorageLocationEnumMap = {
  StorageLocation.LOCAL: 'LOCAL',
  StorageLocation.SYNC: 'SYNC',
};

const _$QueueItemStatusEnumMap = {
  QueueItemStatus.PENDING: 'PENDING',
  QueueItemStatus.ONGOING: 'ONGOING',
  QueueItemStatus.COMPLETE: 'COMPLETE',
};
