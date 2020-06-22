import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/app_info.dart';

class Themes {
  static AppInfoProvider appInfo;

  static void provideAppInfo(AppInfoProvider providedAppInfo) =>
      appInfo = providedAppInfo;

  static final Color _lightColor = Colors.white;
  static final Color _darkColor = Color(0xFF1C1C1C);
  static final Color _blackColor = Colors.black;

  static ThemeData get light => ThemeData.light().copyWith(
        accentColor: appInfo.mainColor,
        cursorColor: appInfo.mainColor,
        textSelectionHandleColor: appInfo.mainColor,
        colorScheme: ColorScheme.light(
          surface: _lightColor,
          primary: appInfo.mainColor,
          secondary: _lightColor,
          onPrimary: _lightColor,
          onSecondary: appInfo.mainColor,
        ),
        textSelectionColor: appInfo.mainColor,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.accent,
          hoverColor: appInfo.mainColor,
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: _lightColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: _lightColor,
        cardColor: _lightColor,
        canvasColor: _lightColor,
        buttonColor: appInfo.mainColor,
        primaryColor: appInfo.mainColor,
        backgroundColor: appInfo.mainColor,
        iconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
        disabledColor: Colors.black.withOpacity(0.7),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
          },
        ),
      );

  static ThemeData get dark => ThemeData.dark().copyWith(
        accentColor: appInfo.mainColor,
        cursorColor: appInfo.mainColor,
        textSelectionHandleColor: appInfo.mainColor,
        colorScheme: ColorScheme.dark(
          surface: _darkColor,
          primary: appInfo.mainColor,
          secondary: _darkColor,
          onPrimary: _darkColor,
          onSecondary: appInfo.mainColor,
        ),
        textSelectionColor: appInfo.mainColor,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.accent,
          hoverColor: appInfo.mainColor,
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: _darkColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: _darkColor,
        cardColor: _darkColor,
        canvasColor: _darkColor,
        buttonColor: appInfo.mainColor,
        primaryColor: appInfo.mainColor,
        backgroundColor: appInfo.mainColor,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        disabledColor: Colors.white.withOpacity(0.7),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
          },
        ),
      );

  static ThemeData get black => ThemeData.dark().copyWith(
        accentColor: appInfo.mainColor,
        cursorColor: appInfo.mainColor,
        textSelectionHandleColor: appInfo.mainColor,
        colorScheme: ColorScheme.dark(
          surface: _blackColor,
          primary: appInfo.mainColor,
          secondary: _blackColor,
          onPrimary: _blackColor,
          onSecondary: appInfo.mainColor,
        ),
        textSelectionColor: appInfo.mainColor,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.accent,
          hoverColor: appInfo.mainColor,
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: _blackColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: _blackColor,
        cardColor: _blackColor,
        canvasColor: _blackColor,
        buttonColor: appInfo.mainColor,
        primaryColor: appInfo.mainColor,
        backgroundColor: appInfo.mainColor,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        disabledColor: Colors.white.withOpacity(0.7),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
          },
        ),
      );
}