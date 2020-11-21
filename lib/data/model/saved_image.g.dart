// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedImage _$SavedImageFromJson(Map<String, dynamic> json) {
  return SavedImage(
    json['id'] as String,
    json['uri'] == null ? null : Uri.parse(json['uri'] as String),
    _$enumDecode(_$StorageLocationEnumMap, json['storageLocation']),
    json['hash'] as String?,
    json['encrypted'] as bool,
  )
    ..blurHash = json['blurHash'] as String?
    ..uploaded = json['uploaded'] as bool;
}

Map<String, dynamic> _$SavedImageToJson(SavedImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uri': instance.uri?.toString(),
      'storageLocation': _$StorageLocationEnumMap[instance.storageLocation],
      'hash': instance.hash,
      'blurHash': instance.blurHash,
      'encrypted': instance.encrypted,
      'uploaded': instance.uploaded,
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

const _$StorageLocationEnumMap = {
  StorageLocation.LOCAL: 'LOCAL',
  StorageLocation.IMGUR: 'IMGUR',
  StorageLocation.SYNC: 'SYNC',
};
