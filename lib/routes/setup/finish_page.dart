import 'package:flutter/material.dart';

class FinishPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.check),
        title: Text("All set!"),
        textTheme: Theme.of(context).textTheme,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Text(
            "Now you're ready to enjoy PotatoNotes to its fullest. \nIf you want to customize more head over to the settings page in the side drawer, instead if you want to manage your PotatoSync account instead click your avatar on the top bar.",
          ),
        ],
      ),
    );
  }
}
