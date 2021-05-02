import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NoteColorPalette {
  final List<NoteColor> colors;

  NoteColor get empty =>
      colors.firstWhere((e) => e.type == NoteColorType.empty);
  NoteColor get red => colors.firstWhere((e) => e.type == NoteColorType.red);
  NoteColor get orange =>
      colors.firstWhere((e) => e.type == NoteColorType.orange);
  NoteColor get yellow =>
      colors.firstWhere((e) => e.type == NoteColorType.yellow);
  NoteColor get green =>
      colors.firstWhere((e) => e.type == NoteColorType.green);
  NoteColor get cyan => colors.firstWhere((e) => e.type == NoteColorType.cyan);
  NoteColor get lightBlue =>
      colors.firstWhere((e) => e.type == NoteColorType.lightBlue);
  NoteColor get blue => colors.firstWhere((e) => e.type == NoteColorType.blue);
  NoteColor get purple =>
      colors.firstWhere((e) => e.type == NoteColorType.purple);
  NoteColor get pink => colors.firstWhere((e) => e.type == NoteColorType.pink);

  NoteColorPalette({
    required Color empty,
    required Color red,
    required Color orange,
    required Color yellow,
    required Color green,
    required Color cyan,
    required Color lightBlue,
    required Color blue,
    required Color purple,
    required Color pink,
  }) : colors = [
          NoteColor(type: NoteColorType.empty, color: empty),
          NoteColor(type: NoteColorType.red, color: red),
          NoteColor(type: NoteColorType.orange, color: orange),
          NoteColor(type: NoteColorType.yellow, color: yellow),
          NoteColor(type: NoteColorType.green, color: green),
          NoteColor(type: NoteColorType.cyan, color: cyan),
          NoteColor(type: NoteColorType.lightBlue, color: lightBlue),
          NoteColor(type: NoteColorType.blue, color: blue),
          NoteColor(type: NoteColorType.purple, color: purple),
          NoteColor(type: NoteColorType.pink, color: pink),
        ];

  NoteColorPalette.light()
      : this(
          empty: const Color(0x00000000),
          red: const Color(0xFFF7786E),
          orange: const Color(0xFFF5AF51),
          yellow: const Color(0xFFF5E551),
          green: const Color(0xFF51F558),
          cyan: const Color(0xFF51F5E0),
          lightBlue: const Color(0xFF6ECCF7),
          blue: const Color(0xFF9EAEFA),
          purple: const Color(0xFFB281F8),
          pink: const Color(0xFFF881CD),
        );

  NoteColorPalette.neutral()
      : this(
          empty: const Color(0x00000000),
          red: const Color(0xFFF44336),
          orange: const Color(0xFFF57C00),
          yellow: const Color(0xFFFFB300),
          green: const Color(0xFF4CAF50),
          cyan: const Color(0xFF00ACC1),
          lightBlue: const Color(0xFF03A9F4),
          blue: const Color(0xFF1E88E5),
          purple: const Color(0xFF9C27B0),
          pink: const Color(0xFFE91E63),
        );

  NoteColorPalette.dark()
      : this(
          empty: const Color(0x00000000),
          red: const Color(0xFF5B2925),
          orange: const Color(0xFF5B4325),
          yellow: const Color(0xFF5B5525),
          green: const Color(0xFF255B27),
          cyan: const Color(0xFF255B53),
          lightBlue: const Color(0xFF254A5B),
          blue: const Color(0xFF252E5B),
          purple: const Color(0xFF3A255B),
          pink: const Color(0xFF5B2547),
        );

  @override
  bool operator ==(Object? other) {
    if (other is NoteColorPalette) {
      return listEquals(colors, other.colors);
    }
    return false;
  }

  @override
  int get hashCode => colors.hashCode;
}

class NoteColor {
  final Color color;
  final NoteColorType type;

  const NoteColor({
    required this.color,
    required this.type,
  });

  @override
  bool operator ==(Object? other) {
    if (other is NoteColor) {
      return color.value == other.color.value && type == other.type;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(color, type);
}

enum NoteColorType {
  empty,
  red,
  orange,
  yellow,
  green,
  cyan,
  lightBlue,
  blue,
  purple,
  pink,
}
