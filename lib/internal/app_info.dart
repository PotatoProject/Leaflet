import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:potato_notes/internal/methods.dart';
import 'package:potato_notes/internal/note_helper.dart';

class AppInfoProvider extends ChangeNotifier {
  AppInfoProvider() {
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

  set followSystemTheme(bool follow) {
    _followSystemTheme = follow;
    setFollowSystemTheme(follow);
    notifyListeners();
  }

  set themeMode(int val) {
    _themeMode = val;
    setThemeMode(val);
    notifyListeners();
  }

  set darkThemeMode(int val) {
    _darkThemeMode = val;
    setDarkThemeMode(val);
    notifyListeners();
  }

  set mainColor(Color color) {
    _mainColor = color;
    notifyListeners();
  }

  set useCustomMainColor(bool use) {
    _useCustomMainColor = use;
    updateMainColor();
    setUseCustomMainColor(use);
    notifyListeners();
  }

  set customMainColor(Color color) {
    _customMainColor = color;
    updateMainColor();
    setCustomMainColor(color);
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

  set remindersNotifIdList(List<String> list) {
    _remindersNotifIdList = list;
    setRemindersNotifIdList(list);
    notifyListeners();
  }

  set storageStatus(PermissionStatus status) {
    _storageStatus = status;
    notifyListeners();
  }

  set sortMode(SortMode sort) {
    _sortMode = sort;
    setSortMode(sort);
    notifyListeners();
  }

  set userImage(String path) {
    _userImage = path;
    setUserImage(path);
    notifyListeners();
  }

  set userName(String name) {
    _userName = name;
    setUserName(name);
    notifyListeners();
  }

  set userEmail(String email) {
    _userEmail = email;
    setUserEmail(email);
    notifyListeners();
  }

  set userToken(String token) {
    _userToken = token;
    setUserToken(token);
    notifyListeners();
  }

  set autoSync(bool autoSync) {
    _autoSync = autoSync;
    setAutoSync(autoSync);
    notifyListeners();
  }

  set autoSyncTimeInterval(int interval) {
    _autoSyncTimeInterval = interval;
    setAutoSyncTimeInterval(interval);
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
    mainColor = _useCustomMainColor
        ? customMainColor
        : Color(await _channel.invokeMethod("getAccentColor"));
  }

  Future<void> loadData() async {
    followSystemTheme = await getFollowSystemTheme();
    themeMode = await getThemeMode();
    darkThemeMode = await getDarkThemeMode();
    mainColor = _useCustomMainColor
        ? customMainColor
        : Color(await _channel.invokeMethod("getAccentColor"));
    useCustomMainColor = await getUseCustomMainColor();
    customMainColor = await getCustomMainColor();
    devShowIdLabels = await getDevShowIdLabels();
    isGridView = await getIsGridView();
    userImage = await getUserImage();
    isQuickStarredGestureOn = await getIsQuickStarredGestureOn();
    notificationsIdList = await getNotificationsIdList();
    remindersNotifIdList = await getRemindersNotifIdList();
    storageStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    sortMode = await getSortMode();

    userToken = await getUserToken();
    userName = await getUserName();
    userEmail = await getUserEmail();

    autoSync = await getAutoSync();
    autoSyncTimeInterval = await getAutoSyncTimeInterval();

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
