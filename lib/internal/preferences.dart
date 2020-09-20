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
  String masterPassValue;

  @observable
  @protected
  ThemeMode themeModeValue = ThemeMode.system;

  @observable
  @protected
  Color customAccentValue;

  @observable
  @protected
  bool useAmoledValue = false;

  @observable
  @protected
  bool useGridValue = false;

  @observable
  @protected
  bool useCustomAccentValue = false;

  @observable
  @protected
  bool welcomePageSeenValue = false;

  @observable
  @protected
  String apiUrlValue;

  @observable
  @protected
  String accessTokenValue;

  @observable
  @protected
  String refreshTokenValue;

  @observable
  @protected
  String usernameValue;

  @observable
  @protected
  String emailValue;

  @observable
  @protected
  int logLevelValue = LogEntry.VERBOSE;

  @observable
  @protected
  List<dynamic> tagsValue = [];

  @observable
  @protected
  List<String> downloadedImagesValue = [];

  @observable
  @protected
  List<String> deletedImagesValue = [];

  @observable
  @protected
  int lastUpdatedValue;

  String get masterPass => masterPassValue;
  ThemeMode get themeMode => themeModeValue;
  Color get customAccent => customAccentValue;
  bool get useAmoled => useAmoledValue;
  bool get useGrid => useGridValue;
  bool get useCustomAccent => useCustomAccentValue;
  bool get welcomePageSeen => welcomePageSeenValue;
  String get apiUrl => apiUrlValue;
  String get accessToken => accessTokenValue;
  String get refreshToken => refreshTokenValue;
  String get username => usernameValue;
  String get email => emailValue;
  int get logLevel => logLevelValue;
  List<dynamic> get tags => tagsValue;
  List<String> get downloadedImages => downloadedImagesValue;
  List<String> get deletedImages => deletedImagesValue;
  int get lastUpdated => lastUpdatedValue;

  set masterPass(String value) {
    masterPassValue = value;

    if (DeviceInfo.isDesktopOrWeb) {
      prefs.setMasterPass(value);
    } else {
      keystore.setMasterPass(value);
    }
  }

  set themeMode(ThemeMode value) {
    themeModeValue = value;
    prefs.setThemeMode(value);
  }

  set customAccent(Color value) {
    customAccentValue = value;
    prefs.setCustomAccent(value);
  }

  set useAmoled(bool value) {
    useAmoledValue = value;
    prefs.setUseAmoled(value);
  }

  set useGrid(bool value) {
    useGridValue = value;
    prefs.setUseGrid(value);
  }

  set useCustomAccent(bool value) {
    useCustomAccentValue = value;
    prefs.setUseCustomAccent(value);
  }

  set welcomePageSeen(bool value) {
    welcomePageSeenValue = value;
    prefs.setWelcomePageSeen(value);
  }

  set apiUrl(String value) {
    apiUrlValue = value;
    prefs.setApiUrl(value);
  }

  set accessToken(String value) {
    accessTokenValue = value;
    prefs.setAccessToken(value);
  }

  set refreshToken(String value) {
    refreshTokenValue = value;
    prefs.setRefreshToken(value);
  }

  set username(String value) {
    usernameValue = value;
    prefs.setUsername(value);
  }

  set email(String value) {
    emailValue = value;
    prefs.setEmail(value);
  }

  set logLevel(int value) {
    logLevelValue = value;
    prefs.setLogLevel(value);
  }

  set lastUpdated(int value) {
    lastUpdatedValue = value;
    prefs.setLastUpdated(value);
  }

  set downloadedImages(List<String> value) {
    downloadedImagesValue = value;
    prefs.setDownloadedImages(value);
  }

  set deletedImages(List<String> value) {
    deletedImagesValue = value;
    prefs.setDeletedImages(value);
  }

  void loadData() async {
    welcomePageSeenValue = await prefs.getWelcomePageSeen();
    themeModeValue = await prefs.getThemeMode();
    useCustomAccentValue = await prefs.getUseCustomAccent();
    customAccentValue = await prefs.getCustomAccent();
    useAmoledValue = await prefs.getUseAmoled();
    useGridValue = await prefs.getUseGrid();

    if (DeviceInfo.isDesktopOrWeb) {
      masterPassValue = await prefs.getMasterPass();
    } else {
      masterPassValue = await keystore.getMasterPass();
    }

    apiUrlValue = await prefs.getApiUrl();
    accessTokenValue = await prefs.getAccessToken();
    refreshTokenValue = await prefs.getRefreshToken();
    usernameValue = await prefs.getUsername();
    emailValue = await prefs.getEmail();
    logLevelValue = await prefs.getLogLevel();
    lastUpdatedValue = await prefs.getLastUpdated();

    tagHelper.watchTags(TagReturnMode.LOCAL).listen((newTags) {
      tagsValue = newTags;
    });

    downloadedImagesValue = await prefs.getDownloadedImages();
    deletedImagesValue = await prefs.getDeletedImages();
  }

  Future<String> getToken() async {
    bool status = true;
    if (accessToken == null ||
        DateTime.fromMillisecondsSinceEpoch(
                Jwt.parseJwt(accessToken)["exp"] * 1000)
            .isBefore(DateTime.now())) {
      final response = await AccountController.refreshToken();
      status = response.status;
    }

    if (status) {
      return accessToken;
    } else {
      throw "Error while refreshing token";
    }
  }
}
