// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncNote _$SyncNoteFromJson(Map<String, dynamic> json) {
  return SyncNote(
    json['note_id'] as String,
    json['title'] as String,
    json['content'] as String,
    json['style_json'] as String,
    json['starred'] as bool,
    json['creation_date'] as int,
    json['last_modify_date'] as int,
    json['color'] as int,
    json['images'] as String,
    json['list'] as bool,
    json['list_content'] as String,
    json['reminders'] as String,
    json['hide_content'] as bool,
    json['lock_note'] as bool,
    json['uses_biometrics'] as bool,
    json['deleted'] as bool,
    json['archived'] as bool,
    json['synced'] as bool,
  );
}

Map<String, dynamic> _$SyncNoteToJson(SyncNote instance) => <String, dynamic>{
      'note_id': instance.note_id,
      'title': instance.title,
      'content': instance.content,
      'style_json': instance.style_json,
      'starred': instance.starred,
      'creation_date': instance.creation_date,
      'last_modify_date': instance.last_modify_date,
      'color': instance.color,
      'images': instance.images,
      'list': instance.list,
      'list_content': instance.list_content,
      'reminders': instance.reminders,
      'hide_content': instance.hide_content,
      'lock_note': instance.lock_note,
      'uses_biometrics': instance.uses_biometrics,
      'deleted': instance.deleted,
      'archived': instance.archived,
      'synced': instance.synced,
    };
