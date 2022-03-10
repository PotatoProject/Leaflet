import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monet/monet.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/theme/colors.dart';
import 'package:potato_notes/internal/theme/data.dart';
import 'package:potato_notes/internal/theme/shapes.dart';
import 'package:toml/toml.dart';

Future<ThemeParser> themeParserFromAsset(String assetName) async {
  final String themeContents = await rootBundle.loadString(assetName);
  final ThemeParser parser = ThemeParser.fromString(themeContents);

  return parser;
}

class ThemeParser {
  static const List<int> _validMonetShades = [
    0,
    10,
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
    1000,
  ];
  static const List<int> _validColorShades = [
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
  ];
  static final Map<String, ColorSwatch> _colors = {
    "red": Colors.red,
    "pink": Colors.pink,
    "purple": Colors.purple,
    "deepPurple": Colors.deepPurple,
    "indigo": Colors.indigo,
    "blue": Colors.blue,
    "lightBlue": Colors.lightBlue,
    "cyan": Colors.cyan,
    "teal": Colors.teal,
    "green": Colors.green,
    "lightGreen": Colors.lightGreen,
    "lime": Colors.lime,
    "yellow": Colors.yellow,
    "amber": Colors.amber,
    "orange": Colors.orange,
    "deepOrange": Colors.deepOrange,
    "brown": Colors.brown,
    "grey": Colors.grey,
    "blueGrey": Colors.blueGrey,
  };
  static final MonetPalette _errors = MonetPalette(const {
    0: Color(0xFFFFFFFF),
    10: Color(0xFFFCFCFC),
    50: Color(0xFFFFEDE9),
    100: Color(0xFFFFDAD4),
    200: Color(0xFFFFB4A9),
    300: Color(0xFFFF897A),
    400: Color(0xFFFF5449),
    500: Color(0xFFDD3730),
    600: Color(0xFFBA1B1B),
    700: Color(0xFF930006),
    800: Color(0xFF680003),
    900: Color(0xFF410001),
    1000: Color(0xFF000000),
  });

  final Map<String, dynamic> data;

  const ThemeParser(this.data);

  factory ThemeParser.fromString(String rawContents) {
    return ThemeParser(TomlDocument.parse(rawContents).toMap());
  }

  static Future<ThemeParser> fromFile(File file) async {
    final String fileContents = await file.readAsString();
    return ThemeParser.fromString(fileContents);
  }

  LeafletThemeData parse() {
    final Map<String, dynamic> info = data.getRequiredMap("info");
    final Map<String, dynamic> shapes = data.getRequiredMap("shapes");
    final Map<String, dynamic> colors = data.getRequiredMap("colors");
    final Map<String, dynamic>? illustrationColors =
        colors.getOptionalMap("illustrations");
    final Map<String, dynamic>? noteColors = colors.getOptionalMap("notes");

    final String name = info.getRequired<String>("name");
    final String author = info.getRequired<String>("author");
    final int version = info.getRequired<int>("version");
    final Brightness brightness =
        _parseBrightness(info.getRequired<String>("brightness"));
    final bool useMaterial3 = info.getOptional<bool>("useMaterial3") ?? false;

    final ColorScheme colorScheme = _parseColorScheme(colors, brightness);
    final ShapeTheme shapeTheme = _parseShapes(shapes);
    final NoteColorPalette notePalette = _harmonizeIfMaterial3(
      noteColors != null
          ? _parseNoteColorPalette(noteColors)
          : _notePaletteFromBrightness(brightness),
      colorScheme.primary,
      useMaterial3,
    );
    final IllustrationPalette illustrationPalette = illustrationColors != null
        ? _parseIllustrationPalette(illustrationColors)
        : _illustrationPaletteFromBrightness(brightness);

    return LeafletThemeData(
      name: name,
      author: author,
      version: version,
      useMaterial3: useMaterial3,
      notePalette: notePalette,
      illustrationPalette: illustrationPalette,
      shapes: shapeTheme,
      colors: colorScheme,
    );
  }

  NoteColorPalette _harmonizeIfMaterial3(
    NoteColorPalette palette,
    Color primary,
    bool useMaterial3,
  ) {
    if (!useMaterial3) return palette;

    return palette.harmonize(primary);
  }

  NoteColorPalette _notePaletteFromBrightness(Brightness brightness) {
    return brightness == Brightness.dark
        ? NoteColorPalette.dark
        : NoteColorPalette.light;
  }

  IllustrationPalette _illustrationPaletteFromBrightness(
    Brightness brightness,
  ) {
    return brightness == Brightness.dark
        ? IllustrationPalette.dark
        : IllustrationPalette.light;
  }

