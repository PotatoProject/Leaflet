import 'package:moor/moor.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/logger_provider.dart';

part 'note_helper.g.dart';

@UseDao(tables: [Notes])
class NoteHelper extends DatabaseAccessor<AppDatabase>
    with _$NoteHelperMixin, LoggerProvider {
  final AppDatabase db;

  NoteHelper(this.db) : super(db);

  Future<List<Note>> listNotes(ReturnMode mode) async {
    switch (mode) {
      case ReturnMode.all:
        return select(notes).get();
      case ReturnMode.normal:
        return (select(notes)
              ..where((table) =>
                  table.archived.not() &
                  table.deleted.not() &
                  table.id.contains("-synced").not()))
            .get();
      case ReturnMode.archive:
        return (select(notes)
              ..where((table) =>
                  table.archived &
                  table.deleted.not() &
                  table.id.contains("-synced").not()))
            .get();
      case ReturnMode.trash:
        return (select(notes)
              ..where((table) =>
                  table.archived.not() &
                  table.deleted &
                  table.id.contains("-synced").not()))
            .get();
      case ReturnMode.synced:
        return (select(notes)..where((table) => table.id.contains("-synced")))
            .get();
      case ReturnMode.tag:
      case ReturnMode.local:
        return (select(notes)
              ..where((table) => table.id.contains("-synced").not()))
            .get();
      case ReturnMode.favourites:
        return (select(notes)
              ..where((table) =>
                  table.starred &
                  table.archived.not() &
                  table.deleted.not() &
                  table.id.contains("-synced").not()))
            .get();

      default:
        return select(notes).get();
    }
  }

  Stream<List<Note>> noteStream(ReturnMode mode) {
    SimpleSelectStatement<$NotesTable, Note> selectQuery;

    switch (mode) {
      case ReturnMode.all:
        selectQuery = select(notes);
        break;
      case ReturnMode.normal:
        selectQuery = select(notes)
          ..where((table) =>
              table.archived.not() &
              table.deleted.not() &
              table.id.contains("-synced").not());
        break;
      case ReturnMode.archive:
        selectQuery = select(notes)
          ..where((table) =>
              table.archived &
              table.deleted.not() &
              table.id.contains("-synced").not());
        break;
      case ReturnMode.favourites:
        selectQuery = select(notes)
          ..where((table) =>
              table.starred &
              table.archived.not() &
              table.deleted.not() &
              table.id.contains("-synced").not());
        break;
      case ReturnMode.trash:
        selectQuery = select(notes)
          ..where((table) =>
              table.archived.not() &
              table.deleted &
              table.id.contains("-synced").not());
        break;
      case ReturnMode.synced:
        selectQuery = select(notes)
          ..where((table) => table.id.contains("-synced"));
        break;
      case ReturnMode.tag:
      case ReturnMode.local:
        selectQuery = select(notes)
          ..where((table) => table.id.contains("-synced").not());
        break;
    }

    return (selectQuery
          ..orderBy([
            (table) => OrderingTerm(
                expression: table.creationDate, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future<void> saveNote(Note note) {
    logger.d("The note id is: ${note.id}");
    return into(notes).insert(note, mode: InsertMode.replace);
  }

  Future<bool> noteExists(Note note) async {
    final SimpleSelectStatement<$NotesTable, Note> selectQuery = select(notes)
      ..whereSamePrimaryKey(note);
    final Note? match = await selectQuery.getSingleOrNull();
    return match != null;
  }

  Future<void> deleteNote(Note note) {
    logger.d("The note id to delete: ${note.id}");
    return delete(notes).delete(note);
  }

  Future<void> deleteAllNotes() async {
    final List<Note> notes = await listNotes(ReturnMode.all);

    for (final Note note in notes) {
      await deleteNote(note);
    }
  }
}

class SearchQuery {
  bool caseSensitive;
  int? color;
  DateTime? date;
  DateFilterMode dateMode;
  List<String> tags = [];
  bool onlyFavourites;
  SearchReturnMode returnMode;

  SearchQuery({
    this.caseSensitive = false,
    this.color,
    this.date,
    this.dateMode = DateFilterMode.only,
    this.onlyFavourites = false,
    this.returnMode = const SearchReturnMode(
      fromNormal: true,
      fromArchive: true,
      fromTrash: true,
    ),
  });

  void reset() {
    caseSensitive = false;
    color = null;
    date = null;
    dateMode = DateFilterMode.only;
    tags = [];
    onlyFavourites = false;
    returnMode = const SearchReturnMode(
      fromNormal: true,
      fromArchive: true,
      fromTrash: true,
    );
  }
}

class SearchReturnMode {
  final bool fromNormal;
  final bool fromArchive;
  final bool fromTrash;

  const SearchReturnMode({
    this.fromNormal = false,
    this.fromArchive = false,
    this.fromTrash = false,
  });

  List<bool> get values => [
        fromNormal,
        fromArchive,
        fromTrash,
      ];

  SearchReturnMode copyWith({
    bool? fromNormal,
    bool? fromArchive,
    bool? fromTrash,
  }) {
    return SearchReturnMode(
      fromNormal: fromNormal ?? this.fromNormal,
      fromArchive: fromArchive ?? this.fromArchive,
      fromTrash: fromTrash ?? this.fromTrash,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is SearchReturnMode) {
      return fromNormal == other.fromNormal &&
          fromArchive == other.fromArchive &&
          fromTrash == other.fromTrash;
    }
    return false;
  }

  @override
  int get hashCode =>
      fromNormal.hashCode ^ fromArchive.hashCode ^ fromTrash.hashCode;
}

enum DateFilterMode {
  after,
  before,
  only,
}

enum ReturnMode {
  all,
  normal,
  archive,
  trash,
  favourites,
  tag,
  synced,
  local,
}
