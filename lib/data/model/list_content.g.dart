// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListItem _$ListItemFromJson(Map<String, dynamic> json) => ListItem(
      id: json['id'] as int,
      text: json['text'] as String,
      status: json['status'] as bool,
    );

Map<String, dynamic> _$ListItemToJson(ListItem instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'status': instance.status,
    };