  Brightness _parseBrightness(String brightness) {
    switch (brightness) {
      case "light":
        return Brightness.light;
      case "dark":
        return Brightness.dark;
      default:
        throw BadValueException<String>(
          "brightness",
          brightness,
          ["light", "dark"],
        );
    }
  }

  ShapeTheme _parseShapes(Map<String, dynamic> shapes) {
    final OutlinedBorder smallComponents =
        _parseShape(shapes.getRequiredMap("smallComponents"))!;
    final OutlinedBorder mediumComponents =
        _parseShape(shapes.getRequiredMap("mediumComponents"))!;
    final OutlinedBorder largeComponents =
        _parseShape(shapes.getRequiredMap("largeComponents"))!;

    final OutlinedBorder? buttonOverride =
        _parseShape(shapes.getOptionalMap("buttonOverride"));
    final OutlinedBorder? chipOverride =
        _parseShape(shapes.getOptionalMap("chipOverride"));
    final OutlinedBorder? fabOverride =
        _parseShape(shapes.getOptionalMap("fabOverride"));
    final OutlinedBorder? snackbarOverride =
        _parseShape(shapes.getOptionalMap("snackbarOverride"));
    final OutlinedBorder? tooltipOverride =
        _parseShape(shapes.getOptionalMap("tooltipOverride"));

    final OutlinedBorder? cardOverride =
        _parseShape(shapes.getOptionalMap("cardOverride"));
    final OutlinedBorder? dialogOverride =
        _parseShape(shapes.getOptionalMap("dialogOverride"));
    final OutlinedBorder? imageOverride =
        _parseShape(shapes.getOptionalMap("imageOverride"));
    final OutlinedBorder? menuOverride =
        _parseShape(shapes.getOptionalMap("menuOverride"));

    final OutlinedBorder? bottomSheetOverride =
        _parseShape(shapes.getOptionalMap("bottomSheetOverride"));
    final OutlinedBorder? pageOverride =
        _parseShape(shapes.getOptionalMap("pageOverride"));

    return ShapeTheme(
      smallComponents: smallComponents,
      buttonShapeOverride: buttonOverride,
      chipShapeOverride: chipOverride,
      fabShapeOverride: fabOverride,
      snackbarShapeOverride: snackbarOverride,
      tooltipShapeOverride: tooltipOverride,
      mediumComponents: mediumComponents,
      cardShapeOverride: cardOverride,
      dialogShapeOverride: dialogOverride,
      imageShapeOverride: imageOverride,
      menuShapeOverride: menuOverride,
      largeComponents: largeComponents,
      bottomSheetShapeOverride: bottomSheetOverride,
      pageShapeOverride: pageOverride,
    );
  }

  ColorScheme _parseColorScheme(
    Map<String, dynamic> colors,
    Brightness brightness,
  ) {
    final Color primary = _parseColor(colors.getRequired<String>("primary"))!;
    final Color? onPrimary =
        _parseColor(colors.getOptional<String>("onPrimary"));
    final Color? primaryContainer =
        _parseColor(colors.getOptional<String>("primaryContainer"));
    final Color? onPrimaryContainer =
        _parseColor(colors.getOptional<String>("onPrimaryContainer"));
    final Color? secondary =
        _parseColor(colors.getOptional<String>("secondary"));
    final Color? onSecondary =
        _parseColor(colors.getOptional<String>("onSecondary"));
    final Color? secondaryContainer =
        _parseColor(colors.getOptional<String>("secondaryContainer"));
    final Color? onSecondaryContainer =
        _parseColor(colors.getOptional<String>("onSecondaryContainer"));
    final Color? tertiary = _parseColor(colors.getOptional<String>("tertiary"));
    final Color? onTertiary =
        _parseColor(colors.getOptional<String>("onTertiary"));
    final Color? tertiaryContainer =
        _parseColor(colors.getOptional<String>("tertiaryContainer"));
    final Color? onTertiaryContainer =
        _parseColor(colors.getOptional<String>("onTertiaryContainer"));
    final Color error = _parseColor(colors.getRequired<String>("error"))!;
    final Color? onError = _parseColor(colors.getOptional<String>("onError"));
    final Color? errorContainer =
        _parseColor(colors.getOptional<String>("errorContainer"));
    final Color? onErrorContainer =
        _parseColor(colors.getOptional<String>("onErrorContainer"));
    final Color surface = _parseColor(colors.getRequired<String>("surface"))!;
    final Color? onSurface =
        _parseColor(colors.getOptional<String>("onSurface"));
    final Color background =
        _parseColor(colors.getRequired<String>("background"))!;
    final Color? onBackground =
        _parseColor(colors.getOptional<String>("onBackground"));
    final Color? surfaceVariant =
        _parseColor(colors.getOptional<String>("surfaceVariant"));
    final Color? onSurfaceVariant =
        _parseColor(colors.getOptional<String>("onSurfaceVariant"));
    final Color? outline = _parseColor(colors.getOptional<String>("outline"));
    final Color? shadow = _parseColor(colors.getOptional<String>("shadow"));
    final Color? inverseSurface =
        _parseColor(colors.getOptional<String>("inverseSurface"));
    final Color? onInverseSurface =
        _parseColor(colors.getOptional<String>("onInverseSurface"));
    final Color? inversePrimary =
        _parseColor(colors.getOptional<String>("inversePrimary"));

    return ColorScheme(
      primary: primary,
      onPrimary: onPrimary ?? primary.contrasting,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? primaryContainer?.contrasting,
      secondary: secondary ?? primary,
      onSecondary: onSecondary ?? secondary?.contrasting ?? primary.contrasting,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer:
          onSecondaryContainer ?? secondaryContainer?.contrasting,
      tertiary: tertiary,
      onTertiary: onTertiary ?? tertiary?.contrasting,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer:
          onTertiaryContainer ?? tertiaryContainer?.contrasting,
      error: error,
      onError: onError ?? error.contrasting,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer ?? errorContainer?.contrasting,
      surface: surface,
      onSurface: onSurface ?? surface.contrasting,
      background: background,
      onBackground: onBackground ?? background.contrasting,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant ?? surfaceVariant?.contrasting,
      outline: outline,
      shadow: shadow,
      inverseSurface: inverseSurface,
      onInverseSurface: onInverseSurface ?? inverseSurface?.contrasting,
      inversePrimary: inversePrimary,
      brightness: brightness,
    );
  }

