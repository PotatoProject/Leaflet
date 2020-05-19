import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:potato_notes/data/database.dart';

part 'sync_note.g.dart';

@JsonSerializable()
class SyncNote {
  String note_id;
  String title;
  String content;
  String style_json;
  bool starred;
  int creation_date;
  int last_modify_date;
  int color;
  String images;
  bool list;
  String list_content;
  String reminders;
  bool hide_content;
  bool lock_note;
  bool uses_biometrics;
  bool deleted;
  bool archived;
  bool synced;

  SyncNote(
      this.note_id,
      this.title,
      this.content,
      this.style_json,
      this.starred,
      this.creation_date,
      this.last_modify_date,
      this.color,
      this.images,
      this.list,
      this.list_content,
      this.reminders,
      this.hide_content,
      this.lock_note,
      this.uses_biometrics,
      this.deleted,
      this.archived,
      this.synced);

  static SyncNote fromNote(Note note) {
    String id = note.id;
    String title = note.title;
    String content = note.content;
    String styleJson = jsonEncode(note.styleJson.data);
    bool starred = note.starred;
    int creationDate = note.creationDate.millisecondsSinceEpoch;
    int lastModifyDate = note.lastModifyDate.millisecondsSinceEpoch;
    int color = note.color;
    String images = jsonEncode(note.images.images);
    bool list = note.list;
    String listContent = jsonEncode(note.listContent.content);
    String reminders = jsonEncode(note.reminders.reminders);
    bool hideContent = note.hideContent;
    bool lockNote = note.lockNote;
    bool usesBiometrics = note.usesBiometrics;
    bool deleted = note.deleted;
    bool archived = note.archived;
    bool synced = note.synced;
    return SyncNote(
        id,
        title,
        content,
        styleJson,
        starred,
        creationDate,
        lastModifyDate,
        color,
        images,
        list,
        listContent,
        reminders,
        hideContent,
        lockNote,
        usesBiometrics,
        deleted,
        archived,
        synced);
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory SyncNote.fromJson(Map<String, dynamic> json) =>
      _$SyncNoteFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SyncNoteToJson(this);
}
