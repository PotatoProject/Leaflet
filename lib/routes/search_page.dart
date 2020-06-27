import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/note_colors.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/locator.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/query_filters.dart';
import 'package:rich_text_editor/rich_text_editor.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  NoteHelper helper;
  List<Note> notes = [];
  int numOfImages;

  SearchQuery query = SearchQuery();

  @override
  Widget build(BuildContext context) {
    if (helper == null) helper = locator<NoteHelper>();

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

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: TextField(
            decoration: InputDecoration.collapsed(
              hintText: "Search",
            ),
            onChanged: (text) {
              query.input = text;
              updateResults();
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            padding: EdgeInsets.all(0),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => QueryFilters(
                query: query,
                filterChangedCallback: () => updateResults(),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          Note note = notes[index];

          SpannableList titleList = SpannableList.generate(note.title.length);
          SpannableList contentList =
              SpannableList.generate(note.content.length);
          
          Color noteColor = Color(NoteColors.colorList(context)[note.color]["hex"]);
          Color bgColor = Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.grey[900];

          int titleIndex = query.caseSensitive
              ? note.title.indexOf(query.input)
              : note.title.toLowerCase().indexOf(query.input.toLowerCase());

          int contentIndex = query.caseSensitive
              ? note.content.indexOf(query.input)
              : note.content.toLowerCase().indexOf(query.input.toLowerCase());

          if (titleIndex != -1) {
            for (int i = titleIndex; i < query.input.length + titleIndex; i++) {
              titleList.list[i] = SpannableStyle(value: 0)
                ..setBackgroundColor(
                    note.color != 0 ? bgColor : Theme.of(context).accentColor)
                ..setForegroundColor(note.color != 0 ? noteColor : Theme.of(context).cardColor);
            }
          }

          if (contentIndex != -1) {
            for (int i = contentIndex;
                i < query.input.length + contentIndex;
                i++) {
              contentList.list[i] = SpannableStyle(value: 0)
                ..setBackgroundColor(
                    note.color != 0 ? bgColor : Theme.of(context).accentColor)
                ..setForegroundColor(note.color != 0 ? noteColor : Theme.of(context).cardColor);
            }
          }

          return NoteView(
            note: note,
            onTap: () => openNote(note),
            numOfImages: numOfImages,
            providedTitleList: titleList,
            providedContentList: contentList,
          );
        },
        itemCount: notes.length,
      ),
    );
  }

  void updateResults() async {
    notes.clear();
    notes = List.from(
      getNotesForQuery(await helper.listNotes(ReturnMode.ALL)),
    );
    setState(() {});
  }

  void openNote(Note note) async {
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

  List<Note> getNotesForQuery(List<Note> notes) {
    List<Note> results = [];

    if (query.input.trim().isEmpty) {
      return [];
    }

    bool _getColorBool(int noteColor) {
      return noteColor == query.color;
    }

    bool _getDateBool(DateTime noteDate) {
      DateTime sanitizedNoteDate = DateTime(
        noteDate.year,
        noteDate.month,
        noteDate.day,
      );

      DateTime sanitizedQueryDate = DateTime(
        query.date.year,
        query.date.month,
        query.date.day,
      );

      switch (query.dateMode) {
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
      String sanitizedQuery =
          query.caseSensitive ? query.input : query.input.toLowerCase();

      String sanitizedText = query.caseSensitive ? text : text.toLowerCase();

      return sanitizedText.contains(sanitizedQuery);
    }

    for (Note note in notes) {
      if (query.color != null && query.date != null) {
        if (_getColorBool(note.color) &&
            _getDateBool(note.creationDate) &&
            (_getTextBool(note.title) || _getTextBool(note.content))) {
          results.add(note);
        }
      } else {
        if (query.color != null) {
          if (_getColorBool(note.color) &&
              (_getTextBool(note.title) || _getTextBool(note.content))) {
            results.add(note);
          }
        } else if (query.date != null) {
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
