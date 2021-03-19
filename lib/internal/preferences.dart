import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/jwt_decode.dart';
import 'package:potato_notes/internal/logger_provider.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/keystore.dart';
import 'package:potato_notes/internal/sync/controller.dart';
import 'package:universal_platform/universal_platform.dart';

part 'preferences.g.dart';

class Preferences = _PreferencesBase with _$Preferences;

abstract class _PreferencesBase with Store, LoggerProvider {
  static final _keystoreSupported = UniversalPlatform.isAndroid ||
      UniversalPlatform.isIOS ||
      UniversalPlatform.isLinux;
  final Keystore keystore = Keystore();

  _PreferencesBase() {
    loadData();
  }

  @observable
  @protected
  String _masterPassValue = "";

  @observable
  @protected
  ThemeMode _themeModeValue = sharedPrefs.themeMode;

  @observable
  @protected
  Color? _customAccentValue = sharedPrefs.customAccent;

  @observable
  @protected
  bool _useAmoledValue = sharedPrefs.useAmoled;

  @observable
  @protected
  bool _useGridValue = sharedPrefs.useGrid;

  @observable
  @protected
  bool _useCustomAccentValue = sharedPrefs.useCustomAccent;

  @observable
  @protected
  bool _welcomePageSeenValue = sharedPrefs.welcomePageSeen;

  @observable
  @protected
  String _apiUrlValue = sharedPrefs.apiUrl;

  @observable
  @protected
  String? _accessTokenValue = sharedPrefs.accessToken;

  @observable
  @protected
  String? _refreshTokenValue = sharedPrefs.refreshToken;

  @observable
  @protected
  String? _usernameValue = sharedPrefs.username;

  @observable
  @protected
  String? _emailValue = sharedPrefs.email;

  @observable
  @protected
  String? _avatarUrlValue = sharedPrefs.avatarUrl;

  @observable
  @protected
  int _logLevelValue = sharedPrefs.logLevel;

  @observable
  @protected
  List<dynamic> _tagsValue = [];

  @observable
  @protected
  List<String> _downloadedImagesValue = sharedPrefs.downloadedImages;

  @observable
  @protected
  List<String> _deletedImagesValue = sharedPrefs.deletedImages;

  @observable
  @protected
  int _lastUpdatedValue = sharedPrefs.lastUpdated;

  @observable
  @protected
  String? _deleteQueueValue = sharedPrefs.deleteQueue;

  String get masterPass => _masterPassValue;
  ThemeMode get themeMode => _themeModeValue;
  Color? get customAccent => _customAccentValue;
  bool get useAmoled => _useAmoledValue;
  bool get useGrid => _useGridValue;
  bool get useCustomAccent => _useCustomAccentValue;
  bool get welcomePageSeen => _welcomePageSeenValue;
  String get apiUrl => _apiUrlValue;
  String? get accessToken => _accessTokenValue;
  String? get refreshToken => _refreshTokenValue;
  String? get username => _usernameValue;
  String? get email => _emailValue;
  String? get avatarUrl => _avatarUrlValue;
  String? get avatarUrlAsKey => _avatarUrlValue?.split("?").first;
  int get logLevel => _logLevelValue;
  List<Tag> get tags => _tagsValue.map((e) => e as Tag).toList();
  List<String> get downloadedImages => _downloadedImagesValue;
  List<String> get deletedImages => _deletedImagesValue;
  int get lastUpdated => _lastUpdatedValue;
  String? get deleteQueue => _deleteQueueValue;

  set masterPass(String value) {
    _masterPassValue = value;

    if (_keystoreSupported) {
      keystore.setMasterPass(value);
    } else {
      sharedPrefs.masterPass = value;
    }
  }

  set themeMode(ThemeMode value) {
    _themeModeValue = value;
    sharedPrefs.themeMode = value;
  }

  set customAccent(Color? value) {
    _customAccentValue = value;
    sharedPrefs.customAccent = value;
  }

  set useAmoled(bool value) {
    _useAmoledValue = value;
    sharedPrefs.useAmoled = value;
  }

  set useGrid(bool value) {
    _useGridValue = value;
    sharedPrefs.useGrid = value;
  }

  set useCustomAccent(bool value) {
    _useCustomAccentValue = value;
    sharedPrefs.useCustomAccent = value;
  }

  set welcomePageSeen(bool value) {
    _welcomePageSeenValue = value;
    sharedPrefs.welcomePageSeen = value;
  }

  set apiUrl(String value) {
    _apiUrlValue = value;
    sharedPrefs.apiUrl = value;
  }

  set accessToken(String? value) {
    _accessTokenValue = value;
    sharedPrefs.accessToken = value;
  }

  set refreshToken(String? value) {
    _refreshTokenValue = value;
    sharedPrefs.refreshToken = value;
  }

  set username(String? value) {
    _usernameValue = value;
    sharedPrefs.username = value;
  }

  set email(String? value) {
    _emailValue = value;
    sharedPrefs.email = value;
  }

  set avatarUrl(String? value) {
    _avatarUrlValue = value;
    sharedPrefs.avatarUrl = value;
  }

  set logLevel(int value) {
    _logLevelValue = value;
    sharedPrefs.logLevel = value;
  }

  set downloadedImages(List<String> value) {
    _downloadedImagesValue = value;
    sharedPrefs.downloadedImages = value;
  }

  set deletedImages(List<String> value) {
    _deletedImagesValue = value;
    sharedPrefs.deletedImages = value;
  }

  set lastUpdated(int value) {
    _lastUpdatedValue = value;
    sharedPrefs.lastUpdated = value;
  }

  set deleteQueue(String? value) {
    _deleteQueueValue = value;
    sharedPrefs.deleteQueue = value;
  }

  Object? getFromCache(String key) {
    return sharedPrefs.prefs.get(key);
  }

  Future<void> loadData() async {
    if (_keystoreSupported) {
      _masterPassValue = await keystore.getMasterPass();
    } else {
      _masterPassValue = sharedPrefs.masterPass;
    }

    _tagsValue = await tagHelper.listTags(TagReturnMode.local);

    tagHelper.watchTags(TagReturnMode.local).listen((newTags) {
      _tagsValue = newTags;
    });

    if (sharedPrefs.accessToken != null) {
      await Controller.files.getStats();
      final String? netAvatarUrl = await imageHelper.getAvatar();
      if (netAvatarUrl != _avatarUrlValue) {
        avatarUrl = netAvatarUrl;
      }
    }
  }

  Future<String> getToken() async {
    final bool tokenExpired = accessToken != null
        ? DateTime.fromMillisecondsSinceEpoch(
            (Jwt.parseJwt(accessToken!)["exp"] as int) * 1000,
          ).isBefore(DateTime.now())
        : false;

    if (accessToken == null || tokenExpired) {
      final AuthResponse response = await Controller.account.refreshToken();

      if (!response.status) {
        logger.w(response.message);
      }
    }

    return accessToken!;
  }
}
