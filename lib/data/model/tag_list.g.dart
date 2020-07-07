// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagList _$TagListFromJson(Map<String, dynamic> json) {
  return TagList(
    (json['tagIds'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$TagListToJson(TagList instance) => <String, dynamic>{
      'tagIds': instance.tagIds,
    };
