// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageList _$ImageListFromJson(Map<String, dynamic> json) {
  return ImageList(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : SavedImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ImageListToJson(ImageList instance) => <String, dynamic>{
      'data': instance.data,
    };
