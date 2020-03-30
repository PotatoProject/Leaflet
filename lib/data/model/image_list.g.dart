// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageList _$ImageListFromJson(Map<String, dynamic> json) {
  return ImageList(
    (json['images'] as List)
        ?.map((e) => e == null ? null : Uri.parse(e as String))
        ?.toList(),
  );
}

Map<String, dynamic> _$ImageListToJson(ImageList instance) => <String, dynamic>{
      'images': instance.images?.map((e) => e?.toString())?.toList(),
    };
