import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monet/monet.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/note_color_palette.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/dismissible_route.dart';
import 'package:potato_notes/widget/illustrations.dart';
import 'package:potato_notes/widget/leaflet_theme.dart';

class Themes {
  final Color? _mainColor;

  const Themes(this._mainColor);

  Color get mainColor => _mainColor ?? Colors.blueAccent;
  MonetColors get monetColors => monet.getColors(mainColor);

  static const Color lightColor = Color(0xFFFFFFFF);
  static const Color lightSecondaryColor = Color(0xFFFAFAFA);
  static const Color darkColor = Color(0xFF212121);
  static const Color darkSecondaryColor = Color(0xFF161616);
  static const Color blackColor = Color(0xFF121212);
  static const Color blackSecondaryColor = Color(0xFF000000);

  ThemeData get light => getThemeFromScheme(
        scheme: ColorScheme(
          primary: mainColor,
          primaryVariant: mainColor,
          secondary: mainColor,
          secondaryVariant: mainColor,
          surface: lightColor,
          background: lightSecondaryColor,
          error: Colors.red.shade500,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.grey.shade900,
          onBackground: Colors.grey.shade900,
          onError: Colors.grey.shade900,
          brightness: Brightness.light,
        ),
      );

  ThemeData get dark => getThemeFromScheme(
        scheme: ColorScheme(
          primary: mainColor,
          primaryVariant: mainColor,
          secondary: mainColor,
          secondaryVariant: mainColor,
          surface: darkColor,
          background: darkSecondaryColor,
          error: Colors.red.shade400,
          onPrimary: Colors.grey.shade900,
          onSecondary: Colors.grey.shade900,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.grey.shade900,
          brightness: Brightness.dark,
        ),
      );

  ThemeData get black => getThemeFromScheme(
        scheme: ColorScheme(
          primary: mainColor,
          primaryVariant: mainColor,
          secondary: mainColor,
          secondaryVariant: mainColor,
          surface: blackColor,
          background: blackSecondaryColor,
          error: Colors.red.shade400,
          onPrimary: Colors.grey.shade900,
          onSecondary: Colors.grey.shade900,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.grey.shade900,
          brightness: Brightness.dark,
        ),
      );

  ThemeData get lightMonet {
    return getThemeFromScheme(
      scheme: ColorScheme(
        primary: monetColors.accent1.shade600,
        primaryVariant: monetColors.accent1.shade600,
        secondary: monetColors.accent1.shade600,
        secondaryVariant: monetColors.accent1.shade600,
        surface: monetColors.accent2.shade50,
        background: monetColors.accent2.shade100,
        error: Colors.red.shade500,
        onPrimary: monetColors.accent2.shade50,
        onSecondary: monetColors.accent2.shade50,
        onSurface: monetColors.accent2.shade900,
        onBackground: monetColors.accent2.shade900,
        onError: Colors.grey.shade900,
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData get darkMonet {
    return getThemeFromScheme(
      scheme: ColorScheme(
        primary: monetColors.accent1.shade300,
        primaryVariant: monetColors.accent1.shade300,
        secondary: monetColors.accent1.shade300,
        secondaryVariant: monetColors.accent1.shade300,
        surface: monetColors.accent2.shade800,
        background: monetColors.accent2.shade900,
        error: Colors.red.shade400,
        onPrimary: monetColors.accent2.shade800,
        onSecondary: monetColors.accent2.shade800,
        onSurface: monetColors.accent2.shade50,
        onBackground: monetColors.accent2.shade50,
        onError: Colors.grey.shade900,
        brightness: Brightness.dark,
      ),
    );
  }

  LeafletThemeData get leafletLight => LeafletThemeData(
        notePalette: NoteColorPalette.light(),
        illustrationPalette: IllustrationPalette.light,
      );

  LeafletThemeData get leafletLightMonet {
    return LeafletThemeData(
      notePalette: NoteColorPalette.light(),
      illustrationPalette: IllustrationPalette(
        base: monetColors.accent2.shade600,
        contrast: monetColors.accent2.shade800,
        invertedContrast: monetColors.accent2.shade300,
      ),
    );
  }

  LeafletThemeData get leafletDark => LeafletThemeData(
        notePalette: NoteColorPalette.dark(),
        illustrationPalette: IllustrationPalette.dark,
      );

  LeafletThemeData get leafletDarkMonet {
    return LeafletThemeData(
      notePalette: NoteColorPalette.dark(),
      illustrationPalette: IllustrationPalette(
        base: monetColors.accent2.shade400,
        contrast: monetColors.accent2.shade200,
        invertedContrast: monetColors.accent2.shade600,
      ),
    );
  }

  static ThemeData getThemeFromScheme({required ColorScheme scheme}) {
    return ThemeData(
      brightness: scheme.brightness,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionHandleColor: scheme.primary,
        selectionColor: scheme.primary.withOpacity(0.4),
      ),
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        color: scheme.background.withOpacity(0.7),
        elevation: 0,
        titleTextStyle: TextStyle(color: scheme.onSurface, fontSize: 20),
        iconTheme: IconThemeData(color: scheme.onSurface.withOpacity(0.7)),
        actionsIconTheme:
            IconThemeData(color: scheme.onSurface.withOpacity(0.7)),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarBrightness: scheme.brightness,
          statusBarIconBrightness: scheme.brightness.reverse,
          systemNavigationBarIconBrightness: scheme.brightness.reverse,
          systemNavigationBarContrastEnforced: true,
          systemStatusBarContrastEnforced: false,
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      cardTheme: const CardTheme(elevation: 0),
      snackBarTheme: SnackBarThemeData(actionTextColor: scheme.surface),
      bottomSheetTheme: BottomSheetThemeData(
        modalBackgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(),
      ),
      scrollbarTheme: ScrollbarThemeData(
        isAlwaysShown: true,
        thickness: MaterialStateProperty.resolveWith((states) {
          if ([
            MaterialState.hovered,
            MaterialState.dragged,
            MaterialState.focused,
            MaterialState.pressed,
          ].fold(false, (val, el) => val || states.contains(el))) {
            return 8;
          } else {
            return 4;
          }
        }),
        crossAxisMargin: 0,
        radius: Radius.zero,
      ),
      scaffoldBackgroundColor: scheme.background,
      cardColor: scheme.surface,
      canvasColor: scheme.surface,
      primaryColor: scheme.primary,
      backgroundColor: scheme.primary,
      iconTheme: IconThemeData(color: scheme.onSurface.withOpacity(0.7)),
      disabledColor: scheme.onSurface.withOpacity(0.4),
      shadowColor: Colors.black.withOpacity(0),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: scheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 4,
      ),
      toggleableActiveColor: scheme.primary,
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all<Color>(scheme.background),
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
}
