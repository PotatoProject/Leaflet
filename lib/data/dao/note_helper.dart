import 'package:moor_flutter/moor_flutter.dart';
import 'package:potato_notes/data/database.dart';

part 'note_helper.g.dart';

@UseDao(tables: [Notes])
class NoteHelper extends DatabaseAccessor<AppDatabase> with _$NoteHelperMixin {
  final AppDatabase db;

  NoteHelper(this.db) : super(db);

  Future<List<Note>> listNotes(ReturnMode mode) async {
    switch (mode) {
      case ReturnMode.NORMAL:
        return (select(notes)
              ..where((table) => and(not(table.archived), not(table.deleted))))
            .get();
      case ReturnMode.ARCHIVE:
        return (select(notes)
              ..where((table) => and(table.archived, not(table.deleted))))
            .get();
      case ReturnMode.TRASH:
        return (select(notes)
              ..where((table) => and(not(table.archived), table.deleted)))
            .get();
      case ReturnMode.ALL:
      default:
        return select(notes).get();
    }
  }

  Stream<List<Note>> noteStream(ReturnMode mode) {
    SimpleSelectStatement<$NotesTable, Note> selectQuery;

    switch (mode) {
      case ReturnMode.ALL:
        selectQuery = select(notes);
        break;
      case ReturnMode.NORMAL:
        selectQuery = select(notes)
          ..where((table) => and(not(table.archived), not(table.deleted)));
        break;
      case ReturnMode.ARCHIVE:
        selectQuery = select(notes)
          ..where((table) => and(table.archived, not(table.deleted)));
        break;
      case ReturnMode.TRASH:
        selectQuery = select(notes)
          ..where((table) => and(not(table.archived), table.deleted));
        break;
    }

    return (selectQuery
          ..orderBy([
            (table) => OrderingTerm(
                expression: (table).creationDate, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future saveNote(Note note) => into(notes).insert(note, orReplace: true);

  Future deleteNote(Note note) => delete(notes).delete(note);
}

enum ReturnMode {
  ALL,
  NORMAL,
  ARCHIVE,
  TRASH,
}
