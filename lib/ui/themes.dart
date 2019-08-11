import 'package:flutter/material.dart';
import 'package:potato_notes/internal/app_info.dart';

class CustomThemes {
  static ThemeData black(AppInfoProvider appInfo) {
    return ThemeData.dark().copyWith(
      accentColor: appInfo.mainColor,
      backgroundColor: Colors.black,
      bottomAppBarColor: Colors.black,
      canvasColor: Colors.black,
      cardColor: Colors.black,
      cursorColor: appInfo.mainColor,
      dialogBackgroundColor: Colors.black,
      primaryColor: Colors.black,
      primaryColorLight: Colors.black,
      secondaryHeaderColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      textSelectionHandleColor: appInfo.mainColor
    );
  }

  static ThemeData dark(AppInfoProvider appInfo) {
    return ThemeData.dark().copyWith(
      accentColor: appInfo.mainColor,
      cursorColor: appInfo.mainColor,
      textSelectionHandleColor: appInfo.mainColor
    );
  }

  static ThemeData light(AppInfoProvider appInfo) {
    return ThemeData.light().copyWith(
      accentColor: appInfo.mainColor,
      cursorColor: appInfo.mainColor,
      textSelectionHandleColor: appInfo.mainColor
    );
  }
}