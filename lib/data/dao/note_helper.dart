import 'package:moor/moor.dart';
import 'package:potato_notes/data/database.dart';

part 'note_helper.g.dart';

@UseDao(tables: [Notes])
class NoteHelper extends DatabaseAccessor<AppDatabase> with _$NoteHelperMixin {
  final AppDatabase db;

  NoteHelper(this.db) : super(db);

  Future<List<Note>> listNotes(ReturnMode mode) async {
    switch (mode) {
      case ReturnMode.TAG:
      case ReturnMode.NORMAL:
        return (select(notes)
              ..where((table) => table.archived.not() & table.deleted.not()))
            .get();
      case ReturnMode.ARCHIVE:
        return (select(notes)
              ..where((table) => table.archived & table.deleted.not()))
            .get();
      case ReturnMode.TRASH:
        return (select(notes)
              ..where((table) => table.archived.not() & table.deleted))
            .get();
      case ReturnMode.FAVOURITES:
        return (select(notes)
              ..where((table) =>
                  table.starred & table.archived.not() & table.deleted.not()))
            .get();
      case ReturnMode.ALL:
      default:
        return select(notes).get();
    }
  }

  Stream<List<Note>> noteStream(ReturnMode mode) {
    SimpleSelectStatement<$NotesTable, Note> selectQuery;

    switch (mode) {
      case ReturnMode.TAG:
      case ReturnMode.ALL:
        selectQuery = select(notes);
        break;
      case ReturnMode.NORMAL:
        selectQuery = select(notes)
          ..where((table) => table.archived.not() & table.deleted.not());
        break;
      case ReturnMode.ARCHIVE:
        selectQuery = select(notes)
          ..where((table) => table.archived & table.deleted.not());
        break;
      case ReturnMode.FAVOURITES:
        selectQuery = select(notes)
          ..where((table) =>
              table.starred & table.archived.not() & table.deleted.not());
        break;
      case ReturnMode.TRASH:
        selectQuery = select(notes)
          ..where((table) => table.archived.not() & table.deleted);
        break;
    }

    return (selectQuery
          ..orderBy([
            (table) => OrderingTerm(
                expression: (table).creationDate, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future saveNote(Note note) =>
      into(notes).insert(note, mode: InsertMode.replace);

  Future deleteNote(Note note) => delete(notes).delete(note);
}

class SearchQuery {
  bool caseSensitive;
  int color;
  DateTime date;
  DateFilterMode dateMode;

  SearchQuery({
    this.caseSensitive = true,
    this.color,
    this.date,
    this.dateMode = DateFilterMode.ONLY,
  });
}

enum DateFilterMode {
  AFTER,
  BEFORE,
  ONLY,
}
enum ReturnMode {
  ALL,
  NORMAL,
  ARCHIVE,
  TRASH,
  FAVOURITES,
  TAG,
}
