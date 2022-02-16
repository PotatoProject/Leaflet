import 'package:collection/collection.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/list_content.dart';

class UnmodifiableNoteView extends Note {
  UnmodifiableNoteView({required Note note})
      : super(
          id: note.id,
          title: note.title,
          content: note.content,
          starred: note.starred,
          creationDate: note.creationDate,
          color: note.color,
          images: note.images,
          list: note.list,
          listContent: note.listContent,
          reminders: note.reminders,
          tags: note.tags,
          hideContent: note.hideContent,
          lockNote: note.lockNote,
          usesBiometrics: note.usesBiometrics,
          folder: note.folder,
          lastChanged: note.lastChanged,
          lastSynced: note.lastSynced,
        );

  @override
  List<String> get images => UnmodifiableListView(super.images);

  @override
  List<ListItem> get listContent => UnmodifiableListView(super.listContent);

  @override
  List<DateTime> get reminders => UnmodifiableListView(super.reminders);

  @override
  List<String> get tags => UnmodifiableListView(super.tags);
}
