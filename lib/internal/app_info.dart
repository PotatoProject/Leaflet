import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';
import 'package:potato_notes/internal/illustrations.dart';
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/system_bar_manager.dart';
import 'package:potato_notes/locator.dart';
import 'package:provider/provider.dart';
import 'package:streams_channel/streams_channel.dart';

class AppInfoProvider extends ChangeNotifier {
  static final StreamsChannel accentStreamChannel =
      StreamsChannel('potato_notes_accents');
  static final StreamsChannel themeStreamChannel =
      StreamsChannel('potato_notes_themes');

  AppInfoProvider() {
    prefs = locator<Preferences>();
    illustrations = Illustrations();
    loadData();

    barManager = SystemBarManager(this);
  }

  // ignore: cancel_subscriptions
  StreamSubscription<dynamic> accentSubscription;
  // ignore: cancel_subscriptions
  StreamSubscription<dynamic> themeSubscription;
  Preferences prefs;
  Illustrations illustrations;
  SystemBarManager barManager;
  bool canCheckBiometrics;
  List<BiometricType> availableBiometrics;
  FlutterLocalNotificationsPlugin notifications;

  Widget noNotesIllustration;
  Widget emptyArchiveIllustration;
  Widget emptyTrashIllustration;

  Color _mainColor = Colors.blueAccent;
  Brightness _systemTheme = Brightness.light;

  Color get mainColor => _mainColor;
  Brightness get systemTheme => _systemTheme;

  set mainColor(Color newColor) {
    _mainColor = newColor;
    notifyListeners();
  }

  set systemTheme(Brightness newTheme) {
    _systemTheme = newTheme;
    notifyListeners();
  }

  void updateIllustrations() async {
    noNotesIllustration = await illustrations.noNotesIllustration(systemTheme);
    emptyArchiveIllustration =
        await illustrations.emptyArchiveIllustration(systemTheme);
    emptyTrashIllustration =
        await illustrations.emptyTrashIllustration(systemTheme);
  }

  void _initNotifications() async {
    notifications = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('notes_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await notifications.initialize(initializationSettings, onSelectNotification: _handleNotificationTap);
  }

  Future<dynamic> _handleNotificationTap(String payload) async {
    NotificationPayload nPayload = NotificationPayload.fromJson(json.decode(payload));

    switch(nPayload.action) {
      case NotificationAction.PIN:
        notifications.cancel(nPayload.id);
        break;
      case NotificationAction.REMINDER:
        break;
    }
  }

  void loadData() async {
    themeSubscription =
        themeStreamChannel.receiveBroadcastStream().listen((data) {
      switch (prefs.themeMode) {
        case ThemeMode.system:
          systemTheme = data ? Brightness.dark : Brightness.light;
          break;
        case ThemeMode.light:
          systemTheme = Brightness.light;
          break;
        case ThemeMode.dark:
          systemTheme = Brightness.dark;
          break;
      }
    });
    _initNotifications();
    accentSubscription =
        accentStreamChannel.receiveBroadcastStream().listen((data) {
      mainColor = Color(data);
    });
    canCheckBiometrics = await LocalAuthentication().canCheckBiometrics;
    availableBiometrics = await LocalAuthentication().getAvailableBiometrics();
  }
}
