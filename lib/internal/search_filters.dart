import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/methods.dart';

class SearchFiltersProvider extends ChangeNotifier {
  Preferences preferences;

  SearchFiltersProvider() {
    init();
  }

  void init() async {
    preferences = await Preferences().create();
    loadData();
  }

  int _color;
  int _date;
  bool _caseSensitive = false;

  int get color => _color;

  int get date => _date;

  bool get caseSensitive => _caseSensitive;

  set color(int color) {
    _color = color;
    preferences.filtersSetColor(color);
    notifyListeners();
  }

  set date(int date) {
    _date = date;
    preferences.filtersSetDate(date);
    notifyListeners();
  }

  set caseSensitive(bool caseSensitive) {
    _caseSensitive = caseSensitive;
    preferences.filtersSetCaseSensitive(caseSensitive);
    notifyListeners();
  }

  void loadData() {
    color = preferences.filtersGetColor();
    date = preferences.filtersGetDate();
    caseSensitive = preferences.filtersGetCaseSensitive();
  }
}
