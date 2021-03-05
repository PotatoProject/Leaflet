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
      case ReturnMode.ALL:
        return select(notes).get();
      case ReturnMode.NORMAL:
        return (select(notes)
              ..where((table) =>
                  table.archived.not() &
                  table.deleted.not() &
                  table.id.contains("-synced").not()))
            .get();
      case ReturnMode.ARCHIVE:
        return (select(notes)
              ..where((table) =>
                  table.archived &
                  table.deleted.not() &
                  table.id.contains("-synced").not()))
            .get();
      case ReturnMode.TRASH:
        return (select(notes)
              ..where((table) =>
                  table.archived.not() &
                  table.deleted &
                  table.id.contains("-synced").not()))
            .get();
      case ReturnMode.SYNCED:
        return (select(notes)..where((table) => table.id.contains("-synced")))
            .get();
      case ReturnMode.TAG:
      case ReturnMode.LOCAL:
        return (select(notes)
              ..where((table) => table.id.contains("-synced").not()))
            .get();
      case ReturnMode.FAVOURITES:
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
      case ReturnMode.ALL:
        selectQuery = select(notes);
        break;
      case ReturnMode.NORMAL:
        selectQuery = select(notes)
          ..where((table) =>
              table.archived.not() &
              table.deleted.not() &
              table.id.contains("-synced").not());
        break;
      case ReturnMode.ARCHIVE:
        selectQuery = select(notes)
          ..where((table) =>
              table.archived &
              table.deleted.not() &
              table.id.contains("-synced").not());
        break;
      case ReturnMode.FAVOURITES:
        selectQuery = select(notes)
          ..where((table) =>
              table.starred &
              table.archived.not() &
              table.deleted.not() &
              table.id.contains("-synced").not());
        break;
      case ReturnMode.TRASH:
        selectQuery = select(notes)
          ..where((table) =>
              table.archived.not() &
              table.deleted &
              table.id.contains("-synced").not());
        break;
      case ReturnMode.SYNCED:
        selectQuery = select(notes)
          ..where((table) => table.id.contains("-synced"));
        break;
      case ReturnMode.TAG:
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

  Future<void> saveNote(Note note) {
    Loggy.d(message: "The note id is: ${note.id}");
    return into(notes).insert(note, mode: InsertMode.replace);
  }

  Future<void> deleteNote(Note note) {
    Loggy.d(message: "The note id to delete: ${note.id}");
    return delete(notes).delete(note);
  }

  Future<void> deleteAllNotes() async {
    final List<Note> notes = await listNotes(ReturnMode.ALL);

    notes.forEach((note) async {
      await deleteNote(note);
    });
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
    this.dateMode = DateFilterMode.ONLY,
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
    dateMode = DateFilterMode.ONLY;
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
      return this.fromNormal == other.fromNormal &&
          this.fromArchive == other.fromArchive &&
          this.fromTrash == other.fromTrash;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(fromNormal, fromArchive, fromTrash);
}

enum DateFilterMode {
  AFTER,
  BEFORE,
  ONLY,
}

enum ReturnMode { ALL, NORMAL, ARCHIVE, TRASH, FAVOURITES, TAG, SYNCED, LOCAL }
