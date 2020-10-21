import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/illustrations.dart';
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:quick_actions/quick_actions.dart';

part 'app_info.g.dart';

class AppInfo = _AppInfoBase with _$AppInfo;

abstract class _AppInfoBase with Store {
  static final EventChannel accentStreamChannel =
      EventChannel('potato_notes_accents');

  _AppInfoBase() {
    illustrations = Illustrations();
    loadData();
  }

  Directory tempDirectory;
  Illustrations illustrations;
  FlutterLocalNotificationsPlugin notifications;
  QuickActions quickActions;
  PackageInfo packageInfo;

  Widget noNotesIllustration;
  Widget emptyArchiveIllustration;
  Widget emptyTrashIllustration;
  Widget noFavouritesIllustration;
  Widget nothingFoundIllustration;
  Widget typeToSearchIllustration;

  @observable
  @protected
  int accentDataValue = Colors.blue.value;

  int get accentData => accentDataValue;

  void updateIllustrations(Brightness systemTheme) async {
    noNotesIllustration = await illustrations.noNotesIllustration(systemTheme);
    emptyArchiveIllustration =
        await illustrations.emptyArchiveIllustration(systemTheme);
    emptyTrashIllustration =
        await illustrations.emptyTrashIllustration(systemTheme);
    noFavouritesIllustration =
        await illustrations.noFavouritesIllustration(systemTheme);
    nothingFoundIllustration =
        await illustrations.nothingFoundIllustration(systemTheme);
    typeToSearchIllustration =
        await illustrations.typeToSearchIllustration(systemTheme);
  }

  void _initNotifications() async {
    notifications = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('notes_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettingsMacOS = MacOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
    await notifications.initialize(initializationSettings,
        onSelectNotification: _handleNotificationTap);
  }

  Future<dynamic> _handleNotificationTap(String payload) async {
    NotificationPayload nPayload =
        NotificationPayload.fromJson(json.decode(payload));

    switch (nPayload.action) {
      case NotificationAction.PIN:
        notifications.cancel(nPayload.id);
        break;
      case NotificationAction.REMINDER:
        break;
    }
  }

  void loadData() async {
    tempDirectory = await getTemporaryDirectory();
    print(tempDirectory);

    if (!DeviceInfo.isDesktopOrWeb) {
      _initNotifications();
      packageInfo = await PackageInfo.fromPlatform();
    }

    if (DeviceInfo.isAndroid) {
      accentStreamChannel.receiveBroadcastStream().listen(updateAccent);
    } else {
      accentDataValue = -1;
    }
  }

  @action
  void updateAccent(dynamic event) {
    accentDataValue = event as int;
  }
}
