// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'list_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListItem _$ListItemFromJson(Map<String, dynamic> json) {
  return ListItem(
    id: json['id'] as int,
    text: json['text'] as String,
    status: json['status'] as bool,
  );
}

Map<String, dynamic> _$ListItemToJson(ListItem instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'status': instance.status,
    };
