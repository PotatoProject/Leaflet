import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/widget/dismissible_route.dart';

class Themes {
  Color mainColor = Colors.blueAccent;

  Themes(this.mainColor);

  static final Color lightColor = Colors.white;
  static final Color lightSecondaryColor = Color(0xFFFAFAFA);
  static final Color darkColor = Color(0xFF212121);
  static final Color darkSecondaryColor = Color(0xFF161616);
  static final Color blackColor = Color(0xFF0E0E0E);
  static final Color blackSecondaryColor = Colors.black;

  ThemeData get light => ThemeData.light().copyWith(
        accentColor: mainColor,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: mainColor,
          selectionHandleColor: mainColor,
          selectionColor: mainColor,
        ),
        colorScheme: ColorScheme.light(
          surface: lightColor,
          primary: mainColor,
          secondary: lightColor,
          onPrimary: lightColor,
          onSecondary: mainColor,
        ),
        appBarTheme: AppBarTheme(
          color: lightSecondaryColor.withOpacity(0.9),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
          actionsIconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
          brightness: Brightness.light,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: lightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: lightColor,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: lightColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: lightSecondaryColor,
        cardColor: lightColor,
        canvasColor: lightColor,
        buttonColor: mainColor,
        primaryColor: mainColor,
        backgroundColor: mainColor,
        iconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
        disabledColor: Colors.black.withOpacity(0.4),
        shadowColor: Colors.black.withOpacity(0.5),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: mainColor,
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 4,
        ),
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
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: mainColor,
          selectionHandleColor: mainColor,
          selectionColor: mainColor,
        ),
        colorScheme: ColorScheme.dark(
          surface: darkColor,
          primary: mainColor,
          secondary: darkColor,
          onPrimary: darkColor,
          onSecondary: mainColor,
        ),
        appBarTheme: AppBarTheme(
          color: darkSecondaryColor.withOpacity(0.9),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
          actionsIconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
          brightness: Brightness.dark,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: darkColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: darkColor,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: darkColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: darkSecondaryColor,
        cardColor: darkColor,
        canvasColor: darkColor,
        buttonColor: mainColor,
        primaryColor: mainColor,
        backgroundColor: mainColor,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        disabledColor: Colors.white.withOpacity(0.4),
        shadowColor: Colors.black.withOpacity(0.5),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: mainColor,
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 4,
        ),
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
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: mainColor,
          selectionHandleColor: mainColor,
          selectionColor: mainColor,
        ),
        colorScheme: ColorScheme.dark(
          surface: blackColor,
          primary: mainColor,
          secondary: blackColor,
          onPrimary: blackColor,
          onSecondary: mainColor,
        ),
        appBarTheme: AppBarTheme(
          color: blackSecondaryColor.withOpacity(0.7),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
          actionsIconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
          brightness: Brightness.dark,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: blackColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: blackColor,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: blackColor,
          shape: RoundedRectangleBorder(),
        ),
        scaffoldBackgroundColor: blackSecondaryColor,
        cardColor: blackColor,
        canvasColor: blackColor,
        buttonColor: mainColor,
        primaryColor: mainColor,
        backgroundColor: mainColor,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        disabledColor: Colors.white.withOpacity(0.4),
        shadowColor: Colors.black.withOpacity(0.5),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: mainColor,
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 4,
        ),
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
