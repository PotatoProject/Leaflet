import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/widget/dismissible_route.dart';

class Themes {
  Color mainColor = Colors.blueAccent;

  Themes(this.mainColor);

  static final Color _lightColor = Colors.white;
  static final Color _lightSecondaryColor = Color(0xFFFAFAFA);
  static final Color _darkColor = Color(0xFF212121);
  static final Color _darkSecondaryColor = Color(0xFF161616);
  static final Color _blackColor = Color(0xFF0E0E0E);
  static final Color _blackSecondaryColor = Colors.black;

  ThemeData get light => ThemeData.light().copyWith(
        accentColor: mainColor,
        cursorColor: mainColor,
        textSelectionHandleColor: mainColor,
        colorScheme: ColorScheme.light(
          surface: _lightColor,
          primary: mainColor,
          secondary: _lightColor,
          onPrimary: _lightColor,
          onSecondary: mainColor,
        ),
        appBarTheme: AppBarTheme(
          color: _lightSecondaryColor.withOpacity(0.9),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
          actionsIconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
          brightness: Brightness.light,
        ),
        textSelectionColor: mainColor,
        dialogTheme: DialogTheme(
          backgroundColor: _lightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: _lightColor,
        ),
        textTheme: ThemeData.light().textTheme.apply(fontFamily: "Manrope"),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: _lightColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: _lightSecondaryColor,
        cardColor: _lightColor,
        canvasColor: _lightColor,
        buttonColor: mainColor,
        primaryColor: mainColor,
        backgroundColor: mainColor,
        iconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
        disabledColor: Colors.black.withOpacity(0.4),
        platform: defaultTargetPlatform,
        shadowColor: Colors.black.withOpacity(0.5),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: DismissiblePageTransitionsBuilder(),
            TargetPlatform.iOS: DismissiblePageTransitionsBuilder(),
            TargetPlatform.fuchsia: DismissiblePageTransitionsBuilder(),
            TargetPlatform.macOS: DismissiblePageTransitionsBuilder(),
            TargetPlatform.linux: DismissiblePageTransitionsBuilder(),
            TargetPlatform.windows: DismissiblePageTransitionsBuilder(),
          },
        ),
      );

  ThemeData get dark => ThemeData.dark().copyWith(
        accentColor: mainColor,
        cursorColor: mainColor,
        textSelectionHandleColor: mainColor,
        colorScheme: ColorScheme.dark(
          surface: _darkColor,
          primary: mainColor,
          secondary: _darkColor,
          onPrimary: _darkColor,
          onSecondary: mainColor,
        ),
        appBarTheme: AppBarTheme(
          color: _darkSecondaryColor.withOpacity(0.9),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
          actionsIconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
          brightness: Brightness.dark,
        ),
        textSelectionColor: mainColor,
        dialogTheme: DialogTheme(
          backgroundColor: _darkColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: _darkColor,
        ),
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: "Manrope"),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: _darkColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: _darkSecondaryColor,
        cardColor: _darkColor,
        canvasColor: _darkColor,
        buttonColor: mainColor,
        primaryColor: mainColor,
        backgroundColor: mainColor,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        disabledColor: Colors.white.withOpacity(0.4),
        platform: defaultTargetPlatform,
        shadowColor: Colors.black.withOpacity(0.5),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: DismissiblePageTransitionsBuilder(),
            TargetPlatform.iOS: DismissiblePageTransitionsBuilder(),
            TargetPlatform.fuchsia: DismissiblePageTransitionsBuilder(),
            TargetPlatform.macOS: DismissiblePageTransitionsBuilder(),
            TargetPlatform.linux: DismissiblePageTransitionsBuilder(),
            TargetPlatform.windows: DismissiblePageTransitionsBuilder(),
          },
        ),
      );

  ThemeData get black => ThemeData.dark().copyWith(
        accentColor: mainColor,
        cursorColor: mainColor,
        textSelectionHandleColor: mainColor,
        colorScheme: ColorScheme.dark(
          surface: _blackColor,
          primary: mainColor,
          secondary: _blackColor,
          onPrimary: _blackColor,
          onSecondary: mainColor,
        ),
        appBarTheme: AppBarTheme(
          color: _blackSecondaryColor.withOpacity(0.7),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
          actionsIconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
          brightness: Brightness.dark,
        ),
        textSelectionColor: mainColor,
        dialogTheme: DialogTheme(
          backgroundColor: _blackColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: _blackColor,
        ),
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: "Manrope"),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: _blackColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: _blackSecondaryColor,
        cardColor: _blackColor,
        canvasColor: _blackColor,
        buttonColor: mainColor,
        primaryColor: mainColor,
        backgroundColor: mainColor,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        disabledColor: Colors.white.withOpacity(0.4),
        platform: defaultTargetPlatform,
        shadowColor: Colors.black.withOpacity(0.5),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: DismissiblePageTransitionsBuilder(),
            TargetPlatform.iOS: DismissiblePageTransitionsBuilder(),
            TargetPlatform.fuchsia: DismissiblePageTransitionsBuilder(),
            TargetPlatform.macOS: DismissiblePageTransitionsBuilder(),
            TargetPlatform.linux: DismissiblePageTransitionsBuilder(),
            TargetPlatform.windows: DismissiblePageTransitionsBuilder(),
          },
        ),
      );
}
