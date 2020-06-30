import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences prefs;

  SharedPrefs._(this.prefs);
  static Future<SharedPrefs> newInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return SharedPrefs._(preferences);
  }

  Future<String> getMasterPass() async {
    return prefs.getString("master_pass") ?? "";
  }

  void setMasterPass(String value) async {
    await prefs.setString("master_pass", value);
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

  Future<Color> getCustomAccent() async {
    int colorValue = prefs.getInt("custom_accent");
    if(colorValue != null)
      return Color(colorValue);
    else
      return null;
  }

  void setCustomAccent(Color value) async {
    await prefs.setInt("custom_accent", value?.value);
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

  Future<bool> getUseCustomAccent() async {
    return prefs.getBool("use_custom_accent") ?? false;
  }

  void setUseCustomAccent(bool value) async {
    await prefs.setBool("use_custom_accent", value);
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

  Future<int> getLogLevel() async {
    return prefs.getInt("log_level") ?? LogEntry.VERBOSE;
  }

  void setLogLevel(int value) async {
    await prefs.setInt("log_level", value);
  }
}
