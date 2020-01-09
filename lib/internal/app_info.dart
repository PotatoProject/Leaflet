import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:potato_notes/internal/methods.dart';
import 'package:potato_notes/internal/note_helper.dart';

class AppInfoProvider extends ChangeNotifier {
  Preferences preferences;

  AppInfoProvider() {
    init();
  }

  void init() async {
    preferences = await Preferences().create();
    loadData();
  }

  static MethodChannel _channel = MethodChannel("potato_notes_utils");

  bool _followSystemTheme = true;
  int _themeMode = 0;
  int _darkThemeMode = 0;
  Color _mainColor = Color(0xFFFF0000);
  bool _useCustomMainColor = false;
  Color _customMainColor = Color(0xFFFF0000);
  bool _devShowIdLabels = false;
  bool _isGridView = false;
  bool _isQuickStarredGestureOn = false;
  List<String> _notificationsIdList = [];
  List<String> _remindersNotifIdList = [];
  PermissionStatus _storageStatus = PermissionStatus.unknown;
  SortMode _sortMode = SortMode.ID;

  String _userImage;
  String _userName = "";
  String _userEmail = "";
  String _userToken;

  bool _autoSync = false;
  int _autoSyncTimeInterval = 15;

  DateTime _date;
  TimeOfDay _time;
  int _hideContent = 0;
  bool _useProtectionForNoteContent = false;
  bool _pin = false;
  bool _password = false;
  String _version = '1.0';

  bool get followSystemTheme => _followSystemTheme;
  int get themeMode => _themeMode;
  int get darkThemeMode => _darkThemeMode;
  Color get mainColor => _mainColor;
  bool get useCustomMainColor => _useCustomMainColor;
  Color get customMainColor => _customMainColor;
  bool get devShowIdLabels => _devShowIdLabels;
  bool get isGridView => _isGridView;
  bool get isQuickStarredGestureOn => _isQuickStarredGestureOn;
  List<String> get notificationsIdList => _notificationsIdList;
  List<String> get remindersNotifIdList => _remindersNotifIdList;
  PermissionStatus get storageStatus => _storageStatus;
  SortMode get sortMode => _sortMode;

  String get userImage => _userImage;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userToken => _userToken;

  bool get autoSync => _autoSync;
  int get autoSyncTimeInterval => _autoSyncTimeInterval;

  DateTime get date => _date;
  TimeOfDay get time => _time;
  int get hideContent => _hideContent;
  bool get useProtectionForNoteContent => _useProtectionForNoteContent;
  bool get pin => _pin;
  bool get password => _password;
  String get version => _version;

  static List<String> get supportedLocales => [
        "en",
        'fr',
        "id",
        "it",
        "pl",
        "ru",
        "uk",
        "zh",
      ];

  bool supportsSystemAccent = true;

  set followSystemTheme(bool follow) {
    _followSystemTheme = follow;
    preferences.setFollowSystemTheme(follow);
    notifyListeners();
  }

  set themeMode(int val) {
    _themeMode = val;
    preferences.setThemeMode(val);
    notifyListeners();
  }

  set darkThemeMode(int val) {
    _darkThemeMode = val;
    preferences.setDarkThemeMode(val);
    notifyListeners();
  }

  set mainColor(Color color) {
    _mainColor = color;
    notifyListeners();
  }

  set useCustomMainColor(bool use) {
    _useCustomMainColor = use;
    updateMainColor();
    preferences.setUseCustomMainColor(use);
    notifyListeners();
  }

  set customMainColor(Color color) {
    _customMainColor = color;
    updateMainColor();
    preferences.setCustomMainColor(color);
    notifyListeners();
  }

  set devShowIdLabels(bool val) {
    _devShowIdLabels = val;
    preferences.setDevShowIdLabels(val);
    notifyListeners();
  }

  set isGridView(bool val) {
    _isGridView = val;
    preferences.setIsGridView(val);
    notifyListeners();
  }

