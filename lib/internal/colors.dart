import 'package:flutter/material.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/utils.dart';

class NoteColors {
  NoteColors._();

  static List<ColorInfo> get colorList => [
        NoteColors.none,
        NoteColors.red,
        NoteColors.orange,
        NoteColors.yellow,
        NoteColors.green,
        NoteColors.cyan,
        NoteColors.lightBlue,
        NoteColors.blue,
        NoteColors.purple,
        NoteColors.pink,
      ];

  static ColorInfo get none => ColorInfo(
        label: LocaleStrings.common.colorNone,
        color: Colors.transparent.value,
      );

  static ColorInfo get red => ColorInfo(
        label: LocaleStrings.common.colorRed,
        color: 0xFFF44336,
        lightColor: 0xFFF7786E,
        darkColor: 0xFF5B2925,
      );

  static ColorInfo get orange => ColorInfo(
        label: LocaleStrings.common.colorOrange,
        color: 0xFFF57C00,
        lightColor: 0xFFF5AF51,
        darkColor: 0xFF5B4325,
      );

  static ColorInfo get yellow => ColorInfo(
        label: LocaleStrings.common.colorYellow,
        color: 0xFFFFB300,
        lightColor: 0xFFF5E551,
        darkColor: 0xFF5B5525,
      );

  static ColorInfo get green => ColorInfo(
        label: LocaleStrings.common.colorGreen,
        color: 0xFF4CAF50,
        lightColor: 0xFF51F558,
        darkColor: 0xFF255B27,
      );

  static ColorInfo get cyan => ColorInfo(
        label: LocaleStrings.common.colorCyan,
        color: 0xFF00ACC1,
        lightColor: 0xFF51F5E0,
        darkColor: 0xFF255B53,
      );

  static ColorInfo get lightBlue => ColorInfo(
        label: LocaleStrings.common.colorLightBlue,
        color: 0xFF03A9f4,
        lightColor: 0xFF6ECCF7,
        darkColor: 0xFF254A5B,
      );

  static ColorInfo get blue => ColorInfo(
        label: LocaleStrings.common.colorBlue,
        color: 0xFF1E88E5,
        lightColor: 0xFF9EAEFA,
        darkColor: 0xFF252E5B,
      );

  static ColorInfo get purple => ColorInfo(
        label: LocaleStrings.common.colorPurple,
        color: 0xFF9C27B0,
        lightColor: 0xFFB281F8,
        darkColor: 0xFF3A255B,
      );

  static ColorInfo get pink => ColorInfo(
        label: LocaleStrings.common.colorPink,
        color: 0xFFE91E63,
        lightColor: 0xFFF881CD,
        darkColor: 0xFF5B2547,
      );
}

@immutable
class ColorInfo {
  final String label;
  final int color;
  final int? lightColor;
  final int? darkColor;

  const ColorInfo({
    required this.label,
    required this.color,
    this.lightColor,
    this.darkColor,
  });

  int dynamicColor(BuildContext context) {
    final Brightness brightness = context.theme.brightness;

    return brightness == Brightness.light
        ? lightColor ?? color
        : darkColor ?? color;
  }
}
