import 'package:drift/drift.dart';
import 'package:potato_notes/data/dao/folder_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/logger_provider.dart';

part 'note_helper.g.dart';

@DriftAccessor(tables: [Notes])
class NoteHelper extends DatabaseAccessor<AppDatabase>
    with _$NoteHelperMixin, LoggerProvider {
  final AppDatabase db;

  NoteHelper(this.db) : super(db);

  Future<List<Note>> listNotes(Folder folder) async {
    if (folder != BuiltInFolders.all) {
      return (select(notes)
            ..where(
              (table) => table.folder.equals(folder.id),
            ))
          .get();
    } else {
      return select(notes).get();
    }
  }

  Stream<Note> watchNote(Note note) {
    return (select(notes)..where((table) => table.id.equals(note.id)))
        .watchSingle();
  }

  Stream<List<Note>> watchNotes(Folder folder) {
    SimpleSelectStatement<$NotesTable, Note> selectQuery;

    if (folder != BuiltInFolders.all) {
      selectQuery = select(notes)
        ..where(
          (table) => table.folder.equals(folder.id),
        );
    } else {
      selectQuery = select(notes);
    }

    return (selectQuery
          ..orderBy([
            (table) => OrderingTerm(
                  expression: table.creationDate,
                  mode: OrderingMode.desc,
                )
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
    final List<Note> notes = await listNotes(BuiltInFolders.all);

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
  Set<Folder> folders = {};

  SearchQuery({
    this.caseSensitive = false,
    this.color,
    this.date,
    this.dateMode = DateFilterMode.only,
    this.onlyFavourites = false,
    this.folders = const {},
  });

  void reset() {
    caseSensitive = false;
    color = null;
    date = null;
    dateMode = DateFilterMode.only;
    tags = [];
    onlyFavourites = false;
    folders = {};
  }

  List<Note> filterNotes(
    String textQuery,
    List<Note> notes, {
    bool returnNothingOnEmptyQuery = true,
  }) {
    final List<Note> results = [];

    if (textQuery.trim().isEmpty &&
        !onlyFavourites &&
        date == null &&
        tags.isEmpty &&
        color == null) {
      if (returnNothingOnEmptyQuery) {
        return [];
      } else {
        return notes;
      }
    }

    for (final Note note in notes) {
      final bool titleMatch = _getTextBool(textQuery, note.title);
      final bool contentMatch =
          !note.hideContent ? _getTextBool(textQuery, note.content) : false;
      final bool dateMatch =
          date != null ? _getDateBool(note.creationDate) : true;
      final bool colorMatch = color != null ? _getColorBool(note.color) : true;
      final bool tagMatch = tags.isNotEmpty ? _getTagBool(note.tags) : true;
      final bool favouriteMatch = onlyFavourites ? note.starred : true;
      final bool folderMatch = _getFoldersBool(note);

      if (tagMatch &&
          colorMatch &&
          dateMatch &&
          favouriteMatch &&
          (titleMatch || contentMatch) &&
          folderMatch) {
        results.add(note);
      }
    }

    return results;
  }

  bool _getColorBool(int noteColor) {
    return noteColor == color;
  }

  bool _getDateBool(DateTime noteDate) {
    if (date == null) return false;

    final DateTime sanitizedNoteDate = DateTime(
      noteDate.year,
      noteDate.month,
      noteDate.day,
    );

    final DateTime sanitizedQueryDate = DateTime(
      date!.year,
      date!.month,
      date!.day,
    );

    switch (dateMode) {
      case DateFilterMode.after:
        return sanitizedNoteDate.isAfter(sanitizedQueryDate);
      case DateFilterMode.before:
        return sanitizedNoteDate.isBefore(sanitizedQueryDate);
      case DateFilterMode.only:
      default:
        return sanitizedNoteDate.isAtSameMomentAs(sanitizedQueryDate);
    }
  }

  bool _getTextBool(String textQuery, String text) {
    final String sanitizedQuery =
        caseSensitive ? textQuery : textQuery.toLowerCase();

    final String sanitizedText = caseSensitive ? text : text.toLowerCase();

    return sanitizedText.contains(sanitizedQuery);
  }

  bool _getTagBool(List<String> tags) {
    bool? matchResult;

    for (final String tag in tags) {
      if (matchResult != null) {
        matchResult = matchResult && tags.any((element) => element == tag);
      } else {
        matchResult = tags.any((element) => element == tag);
      }
    }

    return matchResult ?? false;
  }

  bool _getFoldersBool(Note note) {
    if (folders.isEmpty) return true;

    return folders.any((f) => f.id == note.folder);
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

@Deprecated("Prefer Folder instead of ReturnMode")
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
