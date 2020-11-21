import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPrefs _instance;
  SharedPreferences prefs;

  SharedPrefs._(this.prefs);

  static Future<void> init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _instance = SharedPrefs._(preferences);
  }

  static SharedPrefs get instance => _instance;

  Future<String> getMasterPass() async {
    return prefs.getString("master_pass") ?? "";
  }

  void setMasterPass(String? value) async {
    //TODO Only remove comment chars after master_pass is hashed before saving
    //addChangedKey("master_pass");
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
    await prefs.setInt("theme_mode", newValue);
  }

  Future<Color?> getCustomAccent() async {
    int? colorValue = prefs.getInt("custom_accent") as int?;
    if (colorValue != null)
      return Color(colorValue);
    else
      return null;
  }

  void setCustomAccent(Color? value) async {
    addChangedKey("custom_accent");
    await prefs.setInt("custom_accent", value?.value);
  }

  Future<bool> getUseAmoled() async {
    return prefs.getBool("use_amoled") ?? false;
  }

  void setUseAmoled(bool value) async {
    addChangedKey("use_amoled");
    await prefs.setBool("use_amoled", value);
  }

  Future<bool> getUseGrid() async {
    return prefs.getBool("use_grid") ?? DeviceInfo.isDesktop;
  }

  void setUseGrid(bool value) async {
    addChangedKey("use_grid");
    await prefs.setBool("use_grid", value);
  }

  Future<bool> getUseCustomAccent() async {
    return prefs.getBool("use_custom_accent") ?? false;
  }

  void setUseCustomAccent(bool value) async {
    addChangedKey("use_custom_accent");
    await prefs.setBool("use_custom_accent", value);
  }

  Future<bool> getWelcomePageSeen() async {
    return prefs.getBool("welcome_page_seen_v2") ?? false;
  }

  void setWelcomePageSeen(bool value) async {
    await prefs.setBool("welcome_page_seen_v2", value);
  }

  Future<String> getApiUrl() async {
    // http://stats.corbellum.nl/api/v2
    return prefs.getString("api_url") ?? Utils.defaultApiUrl;
  }

  void setApiUrl(String value) async {
    await prefs.setString("api_url", value);
  }

  Future<String?> getAccessToken() async {
    return prefs.getString("access_token");
  }

  void setAccessToken(String? value) async {
    await prefs.setString("access_token", value);
  }

  Future<String?> getRefreshToken() async {
    return prefs.getString("refresh_token");
  }

  void setRefreshToken(String? value) async {
    await prefs.setString("refresh_token", value);
  }

  Future<String?> getUsername() async {
    return prefs.getString("username");
  }

  void setUsername(String? value) async {
    await prefs.setString("username", value);
  }

  Future<String?> getEmail() async {
    return prefs.getString("email");
  }

  void setEmail(String? value) async {
    await prefs.setString("email", value);
  }

  Future<int> getLogLevel() async {
    return prefs.getInt("log_level") ?? LogEntry.VERBOSE;
  }

  void setLogLevel(int value) async {
    await prefs.setInt("log_level", value);
  }

  Future<List<String>> getDownloadedImages() async {
    return prefs.getStringList("downloaded_images") ?? [];
  }

  void setDownloadedImages(List<String> value) async {
    await prefs.setStringList("downloaded_images", value);
  }

  Future<List<String>> getDeletedImages() async {
    return prefs.getStringList("deleted_images") ?? [];
  }

  void setDeletedImages(List<String> value) async {
    await prefs.setStringList("deleted_images", value);
  }

  Future<int> getLastUpdated() async {
    return prefs.getInt("last_updated") ?? 0;
  }

  void setLastUpdated(int value) async {
    await prefs.setInt("last_updated", value);
  }

  void addChangedKey(String key) async {
    var changedKeys = prefs.getStringList("updated_keys") ?? [];
    if (!changedKeys.contains(key)) {
      changedKeys.add(key);
    }
    await prefs.setStringList("updated_keys", changedKeys);
  }

  void clearChangedKeys() async {
    await prefs.setStringList("updated_keys", null);
  }

  List<String> getChangedKeys() {
    return prefs.getStringList("updated_keys") ?? [];
  }
}
