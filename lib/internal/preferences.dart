import 'package:flutter/material.dart';
import 'package:potato_notes/internal/shared_preferences.dart';

class Preferences extends ChangeNotifier {
  SharedPrefs prefs;

  Preferences() {
    loadData();
  }

  PassType _passType = PassType.NONE;
  String _masterPassword;
  String _masterPin;
  bool _useGrid = false;

  PassType get passType => _passType;
  String get masterPassword => _masterPassword;
  String get masterPin => _masterPin;
  bool get useGrid => _useGrid;

  set passType(PassType value) {
    _passType = value;
    prefs.setPassType(value);
    notifyListeners();
  }

  set masterPassword(String value) {
    _masterPassword = value;
    prefs.setMasterPassword(value);
    notifyListeners();
  }

  set masterPin(String value) {
    _masterPin = value;
    prefs.setMasterPin(value);
    notifyListeners();
  }

  set useGrid(bool value) {
    _useGrid = value;
    prefs.setUseGrid(value);
    notifyListeners();
  }

  void loadData() async {
    prefs = await SharedPrefs.newInstance();

    passType = await prefs.getPassType();
    masterPassword = await prefs.getMasterPassword();
    masterPin = await prefs.getMasterPin();
    useGrid = await prefs.getUseGrid();
  }
}

enum PassType {
  NONE,
  PIN,
  PASSWORD,
}