  OutlinedBorder? _parseShape(Map<String, dynamic>? shape) {
    if (shape == null) return null;

    final String type = shape.getRequired<String>("type");
    final Map<String, dynamic>? radius =
        shape["radius"] as Map<String, dynamic>?;

    switch (type) {
      case "circle":
        return const CircleBorder();
      case "stadium":
        return const StadiumBorder();
      case "rounded":
        return RoundedRectangleBorder(borderRadius: _parseRadius(radius));
      case "beveled":
        return BeveledRectangleBorder(borderRadius: _parseRadius(radius));
      case "continuous":
        return ContinuousRectangleBorder(borderRadius: _parseRadius(radius));
      default:
        throw BadValueException("type", type, [
          "circle",
          "stadium",
          "rounded",
          "beveled",
          "continuous",
        ]);
    }
  }

  IllustrationPalette _parseIllustrationPalette(
    Map<String, dynamic> illustrations,
  ) {
    final Color base = _parseColor(illustrations.getRequired<String>("base"))!;
    final Color contrast =
        _parseColor(illustrations.getRequired<String>("contrast"))!;
    final Color invertedContrast =
        _parseColor(illustrations.getRequired<String>("invertedContrast"))!;

    return IllustrationPalette(
      contrast: contrast,
      invertedContrast: invertedContrast,
      base: base,
    );
  }

  NoteColorPalette _parseNoteColorPalette(
    Map<String, dynamic> notes,
  ) {
    final Color red = _parseColor(notes.getRequired<String>("red"))!;
    final Color orange = _parseColor(notes.getRequired<String>("orange"))!;
    final Color yellow = _parseColor(notes.getRequired<String>("yellow"))!;
    final Color green = _parseColor(notes.getRequired<String>("green"))!;
    final Color cyan = _parseColor(notes.getRequired<String>("cyan"))!;
    final Color lightBlue =
        _parseColor(notes.getRequired<String>("lightBlue"))!;
    final Color blue = _parseColor(notes.getRequired<String>("blue"))!;
    final Color purple = _parseColor(notes.getRequired<String>("purple"))!;
    final Color pink = _parseColor(notes.getRequired<String>("pink"))!;

    return NoteColorPalette.fromColors(
      empty: Colors.transparent,
      red: red,
      orange: orange,
      yellow: yellow,
      green: green,
      cyan: cyan,
      lightBlue: lightBlue,
      blue: blue,
      purple: purple,
      pink: pink,
    );
  }

