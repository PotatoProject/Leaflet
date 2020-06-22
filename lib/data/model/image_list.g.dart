// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageList _$ImageListFromJson(Map<String, dynamic> json) {
  return ImageList(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : ImageData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ImageListToJson(ImageList instance) => <String, dynamic>{
      'data': instance.data,
    };

ImageData _$ImageDataFromJson(Map<String, dynamic> json) {
  return ImageData(
    json['uri'] == null ? null : Uri.parse(json['uri'] as String),
    json['drawing'] as bool,
  );
}

Map<String, dynamic> _$ImageDataToJson(ImageData instance) => <String, dynamic>{
      'uri': instance.uri?.toString(),
      'drawing': instance.drawing,
    };
