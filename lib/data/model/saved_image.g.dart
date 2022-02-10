// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedImage _$SavedImageFromJson(Map<String, dynamic> json) => SavedImage(
      id: json['id'] as String,
      storageLocation: $enumDecodeNullable(
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

const _$StorageLocationEnumMap = {
  StorageLocation.local: 'local',
  StorageLocation.sync: 'sync',
};
