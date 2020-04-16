import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jwt_decode/jwt_decode.dart';
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
  String _apiUrl;
  String _accessToken;
  String _refreshToken;
  String _username;
  String _email;

  String get masterPass => _masterPass;
  bool get useGrid => _useGrid;
  String get apiUrl => _apiUrl;
  Future<String> get token async => await getToken();
  String get username => _username;
  String get email => _email;

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

  void loadData() async {
    prefs = await SharedPrefs.newInstance();
    keystore = Keystore();

    masterPass = await keystore.getMasterPass();
    useGrid = await prefs.getUseGrid();
    apiUrl = await prefs.getApiUrl();
    accessToken = await prefs.getAccessToken();
    refreshToken = await prefs.getRefreshToken();
    username = await prefs.getUsername();
    email = await prefs.getEmail();
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
