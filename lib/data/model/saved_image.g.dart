// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedImage _$SavedImageFromJson(Map<String, dynamic> json) {
  return SavedImage(
    json['id'] as String,
    _$enumDecodeNullable(_$StorageLocationEnumMap, json['storageLocation']),
    json['hash'] as String,
    json['encrypted'] as bool,
  )
    ..blurHash = json['blurHash'] as String
    ..uploaded = json['uploaded'] as bool;
}

Map<String, dynamic> _$SavedImageToJson(SavedImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storageLocation': _$StorageLocationEnumMap[instance.storageLocation],
      'hash': instance.hash,
      'blurHash': instance.blurHash,
      'encrypted': instance.encrypted,
      'uploaded': instance.uploaded,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$StorageLocationEnumMap = {
  StorageLocation.LOCAL: 'LOCAL',
  StorageLocation.SYNC: 'SYNC',
};
