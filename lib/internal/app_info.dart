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
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:quick_actions/quick_actions.dart';

part 'app_info.g.dart';

class AppInfo = _AppInfoBase with _$AppInfo;

abstract class _AppInfoBase with Store {
  static final EventChannel accentStreamChannel =
      EventChannel('potato_notes_accents');

  _AppInfoBase() {
    loadData();
  }

  Directory tempDirectory;
  FlutterLocalNotificationsPlugin notifications;
  QuickActions quickActions;
  PackageInfo packageInfo;

  @observable
  @protected
  int _accentDataValue = Colors.blue.value;

  int get accentData => _accentDataValue;

  @observable
  @protected
  List<ActiveNotification> _activeNotificationsValue = [];

  List<ActiveNotification> get activeNotifications => _activeNotificationsValue;

  void _initNotifications() async {
    notifications = FlutterLocalNotificationsPlugin();
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notes_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
    await notifications.initialize(initializationSettings,
        onSelectNotification: _handleNotificationTap);
  }

  Future<dynamic> _handleNotificationTap(String payload) async {
    final NotificationPayload nPayload =
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

    if (!DeviceInfo.isDesktop) {
      _initNotifications();
    }
    packageInfo = await PackageInfo.fromPlatform();

    if (DeviceInfo.isAndroid) {
      accentStreamChannel.receiveBroadcastStream().listen(updateAccent);
    } else {
      _accentDataValue = -1;
    }

    if (DeviceInfo.isAndroid) {
      pollForActiveNotifications();
    }
  }

  @action
  void updateAccent(dynamic event) {
    _accentDataValue = event as int;
  }

  @action
  void pollForActiveNotifications() {
    Timer.periodic(Duration(milliseconds: 500), (timer) async {
      _activeNotificationsValue = await notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          .getActiveNotifications();
    });
  }
}
