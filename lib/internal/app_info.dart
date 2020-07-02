import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info/package_info.dart';
import 'package:potato_notes/internal/illustrations.dart';
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:quick_actions/quick_actions.dart';

class AppInfo {
  AppInfo() {
    illustrations = Illustrations();
    loadData();
  }

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
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await notifications.initialize(initializationSettings,
        onSelectNotification: _handleNotificationTap);
  }

  Future<dynamic> _handleNotificationTap(String payload) async {
    NotificationPayload nPayload =
        NotificationPayload.fromJson(json.decode(payload));

    switch (nPayload.action) {
      case NotificationAction.PIN:
        notifications.cancel(nPayload.notificationId);
        break;
      case NotificationAction.REMINDER:
        break;
    }
  }

  void loadData() async {
    if (!kIsWeb) {
      _initNotifications();
    }

    packageInfo = await PackageInfo.fromPlatform();
  }
}
