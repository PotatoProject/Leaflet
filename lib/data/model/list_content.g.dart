// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
