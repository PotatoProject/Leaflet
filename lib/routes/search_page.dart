import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/query_filters.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  NoteHelper helper;
  List<Note> notes = [];

  SearchQuery query = SearchQuery();

  @override
  Widget build(BuildContext context) {
    if (helper == null) helper = Provider.of<NoteHelper>(context);

    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return NoteView(
            note: notes[index],
            onTap: () => openNote(notes[index]),
            numOfImages: 0,
          );
        },
        itemCount: notes.length,
      ),
      bottomNavigationBar: Material(
        elevation: 6,
        color: Theme.of(context).cardColor,
        child: Container(
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: 16),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                padding: EdgeInsets.all(0),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
              ),
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
        ),
      ),
    );
  }

  void updateResults() async {
    notes.clear();
    notes = List.from(
      await helper.getNotesMatchingQuery(query),
    );
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
      double width = MediaQuery.of(context).size.width;
      int numOfImages = 2;

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
}
