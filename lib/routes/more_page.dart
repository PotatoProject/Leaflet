import 'package:flutter/material.dart';
import 'package:potato_notes/widget/default_app_bar.dart';
import 'package:potato_notes/widget/dependent_scaffold.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return DependentScaffold(
      appBar: DefaultAppBar(),
      body: Center(
        child: Text("To be implemented"),
      ),
      floatingActionButton: null,
    );
  }
}
