// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'saved_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedImage _$SavedImageFromJson(Map<String, dynamic> json) {
  return SavedImage(
    json['id'] as String,
    _$enumDecode(_$StorageLocationEnumMap, json['storageLocation']),
    json['hash'] as String?,
    json['fileExtension'] as String?,
    json['encrypted'] as bool,
    (json['width'] as num?)?.toDouble(),
    (json['height'] as num?)?.toDouble(),
  )
    ..blurHash = json['blurHash'] as String?
    ..uploaded = json['uploaded'] as bool;
}

Map<String, dynamic> _$SavedImageToJson(SavedImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storageLocation': _$StorageLocationEnumMap[instance.storageLocation],
      'hash': instance.hash,
      'blurHash': instance.blurHash,
      'fileExtension': instance.fileExtension,
      'encrypted': instance.encrypted,
      'width': instance.width,
      'height': instance.height,
      'uploaded': instance.uploaded,
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
