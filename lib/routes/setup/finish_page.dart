import 'package:flutter/material.dart';
import 'package:potato_notes/internal/providers.dart';

class FinishPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.check),
        title: Text(strings.setup.finishTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            strings.setup.finishLastWords,
          ),
        ],
      ),
    );
  }
}
