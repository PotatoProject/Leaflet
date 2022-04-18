import 'package:potato_notes/internal/events/note_edited_event.dart';
import 'package:potato_notes/internal/providers.dart';

class SyncHandler {
  void setupListeners() {
    eventBus.on<NoteEditedEvent>().listen(handleNoteEdit);
  }

  void handleNoteEdit(NoteEditedEvent event) {
    print(event.id);
    print(event.note.content);
  }
}
