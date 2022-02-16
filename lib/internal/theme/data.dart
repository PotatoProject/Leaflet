import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/theme/colors.dart';
import 'package:potato_notes/internal/theme/parser.dart';
import 'package:potato_notes/internal/theme/shapes.dart';
import 'package:potato_notes/widget/dismissible_route.dart';
import 'package:recase/recase.dart';

class LeafletThemeData {
  final String name;
  final String author;
  final int version;
  final bool useMaterial3;
  final NoteColorPalette notePalette;
  final IllustrationPalette illustrationPalette;
  final ShapeTheme shapes;
  final ColorScheme colors;

  const LeafletThemeData({
    required this.name,
    required this.author,
    required this.version,
    required this.useMaterial3,
    required this.notePalette,
    required this.illustrationPalette,
    required this.shapes,
    required this.colors,
  })  : assert(name != ""),
        assert(author != ""),
        assert(version >= 1);

  @override
  bool operator ==(Object? other) {
    if (other is LeafletThemeData) {
      return notePalette == other.notePalette &&
          illustrationPalette == other.illustrationPalette &&
          shapes == other.shapes &&
          colors == other.colors;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(
        notePalette,
        illustrationPalette,
        shapes,
        colors,
      );

  String get id => name.snakeCase;

  factory LeafletThemeData.lerp(
    LeafletThemeData a,
    LeafletThemeData b,
    double t,
  ) {
    return LeafletThemeData(
      name: t > 0.5 ? a.name : b.name,
      author: t > 0.5 ? a.author : b.author,
      version: t > 0.5 ? a.version : b.version,
      useMaterial3: t > 0.5 ? a.useMaterial3 : b.useMaterial3,
      notePalette: NoteColorPalette.lerp(
        a.notePalette,
        b.notePalette,
        t,
      ),
      illustrationPalette: IllustrationPalette.lerp(
        a.illustrationPalette,
        b.illustrationPalette,
        t,
      ),
      shapes: ShapeTheme.lerp(a.shapes, b.shapes, t),
      colors: ColorScheme.lerp(a.colors, b.colors, t),
    );
  }

  ThemeData get materialTheme {
    return ThemeData(
      brightness: colors.brightness,
      useMaterial3: useMaterial3,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.primary,
        selectionHandleColor: colors.primary,
        selectionColor: colors.primary.withOpacity(0.4),
      ),
      colorScheme: colors,
      appBarTheme: AppBarTheme(
        color: colors.background.withOpacity(0.7),
        elevation: 0,
        titleTextStyle: TextStyle(color: colors.onSurface, fontSize: 20),
        iconTheme: IconThemeData(color: colors.onSurface.withOpacity(0.7)),
        actionsIconTheme:
            IconThemeData(color: colors.onSurface.withOpacity(0.7)),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarBrightness: colors.brightness,
          statusBarIconBrightness: colors.brightness.reverse,
          systemNavigationBarIconBrightness: colors.brightness.reverse,
          systemNavigationBarContrastEnforced: true,
          systemStatusBarContrastEnforced: false,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: shapes.fabShape,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colors.surface,
        shape: shapes.dialogShape,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: shapes.cardShape,
      ),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: colors.surface,
        shape: shapes.snackbarShape,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: ShapeDecoration(
          shape: shapes.tooltipShape,
          color: colors.brightness == Brightness.dark
              ? Colors.white.withOpacity(0.9)
              : Colors.grey[700]!.withOpacity(0.9),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        modalBackgroundColor: colors.surface,
        shape: shapes.bottomSheetShape.excludeCorners(
          excludeBottomStart: true,
          excludeBottomEnd: true,
        ),
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
      scaffoldBackgroundColor: colors.background,
      cardColor: colors.surface,
      canvasColor: colors.surface,
      primaryColor: colors.primary,
      backgroundColor: colors.primary,
      iconTheme: IconThemeData(color: colors.onSurface.withOpacity(0.7)),
      disabledColor: colors.onSurface.withOpacity(0.4),
      shadowColor: Colors.black.withOpacity(0.5),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: shapes.menuShape,
        elevation: 4,
      ),
      toggleableActiveColor: colors.primary,
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all<Color>(colors.background),
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

class LeafletThemeDataTween extends Tween<LeafletThemeData> {
  LeafletThemeDataTween({LeafletThemeData? begin, LeafletThemeData? end})
      : super(begin: begin, end: end);

  @override
  LeafletThemeData lerp(double t) => LeafletThemeData.lerp(begin!, end!, t);
}

abstract class AppTheme {
  ThemeParser? _parser;
  LeafletThemeData? _data;

  Future<void> load() async {
    _parser = await _getThemeParser();
    _data = _parser!.parse();
  }

  void reparse() => _data = _parser!.parse();

  LeafletThemeData get data {
    if (_parser == null || _data == null) {
      throw Exception("The theme must be loaded before, call load()");
    }

    return _data!;
  }

  Future<ThemeParser> _getThemeParser();

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is AppTheme) {
      return _data == other._data;
    }

    return false;
  }
}

class BundledTheme extends AppTheme {
  final String assetName;

  BundledTheme(this.assetName);

  @override
  Future<ThemeParser> _getThemeParser() async {
    final String themeContents = await rootBundle.loadString(assetName);
    final ThemeParser parser = ThemeParser.fromString(themeContents);

    return parser;
  }

  @override
  int get hashCode => Object.hash(assetName.hashCode, super.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is BundledTheme) {
      return assetName == other.assetName && super == other;
    }

    return false;
  }

  @override
  String toString() {
    return "BundledTheme($assetName)";
  }
}

class ImportedTheme extends AppTheme {
  final String filePath;

  ImportedTheme(this.filePath);

  @override
  Future<ThemeParser> _getThemeParser() {
    return ThemeParser.fromFile(File(filePath));
  }

  @override
  int get hashCode => Object.hash(filePath.hashCode, super.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is ImportedTheme) {
      return filePath == other.filePath && super == other;
    }

    return false;
  }

  @override
  String toString() {
    return "ImportedTheme($filePath)";
  }
}
