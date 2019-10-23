import 'package:flutter/material.dart';
import 'package:potato_notes/internal/app_info.dart';

class CustomThemes {
  static ThemeData black(AppInfoProvider appInfo) {
    return ThemeData.dark().copyWith(
      accentColor: appInfo.mainColor,
      backgroundColor: appInfo.mainColor,
      bottomAppBarColor: Colors.black,
      canvasColor: Colors.black,
      cardColor: Colors.black,
      cursorColor: appInfo.mainColor,
      dialogBackgroundColor: Colors.black,
      primaryColor: appInfo.mainColor,
      primaryColorLight: Colors.black,
      secondaryHeaderColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      textSelectionHandleColor: appInfo.mainColor,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent,
        hoverColor: appInfo.mainColor,
      ),
      buttonColor: appInfo.mainColor,
    );
  }

  static ThemeData dark(AppInfoProvider appInfo) {
    return ThemeData.dark().copyWith(
      accentColor: appInfo.mainColor,
      cursorColor: appInfo.mainColor,
      textSelectionHandleColor: appInfo.mainColor,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent,
        hoverColor: appInfo.mainColor,
      ),
      buttonColor: appInfo.mainColor,
      primaryColor: appInfo.mainColor,
      backgroundColor: appInfo.mainColor,
      cardColor: Color(0xFF151618),
      scaffoldBackgroundColor: Color(0xFF212121),
      dialogBackgroundColor: Color(0xFF212121),
      bottomAppBarColor: Color(0xFF212121),
      canvasColor: Color(0xFF212121),
    );
  }

  static ThemeData light(AppInfoProvider appInfo) {
    Color scaffoldBackup = ThemeData.light().scaffoldBackgroundColor;

    return ThemeData.light().copyWith(
      accentColor: appInfo.mainColor,
      cursorColor: appInfo.mainColor,
      textSelectionHandleColor: appInfo.mainColor,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent,
        hoverColor: appInfo.mainColor,
      ),
      scaffoldBackgroundColor: ThemeData.light().cardColor,
      cardColor: scaffoldBackup,
      buttonColor: appInfo.mainColor,
      primaryColor: appInfo.mainColor,
      backgroundColor: appInfo.mainColor,
    );
  }

  static Brightness getCurrentBrightness(
      BuildContext context, AppInfoProvider appInfo) {
    return Theme.of(context).brightness;
  }
}