  set isQuickStarredGestureOn(bool isOn) {
    _isQuickStarredGestureOn = isOn;
    preferences.setIsQuickStarredGestureOn(isOn);
    notifyListeners();
  }

  set notificationsIdList(List<String> list) {
    _notificationsIdList = list;
    preferences.setNotificationsIdList(list);
    notifyListeners();
  }

  set remindersNotifIdList(List<String> list) {
    _remindersNotifIdList = list;
    preferences.setRemindersNotifIdList(list);
    notifyListeners();
  }

  set storageStatus(PermissionStatus status) {
    _storageStatus = status;
    notifyListeners();
  }

  set sortMode(SortMode sort) {
    _sortMode = sort;
    preferences.setSortMode(sort);
    notifyListeners();
  }

  set userImage(String path) {
    _userImage = path;
    preferences.setUserImage(path);
    notifyListeners();
  }

  set userName(String name) {
    _userName = name;
    preferences.setUserName(name);
    notifyListeners();
  }

  set userEmail(String email) {
    _userEmail = email;
    preferences.setUserEmail(email);
    notifyListeners();
  }

  set userToken(String token) {
    _userToken = token;
    preferences.setUserToken(token);
    notifyListeners();
  }

  set autoSync(bool autoSync) {
    _autoSync = autoSync;
    preferences.setAutoSync(autoSync);
    notifyListeners();
  }

  set autoSyncTimeInterval(int interval) {
    _autoSyncTimeInterval = interval;
    preferences.setAutoSyncTimeInterval(interval);
    notifyListeners();
  }

  set date(DateTime passedDate) {
    _date = passedDate;
    notifyListeners();
  }

  set time(TimeOfDay passedTime) {
    _time = passedTime;
    notifyListeners();
  }

  set hideContent(int val) {
    _hideContent = val;
    notifyListeners();
  }

  set useProtectionForNoteContent(bool doUse) {
    _useProtectionForNoteContent = doUse;
    notifyListeners();
  }

  set pin(bool use) {
    _pin = use;
    notifyListeners();
  }

  set password(bool use) {
    _password = use;
    notifyListeners();
  }

  set version(String val) {
    _version = val;
    notifyListeners();
  }

  Future<void> updateMainColor() async {
    int sysAccent = await _channel.invokeMethod("getAccentColor");

    if (sysAccent == null) {
      supportsSystemAccent = false;
      useCustomMainColor = true;
    }

    mainColor = _useCustomMainColor || !supportsSystemAccent
        ? customMainColor
        : Color(sysAccent);
  }

  Future<void> loadData() async {
    followSystemTheme = preferences.getFollowSystemTheme();
    themeMode = preferences.getThemeMode();
    darkThemeMode = preferences.getDarkThemeMode();
    useCustomMainColor = preferences.getUseCustomMainColor();
    updateMainColor();
    customMainColor = preferences.getCustomMainColor();
    devShowIdLabels = preferences.getDevShowIdLabels();
    isGridView = preferences.getIsGridView();
    userImage = preferences.getUserImage();
    isQuickStarredGestureOn = preferences.getIsQuickStarredGestureOn();
    notificationsIdList = preferences.getNotificationsIdList();
    remindersNotifIdList = preferences.getRemindersNotifIdList();
    storageStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    sortMode = preferences.getSortMode();

    userToken = preferences.getUserToken();
    userName = preferences.getUserName();
    userEmail = preferences.getUserEmail();

    autoSync = preferences.getAutoSync();
    autoSyncTimeInterval = preferences.getAutoSyncTimeInterval();

    date = null;
    time = null;
    hideContent = 0;
    useProtectionForNoteContent = false;
    pin = false;
    password = false;

    final packageInfo = (await PackageInfo.fromPlatform());
    version = '${packageInfo.version}+${packageInfo.buildNumber}';
  }
}
