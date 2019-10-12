import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/methods.dart';

class SearchFiltersProvider extends ChangeNotifier {
  SearchFiltersProvider() {
    loadData();
  }

  int _color = null;
  int _date = null;
  bool _caseSensitive = false;

  int get color => _color;

  int get date => _date;

  bool get caseSensitive => _caseSensitive;

  set color(int color) {
    _color = color;
    filtersSetColor(color);
    notifyListeners();
  }

  set date(int date) {
    _date = date;
    filtersSetDate(date);
    notifyListeners();
  }

  set caseSensitive(bool caseSensitive) {
    _caseSensitive = caseSensitive;
    filtersSetCaseSensitive(caseSensitive);
    notifyListeners();
  }

  Future<void> loadData() async {
    color = await filtersGetColor();
    date = await filtersGetDate();
    caseSensitive = await filtersGetCaseSensitive();
  }
}
