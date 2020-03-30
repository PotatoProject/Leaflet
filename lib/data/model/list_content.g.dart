// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListContent _$ListContentFromJson(Map<String, dynamic> json) {
  return ListContent(
    (json['content'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as bool),
    ),
  );
}

Map<String, dynamic> _$ListContentToJson(ListContent instance) =>
    <String, dynamic>{
      'content': instance.content,
    };
