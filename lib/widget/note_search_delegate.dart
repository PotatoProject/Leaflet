import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/illustrations.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/query_filters.dart';
import 'package:rich_text_editor/rich_text_editor.dart';

class NoteSearchDelegate extends CustomSearchDelegate {
  SearchQuery searchQuery = SearchQuery();
  int numOfImages;

  NoteSearchDelegate();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.filter_list),
        padding: EdgeInsets.all(0),
        onPressed: () => Utils.showNotesModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => QueryFilters(
            query: searchQuery,
          ),
        ),
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    numOfImages = 2;

    if (width >= 1280) {
      numOfImages = 4;
    } else if (width >= 900) {
      numOfImages = 3;
    } else if (width >= 600) {
      numOfImages = 3;
    } else if (width >= 360) {
      numOfImages = 2;
    } else {
      numOfImages = 2;
    }

    return FutureBuilder(
      future: getNotesForQuery(),
      initialData: [],
      builder: (context, snapshot) {
        Widget child;

        if (snapshot.data.isNotEmpty) {
          if (prefs.useGrid) {
            child = StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemBuilder: (context, index) => noteView(context, snapshot.data[index]),
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              itemCount: snapshot.data.length,
            );
          } else {
            child = ListView.builder(
              itemBuilder: (context, index) => noteView(context, snapshot.data[index]),
              itemCount: snapshot.data.length,
            );
          }
        } else {
          if (query.isEmpty) {
            child = Illustrations.quickIllustration(
              context,
              appInfo.typeToSearchIllustration,
              "Type to start your search",
            );
          } else {
            child = Illustrations.quickIllustration(
              context,
              appInfo.nothingFoundIllustration,
              "Nothing found...",
            );
          }
        }
        return child;
      },
    );
  }

  Widget noteView(BuildContext context, Note note) {
    SpannableList titleList = SpannableList.generate(note.title.length);
    SpannableList contentList = SpannableList.generate(note.content.length);

    Color noteColor =
        Color(NoteColors.colorList[note.color].dynamicColor(context));
    Color bgColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey[900];

    int titleIndex = searchQuery.caseSensitive
        ? note.title.indexOf(query)
        : note.title.toLowerCase().indexOf(query.toLowerCase());

    int contentIndex = searchQuery.caseSensitive
        ? note.content.indexOf(query)
        : note.content.toLowerCase().indexOf(query.toLowerCase());

    if (titleIndex != -1) {
      for (int i = titleIndex; i < query.length + titleIndex; i++) {
        titleList.list[i] = SpannableStyle(value: 0)
          ..setBackgroundColor(
              note.color != 0 ? bgColor : Theme.of(context).accentColor)
          ..setForegroundColor(
              note.color != 0 ? noteColor : Theme.of(context).cardColor);
      }
    }

    if (contentIndex != -1) {
      for (int i = contentIndex;
          i < query.length + contentIndex;
          i++) {
        contentList.list[i] = SpannableStyle(value: 0)
          ..setBackgroundColor(
              note.color != 0 ? bgColor : Theme.of(context).accentColor)
          ..setForegroundColor(
              note.color != 0 ? noteColor : Theme.of(context).cardColor);
      }
    }

    return NoteView(
      note: note,
      onTap: () => openNote(context, note),
      numOfImages: numOfImages,
      providedTitleList: titleList,
      providedContentList: contentList,
    );
  }

  void openNote(BuildContext context, Note note) async {
    bool status = false;
    if (note.lockNote && note.usesBiometrics) {
      bool bioAuth = await LocalAuthentication().authenticateWithBiometrics(
        localizedReason: "",
        androidAuthStrings: AndroidAuthMessages(
          signInTitle: "Scan fingerprint to open note",
          fingerprintHint: "",
        ),
      );

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotePage(
            note: note,
            numOfImages: numOfImages,
          ),
        ),
      );
    }
  }

  Future<List<Note>> getNotesForQuery() async {
    List<Note> notes = await helper.listNotes(ReturnMode.ALL);
    List<Note> results = [];

    if (query.trim().isEmpty) {
      return [];
    }

    bool _getColorBool(int noteColor) {
      return noteColor == searchQuery.color;
    }

    bool _getDateBool(DateTime noteDate) {
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
      String sanitizedQuery = searchQuery.caseSensitive
          ? query
          : query.toLowerCase();

      String sanitizedText =
          searchQuery.caseSensitive ? text : text.toLowerCase();

      return sanitizedText.contains(sanitizedQuery);
    }

    for (Note note in notes) {
      if (searchQuery.color != null && searchQuery.date != null) {
        if (_getColorBool(note.color) &&
            _getDateBool(note.creationDate) &&
            (_getTextBool(note.title) || _getTextBool(note.content))) {
          results.add(note);
        }
      } else {
        if (searchQuery.color != null) {
          if (_getColorBool(note.color) &&
              (_getTextBool(note.title) || _getTextBool(note.content))) {
            results.add(note);
          }
        } else if (searchQuery.date != null) {
          if (_getDateBool(note.creationDate) &&
              (_getTextBool(note.title) || _getTextBool(note.content))) {
            results.add(note);
          }
        } else {
          if (_getTextBool(note.title) || _getTextBool(note.content)) {
            results.add(note);
          }
        }
      }
    }

    return results;
  }
}
