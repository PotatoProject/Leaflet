// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListContent _$ListContentFromJson(Map<String, dynamic> json) {
  return ListContent(
    (json['content'] as List)
        ?.map((e) =>
            e == null ? null : ListItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListContentToJson(ListContent instance) =>
    <String, dynamic>{
      'content': instance.content,
    };

ListItem _$ListItemFromJson(Map<String, dynamic> json) {
  return ListItem(
    json['id'] as int,
    json['text'] as String,
    json['status'] as bool,
  );
}

Map<String, dynamic> _$ListItemToJson(ListItem instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'status': instance.status,
    };
