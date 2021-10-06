// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedImage _$SavedImageFromJson(Map<String, dynamic> json) => SavedImage(
      id: json['id'] as String,
      storageLocation: _$enumDecodeNullable(
              _$StorageLocationEnumMap, json['storageLocation']) ??
          StorageLocation.local,
      hash: json['hash'] as String?,
      fileExtension: json['fileExtension'] as String?,
      encrypted: json['encrypted'] as bool? ?? false,
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
    )
      ..blurHash = json['blurHash'] as String?
      ..uploaded = json['uploaded'] as bool;

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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$StorageLocationEnumMap = {
  StorageLocation.local: 'local',
  StorageLocation.sync: 'sync',
};
