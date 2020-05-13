import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences prefs;

  SharedPrefs._(this.prefs);
  static Future<SharedPrefs> newInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return SharedPrefs._(preferences);
  }

  Future<ThemeMode> getThemeMode() async {
    int value = prefs.getInt("theme_mode");
    switch (value) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode value) async {
    int newValue;
    switch (value) {
      case ThemeMode.system:
        newValue = 0;
        break;
      case ThemeMode.light:
        newValue = 1;
        break;
      case ThemeMode.dark:
        newValue = 2;
        break;
    }
    await prefs.setInt("theme_mode", newValue);
  }

  Future<bool> getUseAmoled() async {
    return prefs.getBool("use_amoled") ?? false;
  }

  void setUseAmoled(bool value) async {
    await prefs.setBool("use_amoled", value);
  }

  Future<bool> getUseGrid() async {
    return prefs.getBool("use_grid") ?? false;
  }

  void setUseGrid(bool value) async {
    await prefs.setBool("use_grid", value);
  }

  Future<String> getApiUrl() async {
    return prefs.getString("api_url") ?? "https://sync.potatoproject.co";
  }

  void setApiUrl(String value) async {
    await prefs.setString("api_url", value);
  }

  Future<String> getAccessToken() async {
    return prefs.getString("access_token");
  }

  void setAccessToken(String value) async {
    await prefs.setString("access_token", value);
  }

  Future<String> getRefreshToken() async {
    return prefs.getString("refresh_token");
  }

  void setRefreshToken(String value) async {
    await prefs.setString("refresh_token", value);
  }

  Future<String> getUsername() async {
    return prefs.getString("username");
  }

  void setUsername(String value) async {
    await prefs.setString("username", value);
  }

  Future<String> getEmail() async {
    return prefs.getString("email");
  }

  void setEmail(String value) async {
    await prefs.setString("email", value);
  }
}
