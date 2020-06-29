import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';
import 'package:potato_notes/internal/illustrations.dart';
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:streams_channel/streams_channel.dart';

class AppInfoProvider extends ChangeNotifier {
  static final StreamsChannel accentStreamChannel =
      StreamsChannel('potato_notes_accents');
  static final StreamsChannel themeStreamChannel =
      StreamsChannel('potato_notes_themes');

  AppInfoProvider(this.context) {
    illustrations = Illustrations();
    loadData();
  }

  BuildContext context;
  Illustrations illustrations;
  bool canCheckBiometrics;
  List<BiometricType> availableBiometrics;
  FlutterLocalNotificationsPlugin notifications;
  QuickActions quickActions;

  Widget noNotesIllustration;
  Widget emptyArchiveIllustration;
  Widget emptyTrashIllustration;

  bool _imageCacheReloadRequested = false;

  bool get imageCacheReloadRequested => _imageCacheReloadRequested;

  void updateIllustrations() async {
    Brightness systemTheme = Theme.of(context).brightness;

    noNotesIllustration = await illustrations.noNotesIllustration(systemTheme);
    emptyArchiveIllustration =
        await illustrations.emptyArchiveIllustration(systemTheme);
    emptyTrashIllustration =
        await illustrations.emptyTrashIllustration(systemTheme);
  }

  void _initNotifications() async {
    notifications = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
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
        notifications.cancel(nPayload.id);
        break;
      case NotificationAction.REMINDER:
        break;
    }
  }

  void _initQuickActions() async {
    
  }

  void loadData() async {
    _initNotifications();
    _initQuickActions();
    
    canCheckBiometrics = await LocalAuthentication().canCheckBiometrics;
    availableBiometrics = await LocalAuthentication().getAvailableBiometrics();
  }
}
