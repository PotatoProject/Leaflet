import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/keystore.dart';
import 'package:potato_notes/internal/shared_prefs.dart';
import 'package:potato_notes/internal/tag_model.dart';

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
  List<TagModel> _tags = [];

  String get masterPass => _masterPass;
  ThemeMode get themeMode => _themeMode;
  Color get customAccent => _customAccent;
  bool get useAmoled => _useAmoled;
  bool get useGrid => _useGrid;
  bool get useCustomAccent => _useCustomAccent;
  bool get welcomePageSeen => _welcomePageSeen;
  String get apiUrl => _apiUrl;
  Future<String> get token async => await getToken();
  String get username => _username;
  String get email => _email;
  int get logLevel => _logLevel;
  List<TagModel> get tags => _tags;

  set masterPass(String value) {
    _masterPass = value;

    if (kIsWeb) {
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

  set tags(List<TagModel> value) {
    _tags = value;
    prefs.setTags(value);
    notifyListeners();
  }

  void loadData() async {
    prefs = await SharedPrefs.newInstance();
    keystore = Keystore();

    if (kIsWeb) {
      masterPass = await prefs.getMasterPass();
    } else {
      masterPass = await keystore.getMasterPass();
    }
    themeMode = await prefs.getThemeMode();
    customAccent = await prefs.getCustomAccent();
    useAmoled = await prefs.getUseAmoled();
    useGrid = await prefs.getUseGrid();
    useCustomAccent = await prefs.getUseCustomAccent();
    welcomePageSeen = await prefs.getWelcomePageSeen();
    apiUrl = await prefs.getApiUrl();
    accessToken = await prefs.getAccessToken();
    refreshToken = await prefs.getRefreshToken();
    username = await prefs.getUsername();
    email = await prefs.getEmail();
    logLevel = await prefs.getLogLevel();
    tags = await prefs.getTags();
  }

  Future<String> getToken() async {
    if (_accessToken == null ||
        DateTime.fromMillisecondsSinceEpoch(
                Jwt.parseJwt(_accessToken)["exp"] * 1000)
            .isBefore(DateTime.now())) {
      Response response = await post(
        "$apiUrl/api/users/refresh",
        body: "{\"token\": \"$_refreshToken\"}",
      );
      if (response.statusCode == 200) {
        _accessToken = json.decode(response.body)["token"];
      } else {
        print(response.body);
      }
    }

    return _accessToken;
  }
}
