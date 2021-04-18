import 'package:flutter/material.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/illustrations.dart';
import 'package:potato_notes/widget/note_list_widget.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/query_filters.dart';

class NoteSearchDelegate extends CustomSearchDelegate {
  final SearchQuery searchQuery = SearchQuery();

  NoteSearchDelegate();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.filter_list),
        padding: EdgeInsets.zero,
        onPressed: () => Utils.showNotesModalBottomSheet(
          context: context,
          builder: (context) => QueryFilters(
            query: searchQuery,
            filterChangedCallback: () => setState!(() {}),
          ),
        ),
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: helper.noteStream(ReturnMode.local),
      builder: (context, snapshot) {
        return FutureBuilder<List<Note>>(
          future: getNotesForQuery(snapshot.data ?? []),
          initialData: const [],
          builder: (context, snapshot) {
            final Brightness brightness = context.theme.brightness;
            final Widget illustration = query.isEmpty
                ? Utils.quickIllustration(
                    context,
                    Illustration.typeToSearch(
                      brightness: brightness,
                      height: 72,
                    ),
                    LocaleStrings.search.typeToSearch,
                  )
                : Utils.quickIllustration(
                    context,
                    Illustration.nothingFound(
                      brightness: brightness,
                      height: 72,
                    ),
                    LocaleStrings.search.nothingFound,
                  );
            final List<Note> results = List<Note>.from(snapshot.data!);

            results.sort((a, b) => b.creationDate.compareTo(a.creationDate));

            return NoteListWidget(
              itemBuilder: (context, index) => NoteView(
                note: results[index],
                onTap: () => openNote(context, results[index]),
              ),
              noteCount: results.length,
              customIllustration: illustration,
            );
          },
        );
      },
    );
  }

  Future<void> openNote(BuildContext context, Note note) async {
    final bool status = await Utils.showNoteLockDialog(
      context: context,
      showLock: note.lockNote,
      showBiometrics: note.usesBiometrics,
    );

    if (status) {
      await Utils.showSecondaryRoute(
        context,
        NotePage(
          note: note,
        ),
      );
      Utils.handleNotePagePop(note);
    }
  }

  Future<List<Note>> getNotesForQuery(List<Note> notes) async {
    final List<Note> results = [];

    if (query.trim().isEmpty &&
        !searchQuery.onlyFavourites &&
        searchQuery.date == null &&
        searchQuery.tags.isEmpty &&
        searchQuery.color == 0) {
      return [];
    }

    for (final Note note in notes) {
      final bool titleMatch = _getTextBool(note.title);
      final bool contentMatch =
          !note.hideContent ? _getTextBool(note.content) : false;
      final bool dateMatch =
          searchQuery.date != null ? _getDateBool(note.creationDate) : true;
      final bool colorMatch =
          searchQuery.color != 0 ? _getColorBool(note.color) : true;
      final bool tagMatch =
          searchQuery.tags.isNotEmpty ? _getTagBool(note.tags) : true;
      final bool favouriteMatch =
          searchQuery.onlyFavourites ? note.starred : true;
      final bool modesMatch = _getModesBool(note);

      if (tagMatch &&
          colorMatch &&
          dateMatch &&
          favouriteMatch &&
          (titleMatch || contentMatch) &&
          modesMatch) {
        results.add(note);
      }
    }

    return results;
  }

  bool _getColorBool(int noteColor) {
    return noteColor == searchQuery.color;
  }

  bool _getDateBool(DateTime noteDate) {
    if (searchQuery.date == null) return false;

    final DateTime sanitizedNoteDate = DateTime(
      noteDate.year,
      noteDate.month,
      noteDate.day,
    );

    final DateTime sanitizedQueryDate = DateTime(
      searchQuery.date!.year,
      searchQuery.date!.month,
      searchQuery.date!.day,
    );

    switch (searchQuery.dateMode) {
      case DateFilterMode.after:
        return sanitizedNoteDate.isAfter(sanitizedQueryDate);
      case DateFilterMode.before:
        return sanitizedNoteDate.isBefore(sanitizedQueryDate);
      case DateFilterMode.only:
      default:
        return sanitizedNoteDate.isAtSameMomentAs(sanitizedQueryDate);
    }
  }

  bool _getTextBool(String text) {
    final String sanitizedQuery =
        searchQuery.caseSensitive ? query : query.toLowerCase();

    final String sanitizedText =
        searchQuery.caseSensitive ? text : text.toLowerCase();

    return sanitizedText.contains(sanitizedQuery);
  }

  bool _getTagBool(List<String> tags) {
    bool? matchResult;

    for (final String tag in searchQuery.tags) {
      if (matchResult != null) {
        matchResult = matchResult && tags.any((element) => element == tag);
      } else {
        matchResult = tags.any((element) => element == tag);
      }
    }

    return matchResult!;
  }

  bool _getModesBool(Note note) {
    final bool normal =
        !note.archived && !note.deleted && searchQuery.returnMode.fromNormal;
    final bool archived =
        note.archived && !note.deleted && searchQuery.returnMode.fromArchive;
    final bool deleted =
        !note.archived && note.deleted && searchQuery.returnMode.fromTrash;

    return normal || archived || deleted;
  }
}
