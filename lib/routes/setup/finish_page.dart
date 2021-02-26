import 'package:flutter/material.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';

class FinishPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.check),
        title: Text(LocaleStrings.setup.finishTitle),
        textTheme: Theme.of(context).textTheme,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Text(
            LocaleStrings.setup.finishLastWords,
          ),
        ],
      ),
    );
  }
}
