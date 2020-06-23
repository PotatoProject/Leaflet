// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageList _$ImageListFromJson(Map<String, dynamic> json) {
  return ImageList(
    (json['data'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e == null ? null : Uri.parse(e as String)),
    ),
  );
}

Map<String, dynamic> _$ImageListToJson(ImageList instance) => <String, dynamic>{
      'data': instance.data?.map((k, e) => MapEntry(k, e?.toString())),
    };
