import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';
import 'package:potato_notes/internal/keystore.dart';
import 'package:potato_notes/internal/shared_prefs.dart';

class Preferences extends ChangeNotifier {
  SharedPrefs prefs;
  Keystore keystore;

  Preferences() {
    loadData();
  }

  String _masterPass;
  ThemeMode _themeMode = ThemeMode.system;
  Color _customAccent;
  bool _useAmoled = false;
  bool _useGrid = false;
  bool _useCustomAccent = false;
  bool _welcomePageSeen = false;
  String _apiUrl;
  String _accessToken;
  String _refreshToken;
  String _username;
  String _email;
  int _logLevel = LogEntry.VERBOSE;
  List<Tag> _tags = [];
  int _lastUpdated;

  String get masterPass => _masterPass;
  ThemeMode get themeMode => _themeMode;
  Color get customAccent => _customAccent;
  bool get useAmoled => _useAmoled;
  bool get useGrid => _useGrid;
  bool get useCustomAccent => _useCustomAccent;
  bool get welcomePageSeen => _welcomePageSeen;
  String get apiUrl => _apiUrl;
  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  String get username => _username;
  String get email => _email;
  int get logLevel => _logLevel;
  List<Tag> get tags => _tags;
  int get lastUpdated => _lastUpdated;

  set masterPass(String value) {
    _masterPass = value;

    if (DeviceInfo.isDesktopOrWeb) {
      prefs.setMasterPass(value);
    } else {
      keystore.setMasterPass(value);
    }

    notifyListeners();
  }

  set themeMode(ThemeMode value) {
    _themeMode = value;
    prefs.setThemeMode(value);
    notifyListeners();
  }

  set customAccent(Color value) {
    _customAccent = value;
    prefs.setCustomAccent(value);
    notifyListeners();
  }

  set useAmoled(bool value) {
    _useAmoled = value;
    prefs.setUseAmoled(value);
    notifyListeners();
  }

  set useGrid(bool value) {
    _useGrid = value;
    prefs.setUseGrid(value);
    notifyListeners();
  }

  set useCustomAccent(bool value) {
    _useCustomAccent = value;
    prefs.setUseCustomAccent(value);
    notifyListeners();
  }

  set welcomePageSeen(bool value) {
    _welcomePageSeen = value;
    prefs.setWelcomePageSeen(value);
    notifyListeners();
  }

  set apiUrl(String value) {
    _apiUrl = value;
    prefs.setApiUrl(value);
    notifyListeners();
  }

  set accessToken(String value) {
    _accessToken = value;
    prefs.setAccessToken(value);
    notifyListeners();
  }

  set refreshToken(String value) {
    _refreshToken = value;
    prefs.setRefreshToken(value);
    notifyListeners();
  }

  set username(String value) {
    _username = value;
    prefs.setUsername(value);
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    prefs.setEmail(value);
    notifyListeners();
  }

  set logLevel(int value) {
    _logLevel = value;
    prefs.setLogLevel(value);
    notifyListeners();
  }

  set lastUpdated(int value) {
    _lastUpdated = value;
    prefs.setLastUpdated(value);
    notifyListeners();
  }

  void loadData() async {
    prefs = await SharedPrefs.newInstance();
    keystore = Keystore();

    _themeMode = await prefs.getThemeMode();
    _useCustomAccent = await prefs.getUseCustomAccent();
    _customAccent = await prefs.getCustomAccent();
    _useAmoled = await prefs.getUseAmoled();
    _useGrid = await prefs.getUseGrid();

    if (DeviceInfo.isDesktopOrWeb) {
      _masterPass = await prefs.getMasterPass();
    } else {
      _masterPass = await keystore.getMasterPass();
    }

    _welcomePageSeen = await prefs.getWelcomePageSeen();
    _apiUrl = await prefs.getApiUrl();
    _accessToken = await prefs.getAccessToken();
    _refreshToken = await prefs.getRefreshToken();
    _username = await prefs.getUsername();
    _email = await prefs.getEmail();
    _logLevel = await prefs.getLogLevel();
    _lastUpdated = await prefs.getLastUpdated();

    tagHelper.watchTags(TagReturnMode.LOCAL).listen((newTags) {
      this._tags = newTags;
      notifyListeners();
    });
  }

  Future<String> getToken() async {
    bool status = true;
    if (_accessToken == null ||
        DateTime.fromMillisecondsSinceEpoch(
                Jwt.parseJwt(_accessToken)["exp"] * 1000)
            .isBefore(DateTime.now())) {
      final response = await AccountController.refreshToken();
      status = response.status;
    }

    if (status) {
      return _accessToken;
    } else {
      throw "Error while refreshing token";
    }
  }

  void triggerRefresh() {
    notifyListeners();
  }
}
