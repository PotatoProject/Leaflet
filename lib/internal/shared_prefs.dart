import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPrefs _instance;
  final SharedPreferences prefs;
  final _SharedPreferencesQueue _queue;

  SharedPrefs._(this.prefs) : _queue = _SharedPreferencesQueue(prefs);

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
    _queue.setString("master_pass", value);
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
    _queue.setInt("theme_mode", newValue);
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
    _queue.setInt("custom_accent", value?.value);
  }

  bool get useAmoled {
    return prefs.getBool("use_amoled") ?? false;
  }

  set useAmoled(bool value) {
    addChangedKey("use_amoled");
    _queue.setBool("use_amoled", value);
  }

  bool get useGrid {
    return prefs.getBool("use_grid") ?? DeviceInfo.isDesktop;
  }

  set useGrid(bool value) {
    addChangedKey("use_grid");
    _queue.setBool("use_grid", value);
  }

  bool get useCustomAccent {
    return prefs.getBool("use_custom_accent") ?? false;
  }

  set useCustomAccent(bool value) {
    addChangedKey("use_custom_accent");
    _queue.setBool("use_custom_accent", value);
  }

  bool get welcomePageSeen {
    return prefs.getBool("welcome_page_seen_v2") ?? false;
  }

  set welcomePageSeen(bool value) {
    _queue.setBool("welcome_page_seen_v2", value);
  }

  String get apiUrl {
    return prefs.getString("api_url") ?? Utils.defaultApiUrl;
  }

  set apiUrl(String value) {
    _queue.setString("api_url", value);
  }

  String get accessToken {
    return prefs.getString("access_token");
  }

  set accessToken(String value) {
    _queue.setString("access_token", value);
  }

  String get refreshToken {
    return prefs.getString("refresh_token");
  }

  set refreshToken(String value) {
    _queue.setString("refresh_token", value);
  }

  String get username {
    return prefs.getString("username");
  }

  set username(String value) {
    _queue.setString("username", value);
  }

  String get email {
    return prefs.getString("email");
  }

  set email(String value) {
    _queue.setString("email", value);
  }

  String get avatarUrl {
    return prefs.getString("avatar_url");
  }

  set avatarUrl(String value) {
    _queue.setString("avatar_url", value);
  }

  int get logLevel {
    return prefs.getInt("log_level") ?? LogEntry.VERBOSE;
  }

  set logLevel(int value) {
    _queue.setInt("log_level", value);
  }

  List<String> get downloadedImages {
    return prefs.getStringList("downloaded_images") ?? [];
  }

  set downloadedImages(List<String> value) {
    _queue.setStringList("downloaded_images", value);
  }

  List<String> get deletedImages {
    return prefs.getStringList("deleted_images") ?? [];
  }

  set deletedImages(List<String> value) {
    _queue.setStringList("deleted_images", value);
  }

  int get lastUpdated {
    return prefs.getInt("last_updated") ?? 0;
  }

  set lastUpdated(int value) {
    _queue.setInt("last_updated", value);
  }

  void addChangedKey(String key) {
    var changedKeys = prefs.getStringList("updated_keys") ?? [];
    if (!changedKeys.contains(key)) {
      changedKeys.add(key);
    }
    _queue.setStringList("updated_keys", changedKeys);
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
    _queue.setString("delete_queue", value);
  }
}

class _SharedPreferencesQueue {
  final SharedPreferences prefs;
  final List<_QueueItem> _queue = [];

  _SharedPreferencesQueue(this.prefs);

  void _handleRequest() {
    final _QueueItem item = _queue.first;

    if (item.requestType == _QueueRequestType.REMOVE) {
      prefs.remove(item.key);
    } else {
      switch (item.type) {
        case _QueueItemType.BOOL:
          prefs.setBool(item.key, item.value);
          break;
        case _QueueItemType.DOUBLE:
          prefs.setDouble(item.key, item.value);
          break;
        case _QueueItemType.INT:
          prefs.setInt(item.key, item.value);
          break;
        case _QueueItemType.STRING:
          prefs.setString(item.key, item.value);
          break;
        case _QueueItemType.STRING_LIST:
          prefs.setStringList(item.key, item.value);
          break;
      }
    }

    _queue.remove(item);

    if (_queue.isNotEmpty) _handleRequest();
  }

  void _set(_QueueItem item) {
    _queue.add(item);
    if (_queue.length == 1) _handleRequest();
  }

  void setBool(String key, bool value) {
    _set(_QueueItem.bool(
      key: key,
      value: value,
      requestType:
          value == null ? _QueueRequestType.REMOVE : _QueueRequestType.SET,
    ));
  }

  void setDouble(String key, double value) {
    _set(_QueueItem.double(
      key: key,
      value: value,
      requestType:
          value == null ? _QueueRequestType.REMOVE : _QueueRequestType.SET,
    ));
  }

  void setInt(String key, int value) {
    _set(_QueueItem.int(
      key: key,
      value: value,
      requestType:
          value == null ? _QueueRequestType.REMOVE : _QueueRequestType.SET,
    ));
  }

  void setString(String key, String value) {
    _set(_QueueItem.string(
      key: key,
      value: value,
      requestType:
          value == null ? _QueueRequestType.REMOVE : _QueueRequestType.SET,
    ));
  }

  void setStringList(String key, List<String> value) {
    _set(_QueueItem.stringList(
      key: key,
      value: value,
      requestType:
          value == null ? _QueueRequestType.REMOVE : _QueueRequestType.SET,
    ));
  }
}

class _QueueItem {
  final String key;
  final Object value;
  final _QueueRequestType requestType;
  final _QueueItemType type;

  const _QueueItem.bool({
    @required this.key,
    bool value,
    this.requestType = _QueueRequestType.SET,
  })  : value = value,
        type = _QueueItemType.BOOL;

  const _QueueItem.double({
    @required this.key,
    double value,
    this.requestType = _QueueRequestType.SET,
  })  : value = value,
        type = _QueueItemType.DOUBLE;

  const _QueueItem.int({
    @required this.key,
    int value,
    this.requestType = _QueueRequestType.SET,
  })  : value = value,
        type = _QueueItemType.INT;

  const _QueueItem.string({
    @required this.key,
    String value,
    this.requestType = _QueueRequestType.SET,
  })  : value = value,
        type = _QueueItemType.STRING;

  const _QueueItem.stringList({
    @required this.key,
    List<String> value,
    this.requestType = _QueueRequestType.SET,
  })  : value = value,
        type = _QueueItemType.STRING_LIST;
}

enum _QueueItemType {
  STRING,
  INT,
  DOUBLE,
  BOOL,
  STRING_LIST,
}

enum _QueueRequestType {
  SET,
  REMOVE,
}
