import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streams_channel/streams_channel.dart';

class AppInfoProvider extends ChangeNotifier {
  static final StreamsChannel accentStreamChannel = StreamsChannel('potato_notes_accents');
  static final StreamsChannel themeStreamChannel = StreamsChannel('potato_notes_themes');
  
  AppInfoProvider() {
    loadData();
  }

  // ignore: cancel_subscriptions
  StreamSubscription<dynamic> accentSubscription;
  // ignore: cancel_subscriptions
  StreamSubscription<dynamic> themeSubscription;

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

  void loadData() async {
    themeSubscription = themeStreamChannel
        .receiveBroadcastStream()
        .listen((data) => systemTheme = data
            ? Brightness.dark
            : Brightness.light);
    accentSubscription = accentStreamChannel
        .receiveBroadcastStream()
        .listen((data) => mainColor = Color(data));
    
    accentSubscription.onDone(() => print("bruh"));
  }
}