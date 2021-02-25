import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPrefs _instance;
  final SharedPreferences prefs;

  SharedPrefs._(this.prefs);

  static Future<void> init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _instance = SharedPrefs._(preferences);
  }

  static SharedPrefs get instance => _instance;

  String get masterPass {
    return prefs.getString("master_pass") ?? "";
  }

  set masterPass(String value) {
    //TODO Only remove comment chars after master_pass is hashed before saving
    //addChangedKey("master_pass");
    setString("master_pass", value);
  }

  ThemeMode get themeMode {
    final int value = prefs.getInt("theme_mode");
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

  set themeMode(ThemeMode value) {
    addChangedKey("theme_mode");
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
    setInt("theme_mode", newValue);
  }

  Color get customAccent {
    final int colorValue = prefs.getInt("custom_accent");
    if (colorValue != null)
      return Color(colorValue);
    else
      return null;
  }

  set customAccent(Color value) {
    addChangedKey("custom_accent");
    setInt("custom_accent", value?.value);
  }

  bool get useAmoled {
    return prefs.getBool("use_amoled") ?? false;
  }

  set useAmoled(bool value) {
    addChangedKey("use_amoled");
    setBool("use_amoled", value);
  }

  bool get useGrid {
    return prefs.getBool("use_grid") ?? DeviceInfo.isDesktop;
  }

  set useGrid(bool value) {
    addChangedKey("use_grid");
    setBool("use_grid", value);
  }

  bool get useCustomAccent {
    return prefs.getBool("use_custom_accent") ?? false;
  }

  set useCustomAccent(bool value) {
    addChangedKey("use_custom_accent");
    setBool("use_custom_accent", value);
  }

  bool get welcomePageSeen {
    return prefs.getBool("welcome_page_seen_v2") ?? false;
  }

  set welcomePageSeen(bool value) {
    setBool("welcome_page_seen_v2", value);
  }

  String get apiUrl {
    return prefs.getString("api_url") ?? Utils.defaultApiUrl;
  }

  set apiUrl(String value) {
    setString("api_url", value);
  }

  String get accessToken {
    return prefs.getString("access_token");
  }

  set accessToken(String value) {
    setString("access_token", value);
  }

  String get refreshToken {
    return prefs.getString("refresh_token");
  }

  set refreshToken(String value) {
    setString("refresh_token", value);
  }

  String get username {
    return prefs.getString("username");
  }

  set username(String value) {
    setString("username", value);
  }

  String get email {
    return prefs.getString("email");
  }

  set email(String value) {
    setString("email", value);
  }

  String get avatarUrl {
    return prefs.getString("avatar_url");
  }

  set avatarUrl(String value) {
    setString("avatar_url", value);
  }

  int get logLevel {
    return prefs.getInt("log_level") ?? LogEntry.VERBOSE;
  }

  set logLevel(int value) {
    setInt("log_level", value);
  }

  List<String> get downloadedImages {
    return prefs.getStringList("downloaded_images") ?? [];
  }

  set downloadedImages(List<String> value) {
    setStringList("downloaded_images", value);
  }

  List<String> get deletedImages {
    return prefs.getStringList("deleted_images") ?? [];
  }

  set deletedImages(List<String> value) {
    setStringList("deleted_images", value);
  }

  int get lastUpdated {
    return prefs.getInt("last_updated") ?? 0;
  }

  set lastUpdated(int value) {
    setInt("last_updated", value);
  }

  void addChangedKey(String key) {
    var changedKeys = prefs.getStringList("updated_keys") ?? [];
    if (!changedKeys.contains(key)) {
      changedKeys.add(key);
    }
    setStringList("updated_keys", changedKeys);
  }

  void clearChangedKeys() {
    prefs.remove("updated_keys");
  }

  List<String> get changedKeys {
    return prefs.getStringList("updated_keys") ?? [];
  }

  String get deleteQueue {
    return prefs.getString("delete_queue");
  }

  set deleteQueue(String value) {
    setString("delete_queue", value);
  }

  void setBool(String key, bool value) {
    if (value == null) {
      prefs.remove(key);
    } else {
      prefs.setBool(key, value);
    }
  }

  void setDouble(String key, double value) {
    if (value == null) {
      prefs.remove(key);
    } else {
      prefs.setDouble(key, value);
    }
  }

  void setInt(String key, int value) {
    if (value == null) {
      prefs.remove(key);
    } else {
      prefs.setInt(key, value);
    }
  }

  void setString(String key, String value) {
    if (value == null) {
      prefs.remove(key);
    } else {
      prefs.setString(key, value);
    }
  }

  void setStringList(String key, List<String> value) {
    if (value == null) {
      prefs.remove(key);
    } else {
      prefs.setStringList(key, value);
    }
  }
}
