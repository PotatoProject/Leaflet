import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/internal/app_info.dart';

class SystemBarManager {
  AppInfoProvider appInfo;

  Color lightNavBarColor;
  Color darkNavBarColor;

  Brightness lightIconColor;
  Brightness darkIconColor;

  SystemBarManager(this.appInfo);

  void updateColors() {
    switch (appInfo.systemTheme) {
      case Brightness.light:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: lightNavBarColor,
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: darkIconColor,
          statusBarIconBrightness: darkIconColor,
        ));
        break;
      case Brightness.dark:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: darkNavBarColor,
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: lightIconColor,
          statusBarIconBrightness: lightIconColor,
        ));
        break;
    }
  }
}
