import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:loggy/loggy.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';
import 'package:potato_notes/internal/keystore.dart';
import 'package:potato_notes/internal/shared_prefs.dart';
import 'package:potato_notes/internal/sync/image/image_helper.dart';

part 'preferences.g.dart';

class Preferences = _PreferencesBase with _$Preferences;

abstract class _PreferencesBase with Store {
  final SharedPrefs prefs = SharedPrefs.instance;
  final Keystore keystore = Keystore();

  _PreferencesBase() {
    loadData();
  }

  @observable
  @protected
  String _masterPassValue;

  @observable
  @protected
  ThemeMode _themeModeValue = SharedPrefs.instance.themeMode;

  @observable
  @protected
  Color _customAccentValue = SharedPrefs.instance.customAccent;

  @observable
  @protected
  bool _useAmoledValue = SharedPrefs.instance.useAmoled;

  @observable
  @protected
  bool _useGridValue = SharedPrefs.instance.useGrid;

  @observable
  @protected
  bool _useCustomAccentValue = SharedPrefs.instance.useCustomAccent;

  @observable
  @protected
  bool _welcomePageSeenValue = SharedPrefs.instance.welcomePageSeen;

  @observable
  @protected
  String _apiUrlValue = SharedPrefs.instance.apiUrl;

  @observable
  @protected
  String _accessTokenValue = SharedPrefs.instance.accessToken;

  @observable
  @protected
  String _refreshTokenValue = SharedPrefs.instance.refreshToken;

  @observable
  @protected
  String _usernameValue = SharedPrefs.instance.username;

  @observable
  @protected
  String _emailValue = SharedPrefs.instance.email;

  @observable
  @protected
  String _avatarUrlValue = SharedPrefs.instance.avatarUrl;

  @observable
  @protected
  int _logLevelValue = SharedPrefs.instance.logLevel;

  @observable
  @protected
  List<dynamic> _tagsValue = [];

  @observable
  @protected
  List<String> _downloadedImagesValue = SharedPrefs.instance.downloadedImages;

  @observable
  @protected
  List<String> _deletedImagesValue = SharedPrefs.instance.deletedImages;

  @observable
  @protected
  int _lastUpdatedValue = SharedPrefs.instance.lastUpdated;

  @observable
  @protected
  String _deleteQueueValue = SharedPrefs.instance.deleteQueue;

  String get masterPass => _masterPassValue;
  ThemeMode get themeMode => _themeModeValue;
  Color get customAccent => _customAccentValue;
  bool get useAmoled => _useAmoledValue;
  bool get useGrid => _useGridValue;
  bool get useCustomAccent => _useCustomAccentValue;
  bool get welcomePageSeen => _welcomePageSeenValue;
  String get apiUrl => _apiUrlValue;
  String get accessToken => _accessTokenValue;
  String get refreshToken => _refreshTokenValue;
  String get username => _usernameValue;
  String get email => _emailValue;
  String get avatarUrl => _avatarUrlValue;
  String get avatarUrlAsKey => _avatarUrlValue.split("?").first;
  int get logLevel => _logLevelValue;
  List<dynamic> get tags => _tagsValue;
  List<String> get downloadedImages => _downloadedImagesValue;
  List<String> get deletedImages => _deletedImagesValue;
  int get lastUpdated => _lastUpdatedValue;
  String get deleteQueue => _deleteQueueValue;

  set masterPass(String value) {
    _masterPassValue = value;

    if (DeviceInfo.isDesktop) {
      prefs.masterPass = value;
    } else {
      keystore.setMasterPass(value);
    }
  }

  set themeMode(ThemeMode value) {
    _themeModeValue = value;
    prefs.themeMode = value;
  }

  set customAccent(Color value) {
    _customAccentValue = value;
    prefs.customAccent = value;
  }

  set useAmoled(bool value) {
    _useAmoledValue = value;
    prefs.useAmoled = value;
  }

  set useGrid(bool value) {
    _useGridValue = value;
    prefs.useGrid = value;
  }

  set useCustomAccent(bool value) {
    _useCustomAccentValue = value;
    prefs.useCustomAccent = value;
  }

  set welcomePageSeen(bool value) {
    _welcomePageSeenValue = value;
    prefs.welcomePageSeen = value;
  }

  set apiUrl(String value) {
    _apiUrlValue = value;
    prefs.apiUrl = value;
  }

  set accessToken(String value) {
    _accessTokenValue = value;
    prefs.accessToken = value;
  }

  set refreshToken(String value) {
    _refreshTokenValue = value;
    prefs.refreshToken = value;
  }

  set username(String value) {
    _usernameValue = value;
    prefs.username = value;
  }

  set email(String value) {
    _emailValue = value;
    prefs.email = value;
  }

  set avatarUrl(String value) {
    _avatarUrlValue = value;
    prefs.avatarUrl = value;
  }

  set logLevel(int value) {
    _logLevelValue = value;
    prefs.logLevel = value;
  }

  set downloadedImages(List<String> value) {
    _downloadedImagesValue = value;
    prefs.downloadedImages = value;
  }

  set deletedImages(List<String> value) {
    _deletedImagesValue = value;
    prefs.deletedImages = value;
  }

  set lastUpdated(int value) {
    _lastUpdatedValue = value;
    prefs.lastUpdated = value;
  }

  set deleteQueue(String value) {
    _deleteQueueValue = value;
    prefs.deleteQueue = value;
  }

  Object getFromCache(String key) {
    return prefs.prefs.get(key);
  }

  void loadData() async {
    if (DeviceInfo.isDesktop) {
      _masterPassValue = prefs.masterPass;
    } else {
      _masterPassValue = await keystore.getMasterPass();
    }

    try {
      final String netAvatarUrl = await ImageHelper.getAvatar(await getToken());
      if (netAvatarUrl != _avatarUrlValue) {
        avatarUrl = netAvatarUrl;
      }
    } catch (e) {}

    tagHelper.watchTags(TagReturnMode.LOCAL).listen((newTags) {
      _tagsValue = newTags;
    });
  }

  Future<String> getToken() async {
    if (accessToken == null ||
        DateTime.fromMillisecondsSinceEpoch(
                Jwt.parseJwt(accessToken)["exp"] * 1000)
            .isBefore(DateTime.now())) {
      final AuthResponse response = await AccountController.refreshToken();

      if (!response.status) {
        Loggy.w(message: response.message);
      }
    }

    return accessToken;
  }
}
