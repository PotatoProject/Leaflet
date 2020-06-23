import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/app_info.dart';

class Themes {
  static AppInfoProvider appInfo;

  static void provideAppInfo(AppInfoProvider providedAppInfo) =>
      appInfo = providedAppInfo;

  static final Color _lightColor = Colors.white;
  static final Color _lightSecondaryColor = Color(0xFFF6F6F6);
  static final Color _darkColor = Color(0xFF212121);
  static final Color _darkSecondaryColor = Color(0xFF161616);
  static final Color _blackColor = Color(0xFF0E0E0E);
  static final Color _blackSecondaryColor = Colors.black;

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
        appBarTheme: AppBarTheme(
          color: _lightSecondaryColor.withOpacity(0.9),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
          actionsIconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
        ),
        textSelectionColor: appInfo.mainColor,
        dialogTheme: DialogTheme(
          backgroundColor: _lightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: _lightColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: _lightSecondaryColor,
        cardColor: _lightColor,
        canvasColor: _lightColor,
        buttonColor: appInfo.mainColor,
        primaryColor: appInfo.mainColor,
        backgroundColor: appInfo.mainColor,
        iconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
        disabledColor: Colors.black.withOpacity(0.4),
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
        appBarTheme: AppBarTheme(
          color: _darkSecondaryColor.withOpacity(0.9),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
          actionsIconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        ),
        textSelectionColor: appInfo.mainColor,
        dialogTheme: DialogTheme(
          backgroundColor: _darkColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: _darkColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: _darkSecondaryColor,
        cardColor: _darkColor,
        canvasColor: _darkColor,
        buttonColor: appInfo.mainColor,
        primaryColor: appInfo.mainColor,
        backgroundColor: appInfo.mainColor,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        disabledColor: Colors.white.withOpacity(0.4),
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
        appBarTheme: AppBarTheme(
          color: _blackSecondaryColor.withOpacity(0.7),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
          actionsIconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        ),
        textSelectionColor: appInfo.mainColor,
        dialogTheme: DialogTheme(
          backgroundColor: _blackColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: _blackColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: _blackSecondaryColor,
        cardColor: _blackColor,
        canvasColor: _blackColor,
        buttonColor: appInfo.mainColor,
        primaryColor: appInfo.mainColor,
        backgroundColor: appInfo.mainColor,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        disabledColor: Colors.white.withOpacity(0.4),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
          },
        ),
      );
}