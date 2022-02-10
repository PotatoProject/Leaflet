import 'package:flutter/material.dart';
import 'package:monet/monet.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/theme/colors.dart';
import 'package:potato_notes/internal/theme/data.dart';
import 'package:potato_notes/internal/theme/shapes.dart';

const ShapeTheme _kDefaultShapes = ShapeTheme(
  smallComponents: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
  ),
  mediumComponents: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
  ),
  largeComponents: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
  fabShapeOverride: CircleBorder(),
  bottomSheetShapeOverride: RoundedRectangleBorder(),
  dialogShapeOverride: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  chipShapeOverride: StadiumBorder(),
);

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

  LeafletThemeData get light => LeafletThemeData(
        name: "Default light",
        author: "HrX03",
        version: 1,
        notePalette: NoteColorPalette.light,
        illustrationPalette: IllustrationPalette.light,
        colors: ColorScheme(
          primary: mainColor,
          secondary: mainColor,
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
        shapes: _kDefaultShapes,
      );

  LeafletThemeData get lightMonet => LeafletThemeData(
        name: "Dynamic light",
        author: "HrX03",
        version: 1,
        notePalette: NoteColorPalette.light,
        illustrationPalette: IllustrationPalette(
          base: monetColors.accent2.shade600,
          contrast: monetColors.accent2.shade800,
          invertedContrast: monetColors.accent2.shade300,
        ),
        colors: ColorScheme(
          primary: monetColors.accent1.shade600,
          secondary: monetColors.accent1.shade600,
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
        shapes: _kDefaultShapes,
      );

  LeafletThemeData get dark => LeafletThemeData(
        name: "Default dark",
        author: "HrX03",
        version: 1,
        notePalette: NoteColorPalette.dark,
        illustrationPalette: IllustrationPalette.dark,
        colors: ColorScheme(
          primary: mainColor,
          secondary: mainColor,
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
        shapes: _kDefaultShapes,
      );

  LeafletThemeData get darkMonet => LeafletThemeData(
        name: "Dynamic dark",
        author: "HrX03",
        version: 1,
        notePalette: NoteColorPalette.dark,
        illustrationPalette: IllustrationPalette(
          base: monetColors.accent2.shade400,
          contrast: monetColors.accent2.shade200,
          invertedContrast: monetColors.accent2.shade600,
        ),
        colors: ColorScheme(
          primary: monetColors.accent1.shade300,
          secondary: monetColors.accent1.shade300,
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
        shapes: _kDefaultShapes,
      );

  LeafletThemeData get black => LeafletThemeData(
        name: "AMOLED black",
        author: "HrX03",
        version: 1,
        notePalette: NoteColorPalette.dark,
        illustrationPalette: IllustrationPalette.dark,
        colors: ColorScheme(
          primary: mainColor,
          secondary: mainColor,
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
        shapes: _kDefaultShapes,
      );
}
