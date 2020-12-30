// GENERATED CODE - DO NOT MODIFY BY HAND

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
  )..status = _$enumDecode(_$QueueItemStatusEnumMap, json['status']);
}

Map<String, dynamic> _$DeleteQueueItemToJson(DeleteQueueItem instance) =>
    <String, dynamic>{
      'status': _$QueueItemStatusEnumMap[instance.status],
      'localPath': instance.localPath,
      'savedImage': instance.savedImage,
      'storageLocation': _$StorageLocationEnumMap[instance.storageLocation],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source)
      .key;
  return value;
}

const _$StorageLocationEnumMap = {
  StorageLocation.LOCAL: 'LOCAL',
  StorageLocation.IMGUR: 'IMGUR',
  StorageLocation.SYNC: 'SYNC',
};

const _$QueueItemStatusEnumMap = {
  QueueItemStatus.PENDING: 'PENDING',
  QueueItemStatus.ONGOING: 'ONGOING',
  QueueItemStatus.COMPLETE: 'COMPLETE',
};
