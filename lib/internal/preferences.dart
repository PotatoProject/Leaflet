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
  ThemeMode _themeModeValue = ThemeMode.system;

  @observable
  @protected
  Color _customAccentValue;

  @observable
  @protected
  bool _useAmoledValue = false;

  @observable
  @protected
  bool _useGridValue = false;

  @observable
  @protected
  bool _useCustomAccentValue = false;

  @observable
  @protected
  bool _welcomePageSeenValue = false;

  @observable
  @protected
  String _apiUrlValue;

  @observable
  @protected
  String _accessTokenValue;

  @observable
  @protected
  String _refreshTokenValue;

  @observable
  @protected
  String _usernameValue;

  @observable
  @protected
  String _emailValue;

  @observable
  @protected
  String _avatarUrlValue;

  @observable
  @protected
  int _logLevelValue = LogEntry.VERBOSE;

  @observable
  @protected
  List<dynamic> _tagsValue = [];

  @observable
  @protected
  List<String> _downloadedImagesValue = [];

  @observable
  @protected
  List<String> _deletedImagesValue = [];

  @observable
  @protected
  int _lastUpdatedValue;

  @observable
  @protected
  String _deleteQueueValue;

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

    if (DeviceInfo.isDesktopOrWeb) {
      prefs.setMasterPass(value);
    } else {
      keystore.setMasterPass(value);
    }
  }

  set themeMode(ThemeMode value) {
    _themeModeValue = value;
    prefs.setThemeMode(value);
  }

  set customAccent(Color value) {
    _customAccentValue = value;
    prefs.setCustomAccent(value);
  }

  set useAmoled(bool value) {
    _useAmoledValue = value;
    prefs.setUseAmoled(value);
  }

  set useGrid(bool value) {
    _useGridValue = value;
    prefs.setUseGrid(value);
  }

  set useCustomAccent(bool value) {
    _useCustomAccentValue = value;
    prefs.setUseCustomAccent(value);
  }

  set welcomePageSeen(bool value) {
    _welcomePageSeenValue = value;
    prefs.setWelcomePageSeen(value);
  }

  set apiUrl(String value) {
    _apiUrlValue = value;
    prefs.setApiUrl(value);
  }

  set accessToken(String value) {
    _accessTokenValue = value;
    prefs.setAccessToken(value);
  }

  set refreshToken(String value) {
    _refreshTokenValue = value;
    prefs.setRefreshToken(value);
  }

  set username(String value) {
    _usernameValue = value;
    prefs.setUsername(value);
  }

  set email(String value) {
    _emailValue = value;
    prefs.setEmail(value);
  }

  set avatarUrl(String value) {
    _avatarUrlValue = value;
    prefs.setAvatarUrl(value);
  }

  set logLevel(int value) {
    _logLevelValue = value;
    prefs.setLogLevel(value);
  }

  set downloadedImages(List<String> value) {
    _downloadedImagesValue = value;
    prefs.setDownloadedImages(value);
  }

  set deletedImages(List<String> value) {
    _deletedImagesValue = value;
    prefs.setDeletedImages(value);
  }

  set lastUpdated(int value) {
    _lastUpdatedValue = value;
    prefs.setLastUpdated(value);
  }

  set deleteQueue(String value) {
    _deleteQueueValue = value;
    prefs.setDeleteQueue(value);
  }

  Object getFromCache(String key) {
    return prefs.prefs.get(key);
  }

  void loadData() async {
    _apiUrlValue = await prefs.getApiUrl();
    _accessTokenValue = await prefs.getAccessToken();
    _refreshTokenValue = await prefs.getRefreshToken();
    _welcomePageSeenValue = await prefs.getWelcomePageSeen();
    _themeModeValue = await prefs.getThemeMode();
    _useAmoledValue = await prefs.getUseAmoled();
    _useCustomAccentValue = await prefs.getUseCustomAccent();
    _customAccentValue = await prefs.getCustomAccent();
    _useGridValue = await prefs.getUseGrid();

    if (DeviceInfo.isDesktopOrWeb) {
      _masterPassValue = await prefs.getMasterPass();
    } else {
      _masterPassValue = await keystore.getMasterPass();
    }

    _usernameValue = await prefs.getUsername();
    _emailValue = await prefs.getEmail();
    _avatarUrlValue = await prefs.getAvatarUrl();
    _logLevelValue = await prefs.getLogLevel();
    _downloadedImagesValue = await prefs.getDownloadedImages();
    _deletedImagesValue = await prefs.getDeletedImages();
    _lastUpdatedValue = await prefs.getLastUpdated();
    _deleteQueueValue = await prefs.getDeleteQueue();
    tagHelper.watchTags(TagReturnMode.LOCAL).listen((newTags) {
      _tagsValue = newTags;
    });

    try {
      final String netAvatarUrl = await ImageHelper.getAvatar();
      if (netAvatarUrl != _avatarUrlValue) {
        avatarUrl = netAvatarUrl;
      }
    } catch (e) {}
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
