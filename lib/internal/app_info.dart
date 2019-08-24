import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/methods.dart';

class AppInfoProvider extends ChangeNotifier {
  AppInfoProvider() {
    loadData();
  }

  int _themeMode = 0;
  Color _mainColor = Colors.blue;
  bool _devShowIdLabels = false;
  bool _isGridView = false;
  String _userImagePath = "";
  String _userName = "User";

  int get themeMode => _themeMode;
  Color get mainColor => _mainColor;
  bool get devShowIdLabels => _devShowIdLabels;
  bool get isGridView => _isGridView;
  String get userImagePath => _userImagePath;
  String get userName => _userName;

  set themeMode(int val) {
    _themeMode = val;
    setThemeMode(val);
    notifyListeners();
  }

  set mainColor(Color color) {
    _mainColor = color;
    setMainColor(color);
    notifyListeners();
  }

  set devShowIdLabels(bool val) {
    _devShowIdLabels = val;
    setDevShowIdLabels(val);
    notifyListeners();
  }

  set isGridView(bool val) {
    _isGridView = val;
    setIsGridView(val);
    notifyListeners();
  }

  set userImagePath(String path) {
    _userImagePath = path;
    setUserImagePath(path);
    notifyListeners();
  }

  set userName(String name) {
    _userName = name;
    setUserNameString(name);
    notifyListeners();
  }

  Future<void> loadData() async {
    themeMode = await getThemeMode();
    mainColor = await getMainColor();
    devShowIdLabels = await getDevShowIdLabels();
    isGridView = await getIsGridView();
    userImagePath = await getUserImagePath();
    userName = await getUserNameString();
  }
}