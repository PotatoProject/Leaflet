import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/internal/illustrations.dart';
import 'package:potato_notes/internal/system_bar_manager.dart';
import 'package:streams_channel/streams_channel.dart';

class AppInfoProvider extends ChangeNotifier {
  BuildContext context;
  static final StreamsChannel accentStreamChannel =
      StreamsChannel('potato_notes_accents');
  static final StreamsChannel themeStreamChannel =
      StreamsChannel('potato_notes_themes');

  AppInfoProvider(this.context) {
    illustrations = Illustrations(context);
    loadData();

    barManager = SystemBarManager(this);
  }

  // ignore: cancel_subscriptions
  StreamSubscription<dynamic> accentSubscription;
  // ignore: cancel_subscriptions
  StreamSubscription<dynamic> themeSubscription;
  Illustrations illustrations;
  SystemBarManager barManager;

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
    emptyArchiveIllustration = await illustrations.emptyArchiveIllustration(systemTheme);
    emptyTrashIllustration = await illustrations.emptyTrashIllustration(systemTheme);
  }

  void loadData() async {
    themeSubscription =
        themeStreamChannel.receiveBroadcastStream().listen((data) {
      systemTheme = data ? Brightness.dark : Brightness.light;
    });
    accentSubscription =
        accentStreamChannel.receiveBroadcastStream().listen((data) {
      mainColor = Color(data);
    });
  }
}