  BorderRadiusGeometry _parseRadius(Map<String, dynamic>? radius) {
    if (radius == null || radius.isEmpty) return BorderRadius.zero;
    if (radius.length != 1) {
      throw "bad";
    }

    if (radius.containsKey("all")) {
      return BorderRadius.circular((radius["all"]! as num).toDouble());
    }

    if (radius.containsKey("only")) {
      final List<double> radii = (radius["only"]! as List<dynamic>)
          .cast<num>()
          .map((e) => e.toDouble())
          .toList();

      if (radii.length != 4) {
        throw "bad";
      }

      return BorderRadius.only(
        topLeft: Radius.circular(radii[0]),
        topRight: Radius.circular(radii[1]),
        bottomLeft: Radius.circular(radii[2]),
        bottomRight: Radius.circular(radii[3]),
      );
    }

    if (radius.containsKey("directional")) {
      final List<double> radii = (radius["directional"]! as List<dynamic>)
          .cast<num>()
          .map((e) => e.toDouble())
          .toList();

      if (radii.length != 4) {
        throw "bad";
      }

      return BorderRadiusDirectional.only(
        topStart: Radius.circular(radii[0]),
        topEnd: Radius.circular(radii[1]),
        bottomStart: Radius.circular(radii[2]),
        bottomEnd: Radius.circular(radii[3]),
      );
    }

    return BorderRadius.zero;
  }

  Color? _parseColor(String? color) {
    if (color == null) return null;

    if (color.startsWith("#")) {
      return _colorFromHex(color);
    }

    if (color == "system") {
      return appInfo.accentData;
    }

    if (color.startsWith("monet.")) {
      final List<String> parts = color.split(".");
      if (parts.length != 2 && parts.length != 3) throw "bad";

      final ColorSwatch palette =
          _parsePalette(parts[1], monet.getColors(appInfo.accentData), true);
      final int shade = parts.length != 2 ? _parseShade(parts[2], true) : 500;

      return palette[shade]!;
    }

    if (color.startsWith("color.")) {
      final List<String> parts = color.split(".");
      if (parts.length != 2 && parts.length != 3) throw "bad";

      final ColorSwatch palette =
          _parsePalette(parts[1], monet.getColors(appInfo.accentData));
      final int shade = parts.length != 2 ? _parseShade(parts[2]) : 500;

      return palette[shade]!;
    }

    throw "bad";
  }

  ColorSwatch _parsePalette(
    String palette,
    MonetColors monetColors, [
    bool monetPalette = false,
  ]) {
    final Map<String, ColorSwatch> _monetColors = {
      "primaries": monetColors.accent1,
      "secondaries": monetColors.accent2,
      "tertiaries": monetColors.accent3,
      "neutrals": monetColors.neutral1,
      "neutralVariants": monetColors.neutral2,
      "errors": _errors,
    };
    final Map<String, ColorSwatch> colors =
        monetPalette ? _monetColors : _colors;

    if (!colors.containsKey(palette)) throw "bad";

    return colors[palette]!;
  }

  int _parseShade(String shade, [bool monetPalette = false]) {
    final int? shadeNum = int.tryParse(shade);
    final List<int> validShades =
        monetPalette ? _validMonetShades : _validColorShades;

    if (shadeNum == null) throw "bad";

    if (validShades.contains(shadeNum)) {
      return shadeNum;
    }

    throw "bad";
  }

  Color _colorFromHex(String hex) {
    String cleanHex = hex.replaceAll("#", "");
    if (cleanHex.length == 6) {
      // ex. #4a5ccc -> #FF4a5ccc0
      cleanHex = ["FF", cleanHex].join();
    } else if (cleanHex.length == 3) {
      // ex. #ccd -> #FFccdccd
      cleanHex = ["FF", cleanHex, cleanHex].join();
    } else if (cleanHex.length == 2) {
      // ex. #2a -> #FF2a2a2a
      cleanHex = ["FF", cleanHex, cleanHex, cleanHex].join();
    }
    final int? colorValue = int.tryParse(cleanHex, radix: 16);

    if (colorValue == null) throw "Bad color value";
    return Color(colorValue);
  }
}

class MissingRequiredEntryException implements Exception {
  final String entryName;

  const MissingRequiredEntryException(this.entryName);

  @override
  String toString() {
    return 'The source data is missing the required parameter $entryName.';
  }
}

class BadValueException<T> implements Exception {
  final String parameterName;
  final T receivedValue;
  final List<T> validValues;

  const BadValueException(
    this.parameterName,
    this.receivedValue,
    this.validValues,
  );

  @override
  String toString() {
    return 'The value "$receivedValue" for $parameterName is not contained in the range of accepted values: ${validValues.join(", ")}.';
  }
}

extension on Map<String, dynamic> {
  T getRequired<T>(String key) {
    final dynamic value = this[key];

    if (value != null) return value as T;

    throw MissingRequiredEntryException(key);
  }

  Map<String, dynamic> getRequiredMap(String key) {
    return getRequired<Map<String, dynamic>>(key);
  }

  T? getOptional<T>(String key) {
    final dynamic value = this[key];

    if (value != null) return value as T;

    return null;
  }

  Map<String, dynamic>? getOptionalMap(String key) {
    return getOptional<Map<String, dynamic>>(key);
  }
}
