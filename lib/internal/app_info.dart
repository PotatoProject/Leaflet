import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:potato_notes/internal/methods.dart';

class AppInfoProvider extends ChangeNotifier {
  AppInfoProvider() {
    loadData();
  }

  int _themeMode = 0;
  Color _mainColor = Colors.blue;
  bool _devShowIdLabels = false;
  bool _isGridView = false;
  String _userImagePath;
  String _userName = "";
  bool _isQuickStarredGestureOn = false;
  List<String> _notificationsIdList = [];
  PermissionStatus _storageStatus = PermissionStatus.unknown;

  int get themeMode => _themeMode;
  Color get mainColor => _mainColor;
  bool get devShowIdLabels => _devShowIdLabels;
  bool get isGridView => _isGridView;
  String get userImagePath => _userImagePath;
  String get userName => _userName;
  bool get isQuickStarredGestureOn => _isQuickStarredGestureOn;
  List<String> get notificationsIdList => _notificationsIdList;
  PermissionStatus get storageStatus => _storageStatus;

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

  set isQuickStarredGestureOn(bool isOn) {
    _isQuickStarredGestureOn = isOn;
    setIsQuickStarredGestureOn(isOn);
    notifyListeners();
  }

  set notificationsIdList(List<String> list) {
    _notificationsIdList = list;
    setNotificationsIdList(list);
    notifyListeners();
  }

  set storageStatus(PermissionStatus status) {
    _storageStatus = status;
    notifyListeners();
  }

  Future<void> loadData() async {
    themeMode = await getThemeMode();
    mainColor = await getMainColor();
    devShowIdLabels = await getDevShowIdLabels();
    isGridView = await getIsGridView();
    userImagePath = await getUserImagePath();
    userName = await getUserNameString();
    isQuickStarredGestureOn = await getIsQuickStarredGestureOn();
    notificationsIdList = await getNotificationsIdList();
    storageStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  }
}