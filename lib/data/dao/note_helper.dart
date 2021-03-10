import 'package:flutter/cupertino.dart';
import 'package:loggy/loggy.dart';
import 'package:moor/moor.dart';
import 'package:potato_notes/data/database.dart';

part 'note_helper.g.dart';

@UseDao(tables: [Notes])
class NoteHelper extends DatabaseAccessor<AppDatabase> with _$NoteHelperMixin {
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
    Loggy.d(message: "The note id is: ${note.id}");
    return into(notes).insert(note, mode: InsertMode.replace);
  }

  Future<void> deleteNote(Note note) {
    Loggy.d(message: "The note id to delete: ${note.id}");
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
  int _color;
  DateTime date;
  DateFilterMode dateMode;
  List<String> tags = [];
  bool onlyFavourites;
  SearchReturnMode returnMode;

  int get color => _color ?? 0;

  set color(int value) {
    if (value == -1) {
      _color = 0;
    } else {
      _color = value;
    }
  }

  SearchQuery({
    this.caseSensitive = false,
    int color = 0,
    this.date,
    this.dateMode = DateFilterMode.only,
    this.onlyFavourites = false,
    this.returnMode = const SearchReturnMode(
      fromNormal: true,
      fromArchive: true,
      fromTrash: true,
    ),
  }) : _color = color;

  void reset() {
    caseSensitive = false;
    _color = 0;
    date = null;
    dateMode = DateFilterMode.only;
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
    bool fromNormal,
    bool fromArchive,
    bool fromTrash,
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
  int get hashCode => hashValues(fromNormal, fromArchive, fromTrash);
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
