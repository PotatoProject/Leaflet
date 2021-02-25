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
        icon: Icon(Icons.filter_list),
        padding: EdgeInsets.all(0),
        onPressed: () => Utils.showNotesModalBottomSheet(
          context: context,
          builder: (context) => QueryFilters(
            query: searchQuery,
            filterChangedCallback: () => setState(() {}),
          ),
        ),
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: getNotesForQuery(),
      initialData: [],
      builder: (context, snapshot) {
        final Brightness brightness = Theme.of(context).brightness;
        final Widget illustration = query.isEmpty
            ? Utils.quickIllustration(
                context,
                Illustration.typeToSearch(brightness: brightness),
                LocaleStrings.searchPage.noteTypeToSearch,
              )
            : Utils.quickIllustration(
                context,
                Illustration.nothingFound(brightness: brightness),
                LocaleStrings.searchPage.noteNothingFound,
              );
        return NoteListWidget(
          itemBuilder: (context, index) => NoteView(
            note: snapshot.data[index],
            onTap: () => openNote(context, snapshot.data[index]),
          ),
          noteCount: snapshot.data.length,
          customIllustration: illustration,
        );
      },
    );
  }

  void openNote(BuildContext context, Note note) async {
    bool status = false;
    if (note.lockNote && note.usesBiometrics) {
      final bool bioAuth = await Utils.showBiometricPrompt();

      if (bioAuth)
        status = bioAuth;
      else
        status = await Utils.showPassChallengeSheet(context) ?? false;
    } else if (note.lockNote && !note.usesBiometrics) {
      status = await Utils.showPassChallengeSheet(context) ?? false;
    } else {
      status = true;
    }

    if (status) {
      Utils.showSecondaryRoute(
        context,
        NotePage(
          note: note,
        ),
      ).then((_) => Utils.handleNotePagePop(note));
    }
  }

  Future<List<Note>> getNotesForQuery() async {
    final List<Note> notes = await helper.listNotes(ReturnMode.LOCAL);
    final List<Note> results = [];

    if (query.trim().isEmpty &&
        !searchQuery.onlyFavourites &&
        searchQuery.date == null &&
        searchQuery.tags.isEmpty &&
        searchQuery.color == 0) {
      return [];
    }

    bool _getColorBool(int noteColor) {
      if (searchQuery.color == null) return false;
      return noteColor == searchQuery.color;
    }

    bool _getDateBool(DateTime noteDate) {
      if (searchQuery.date == null) return false;

      DateTime sanitizedNoteDate = DateTime(
        noteDate.year,
        noteDate.month,
        noteDate.day,
      );

      DateTime sanitizedQueryDate = DateTime(
        searchQuery.date.year,
        searchQuery.date.month,
        searchQuery.date.day,
      );

      switch (searchQuery.dateMode) {
        case DateFilterMode.AFTER:
          return sanitizedNoteDate.isAfter(sanitizedQueryDate);
        case DateFilterMode.BEFORE:
          return sanitizedNoteDate.isBefore(sanitizedQueryDate);
        case DateFilterMode.ONLY:
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
      bool matchResult;

      searchQuery.tags.forEach((tag) {
        if (matchResult != null) {
          matchResult = matchResult && tags.any((element) => element == tag);
        } else {
          matchResult = tags.any((element) => element == tag);
        }
      });

      return matchResult;
    }

    for (Note note in notes) {
      final bool titleMatch = _getTextBool(note.title);
      final bool contentMatch =
          !note.hideContent ? _getTextBool(note.content) : false;
      final bool dateMatch =
          searchQuery.date != null ? _getDateBool(note.creationDate) : true;
      final bool colorMatch =
          searchQuery.color != null ? _getColorBool(note.color) : true;
      final bool tagMatch =
          searchQuery.tags.isNotEmpty ? _getTagBool(note.tags) : true;
      final bool favouriteMatch =
          searchQuery.onlyFavourites ? note.starred : true;

      if (tagMatch &&
          colorMatch &&
          dateMatch &&
          favouriteMatch &&
          (titleMatch || contentMatch)) {
        results.add(note);
      }
    }

    return results;
  }
}
