import 'package:uuid/uuid.dart';

class NoteCreatedEvent {
  Uuid id;

  NoteCreatedEvent(this.id);
}
