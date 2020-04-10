import 'package:flutter/material.dart';
import 'package:potato_notes/internal/shared_preferences.dart';

class Preferences extends ChangeNotifier {
  SharedPrefs prefs;

  Preferences() {
    loadData();
  }

  bool _useGrid = false;

  bool get useGrid => _useGrid;

  set useGrid(bool value) {
    _useGrid = value;
    prefs.setUseGrid(value);
    notifyListeners();
  }

  void loadData() async {
    prefs = await SharedPrefs.newInstance();

    useGrid = await prefs.getUseGrid();
  }
}
