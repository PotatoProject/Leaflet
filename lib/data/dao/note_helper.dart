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
              ..where((table) => table.archived.not() & table.deleted.not() & table.id.contains("-synced").not()))
            .get();
      case ReturnMode.ARCHIVE:
        return (select(notes)
              ..where((table) => table.archived & table.deleted.not() & table.id.contains("-synced").not()))
            .get();
      case ReturnMode.TRASH:
        return (select(notes)
              ..where((table) => table.archived.not() & table.deleted & table.id.contains("-synced").not()))
            .get();
      case ReturnMode.SYNCED:
        return (select(notes)
              ..where((table) => table.id.contains("-synced")))
            .get();
      case ReturnMode.LOCAL:
        return (select(notes)
          ..where((table) => table.id.contains("-synced").not()))
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
        selectQuery = select(notes)
          ..where((table) => table.id.contains("-synced").not());
        break;
      case ReturnMode.NORMAL:
        selectQuery = select(notes)
          ..where((table) => table.archived.not() & table.deleted.not() & table.id.contains("-synced").not());
        break;
      case ReturnMode.ARCHIVE:
        selectQuery = select(notes)
          ..where((table) => table.archived & table.deleted.not() & table.id.contains("-synced").not());
        break;
      case ReturnMode.FAVOURITES:
        selectQuery = select(notes)
          ..where((table) =>
              table.starred & table.archived.not() & table.deleted.not());
        break;
      case ReturnMode.TRASH:
        selectQuery = select(notes)
          ..where((table) => table.archived.not() & table.deleted & table.id.contains("-synced").not());
        break;
      case ReturnMode.SYNCED:
        selectQuery = select(notes)
          ..where((table) => table.id.contains("-synced"));
        break;
      case ReturnMode.LOCAL:
        selectQuery = select(notes)
          ..where((table) => table.id.contains("-synced").not());
        break;
    }

    return (selectQuery
          ..orderBy([
            (table) => OrderingTerm(
                expression: (table).creationDate, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future saveNote(Note note) {
    into(notes).insert(note, mode: InsertMode.replace);
    print("The note id is: " + note.id);
  }

  Future deleteNote(Note note) {
    delete(notes).delete(note);
    print("The note id to delete: " + note.id);
  }
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
  SYNCED,
  LOCAL
  FAVOURITES,
  TAG,
}
