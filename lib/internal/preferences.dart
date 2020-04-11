import 'package:flutter/material.dart';
import 'package:potato_notes/internal/keystore.dart';
import 'package:potato_notes/internal/shared_preferences.dart';

class Preferences extends ChangeNotifier {
  SharedPrefs prefs;
  Keystore keystore;

  Preferences() {
    loadData();
  }

  String _masterPass;
  bool _useGrid = false;

  String get masterPass => _masterPass;
  bool get useGrid => _useGrid;

  set masterPass(String value) {
    _masterPass = value;
    keystore.setMasterPass(value);
    notifyListeners();
  }

  set useGrid(bool value) {
    _useGrid = value;
    prefs.setUseGrid(value);
    notifyListeners();
  }

  void loadData() async {
    prefs = await SharedPrefs.newInstance();
    keystore = Keystore();

    masterPass = await keystore.getMasterPass();
    useGrid = await prefs.getUseGrid();
  }
}