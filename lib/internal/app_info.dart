import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:potato_notes/internal/constants.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/migration_task.dart';
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/theme/data.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:universal_platform/universal_platform.dart';

part 'app_info.g.dart';

class AppInfo extends _AppInfoBase with _$AppInfo {
  AppInfo();

  static Future<AppInfo> load() async {
    final AppInfo instance = AppInfo();
    await instance.loadData();
    return instance;
  }

  /// This bool defines whether the app is ready to
  /// support the notes api in a production environment
  static bool supportsNotesApi = false;

  static bool supportsNotePinning =
      UniversalPlatform.isAndroid || UniversalPlatform.isIOS;
}

abstract class _AppInfoBase with Store {
  static const EventChannel accentStreamChannel =
      EventChannel('potato_notes_accents');

  FlutterLocalNotificationsPlugin? notifications;
  QuickActions? quickActions;
  late PackageInfo packageInfo;
  late final bool migrationAvailable;

  @observable
  int _systemAccentDataValue = Colors.blue.value;

  int get systemAccentData => _systemAccentDataValue;

  @observable
  Color _accentDataValue = Colors.blue;

  Color get accentData => _accentDataValue;

  List<AppTheme>? _availableThemes;
  List<AppTheme> get availableThemes => List.unmodifiable(_availableThemes!);

  @observable
  LeafletThemeData? _lightThemeValue;
  late AppTheme _lightAppTheme;

  LeafletThemeData get lightTheme => _lightThemeValue!;
  AppTheme get lightAppTheme => _lightAppTheme;

  @observable
  LeafletThemeData? _darkThemeValue;
  late AppTheme _darkAppTheme;

  LeafletThemeData get darkTheme => _darkThemeValue!;
  AppTheme get darkAppTheme => _darkAppTheme;

  @observable
  List<ActiveNotification> _activeNotificationsValue = [];

  List<ActiveNotification> get activeNotifications => _activeNotificationsValue;

  Future<void> _initNotifications() async {
    notifications = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notes_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) =>
          _handleNotificationTap(payload),
    );
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
    await notifications!.initialize(
      initializationSettings,
      onSelectNotification: _handleNotificationTap,
    );
  }

  Future<dynamic> _handleNotificationTap(String? payload) async {
    if (payload == null) return;

    final NotificationPayload nPayload = NotificationPayload.fromJson(
      Utils.asMap<String, dynamic>(json.decode(payload)),
    );

    switch (nPayload.action) {
      case NotificationAction.pin:
        notifications!.cancel(nPayload.id);
        break;
      case NotificationAction.reminder:
        break;
    }
  }

  Future<void> loadData() async {
    await refetchThemes();
    _updateAccent();

    if (UniversalPlatform.isAndroid) {
      migrationAvailable = await MigrationTask.isMigrationAvailable(
        await MigrationTask.v1DatabasePath,
      );
    } else {
      migrationAvailable = false;
    }

    if (AppInfo.supportsNotePinning) {
      _initNotifications();
    }

    packageInfo = await PackageInfo.fromPlatform();

    if (DeviceInfo.isAndroid) {
      accentStreamChannel.receiveBroadcastStream().listen(updateAccent);
    } else {
      _systemAccentDataValue = -1;
    }

    if (DeviceInfo.isAndroid) {
      pollForActiveNotifications();
    }
  }

  final List<BundledTheme> _bundledThemes = [
    BundledTheme("themes/light.toml"),
    BundledTheme("themes/dark.toml"),
    BundledTheme("themes/black.toml"),
    BundledTheme("themes/monet_light.toml"),
    BundledTheme("themes/monet_dark.toml"),
  ];

  Future<Iterable<ImportedTheme>> get _importedThemes async {
    final List<FileSystemEntity> entities =
        await appDirectories.themesDirectory.list().toList();
    final Iterable<File> themes = entities
        .where((e) => e is File && extension(e.path) == ".toml")
        .cast<File>();

    return themes.map((e) => ImportedTheme(e.path));
  }

  @action
  void updateAccent(dynamic event) {
    _systemAccentDataValue = event as int;
  }

  @action
  void pollForActiveNotifications() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      final List<ActiveNotification>? _activeNotifications = await notifications
          ?.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.getActiveNotifications();
      _activeNotificationsValue = _activeNotifications ?? [];
    });
  }

  Future<DiffResult> refetchThemes() async {
    final List<AppTheme> prevThemes = List.from(_availableThemes ?? []);

    _availableThemes = [
      ..._bundledThemes,
      ...await _importedThemes,
    ];

    for (final AppTheme theme in _availableThemes!) {
      await theme.load();
    }
    _lightAppTheme = _availableThemes!.firstWhere(
      (e) => e.data.id == prefs.lightTheme,
      orElse: () {
        prefs.lightTheme = "light";
        return availableThemes[0];
      },
    );
    _darkAppTheme = _availableThemes!.firstWhere(
      (e) => e.data.id == prefs.darkTheme,
      orElse: () {
        prefs.lightTheme = "dark";
        return availableThemes[1];
      },
    );
    _updateAccent();

    final DiffResult diffThemes = calculateListDiff<AppTheme>(
      prevThemes,
      _availableThemes!,
      detectMoves: false,
      equalityChecker: (p0, p1) => p0.data.id == p1.data.id,
    );

    return diffThemes;
  }

  void loadLightTheme(AppTheme theme) {
    _lightAppTheme = theme;
    prefs.lightTheme = theme.data.id;
    refreshThemes();
  }

  void loadDarkTheme(AppTheme theme) {
    _darkAppTheme = theme;
    prefs.darkTheme = theme.data.id;
    refreshThemes();
  }

  Future<ImportedTheme?> addTheme(File themeFile) async {
    final String ext = extension(themeFile.path);
    if (ext != ".toml") return null;

    final String newPath = join(
      appDirectories.themesDirectory.path,
      basename(themeFile.path),
    );
    await themeFile.copy(newPath);

    final ImportedTheme theme = ImportedTheme(newPath);
    await theme.load();
    _availableThemes!.add(theme);
    refreshThemes();

    return theme;
  }

  Future<void> removeTheme(String id) async {
    final AppTheme? theme = _availableThemes!.cast<AppTheme?>().firstWhere(
          (e) => e!.data.id == id,
          orElse: () => null,
        );

    if (theme is ImportedTheme) {
      await File(theme.filePath).delete();
      _availableThemes!.remove(theme);
    }
  }

  @action
  void refreshThemes() {
    for (final AppTheme theme in _availableThemes!) {
      theme.reparse();
    }
    _lightThemeValue = _lightAppTheme.data;
    _darkThemeValue = _darkAppTheme.data;
  }

  @action
  void _updateAccent() {
    autorun((_) {
      Color accentColor;
      bool canUseSystemAccent = true;

      if (DeviceInfo.isAndroid) {
        if (appInfo.systemAccentData == -1) {
          canUseSystemAccent = false;
        } else {
          canUseSystemAccent = true;
        }
      } else {
        canUseSystemAccent = false;
      }

      if (prefs.useCustomAccent || !canUseSystemAccent) {
        accentColor = prefs.customAccent ?? Constants.defaultAccent;
      } else {
        accentColor = Color(appInfo.systemAccentData);
      }

      deviceInfo.setCanUseSystemAccent(canUseSystemAccent);
      _accentDataValue = accentColor.withOpacity(1);

      refreshThemes();
    });
  }
}
