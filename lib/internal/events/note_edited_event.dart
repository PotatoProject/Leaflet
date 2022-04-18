import 'package:potato_notes/data/database.dart';

class NoteEditedEvent {
  String id;
  Note note;

  NoteEditedEvent(this.id, this.note);
}
