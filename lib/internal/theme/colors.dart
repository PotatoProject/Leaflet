import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class NoteColorPalette {
  final NoteColor empty;
  final NoteColor red;
  final NoteColor orange;
  final NoteColor yellow;
  final NoteColor green;
  final NoteColor cyan;
  final NoteColor lightBlue;
  final NoteColor blue;
  final NoteColor purple;
  final NoteColor pink;

  List<NoteColor> get colors => [
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
      ];

  const NoteColorPalette({
    required this.empty,
    required this.red,
    required this.orange,
    required this.yellow,
    required this.green,
    required this.cyan,
    required this.lightBlue,
    required this.blue,
    required this.purple,
    required this.pink,
  });

  NoteColorPalette.fromColors({
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
  }) : this(
          empty: NoteColor(empty.value, NoteColorType.empty),
          red: NoteColor(red.value, NoteColorType.red),
          orange: NoteColor(orange.value, NoteColorType.orange),
          yellow: NoteColor(yellow.value, NoteColorType.yellow),
          green: NoteColor(green.value, NoteColorType.green),
          cyan: NoteColor(cyan.value, NoteColorType.cyan),
          lightBlue: NoteColor(lightBlue.value, NoteColorType.lightBlue),
          blue: NoteColor(blue.value, NoteColorType.blue),
          purple: NoteColor(purple.value, NoteColorType.purple),
          pink: NoteColor(pink.value, NoteColorType.pink),
        );

  static const NoteColorPalette light = NoteColorPalette(
    empty: NoteColor(0x00000000, NoteColorType.empty),
    red: NoteColor(0xFFF88E86, NoteColorType.red),
    orange: NoteColor(0xFFF9B066, NoteColorType.orange),
    yellow: NoteColor(0xFFFFD166, NoteColorType.yellow),
    green: NoteColor(0xFF94CF96, NoteColorType.green),
    cyan: NoteColor(0xFF7DDDE9, NoteColorType.cyan),
    lightBlue: NoteColor(0xFF68CBF8, NoteColorType.lightBlue),
    blue: NoteColor(0xFF78B8EF, NoteColorType.blue),
    purple: NoteColor(0xFFC47DD0, NoteColorType.purple),
    pink: NoteColor(0xFFF278A1, NoteColorType.pink),
  );

  static const NoteColorPalette neutral = NoteColorPalette(
    empty: NoteColor(0x00000000, NoteColorType.empty),
    red: NoteColor(0xFFF44336, NoteColorType.red),
    orange: NoteColor(0xFFF57C00, NoteColorType.orange),
    yellow: NoteColor(0xFFFFB300, NoteColorType.yellow),
    green: NoteColor(0xFF4CAF50, NoteColorType.green),
    cyan: NoteColor(0xFF26C6DA, NoteColorType.cyan),
    lightBlue: NoteColor(0xFF03A9F4, NoteColorType.lightBlue),
    blue: NoteColor(0xFF1E88E5, NoteColorType.blue),
    purple: NoteColor(0xFF9C27B0, NoteColorType.purple),
    pink: NoteColor(0xFFE91E63, NoteColorType.pink),
  );

  static const NoteColorPalette dark = NoteColorPalette(
    empty: NoteColor(0x00000000, NoteColorType.empty),
    red: NoteColor(0xFF7A211B, NoteColorType.red),
    orange: NoteColor(0xFF7A3E00, NoteColorType.orange),
    yellow: NoteColor(0xFF805900, NoteColorType.yellow),
    green: NoteColor(0xFF265728, NoteColorType.green),
    cyan: NoteColor(0xFF13636D, NoteColorType.cyan),
    lightBlue: NoteColor(0xFF01547A, NoteColorType.lightBlue),
    blue: NoteColor(0xFF0F4472, NoteColorType.blue),
    purple: NoteColor(0xFF4E1358, NoteColorType.purple),
    pink: NoteColor(0xFF740F31, NoteColorType.pink),
  );

  factory NoteColorPalette.lerp(
    NoteColorPalette a,
    NoteColorPalette b,
    double t,
  ) {
    return NoteColorPalette.fromColors(
      empty: Color.lerp(a.empty, b.empty, t)!,
      red: Color.lerp(a.red, b.red, t)!,
      orange: Color.lerp(a.orange, b.orange, t)!,
      yellow: Color.lerp(a.yellow, b.yellow, t)!,
      green: Color.lerp(a.green, b.green, t)!,
      cyan: Color.lerp(a.cyan, b.cyan, t)!,
      lightBlue: Color.lerp(a.lightBlue, b.lightBlue, t)!,
      blue: Color.lerp(a.blue, b.blue, t)!,
      purple: Color.lerp(a.purple, b.purple, t)!,
      pink: Color.lerp(a.pink, b.pink, t)!,
    );
  }

  @override
  bool operator ==(Object? other) {
    if (other is NoteColorPalette) {
      return listEquals(colors, other.colors);
    }
    return false;
  }

  @override
  int get hashCode => colors.hashCode;

  NoteColorPalette copyWith({
    NoteColor? empty,
    NoteColor? red,
    NoteColor? orange,
    NoteColor? yellow,
    NoteColor? green,
    NoteColor? cyan,
    NoteColor? lightBlue,
    NoteColor? blue,
    NoteColor? purple,
    NoteColor? pink,
  }) {
    return NoteColorPalette(
      empty: empty ?? this.empty,
      red: red ?? this.red,
      orange: orange ?? this.orange,
      yellow: yellow ?? this.yellow,
      green: green ?? this.green,
      cyan: cyan ?? this.cyan,
      lightBlue: lightBlue ?? this.lightBlue,
      blue: blue ?? this.blue,
      purple: purple ?? this.purple,
      pink: pink ?? this.pink,
    );
  }

  NoteColorPalette copyWithColors({
    Color? empty,
    Color? red,
    Color? orange,
    Color? yellow,
    Color? green,
    Color? cyan,
    Color? lightBlue,
    Color? blue,
    Color? purple,
    Color? pink,
  }) {
    return NoteColorPalette.fromColors(
      empty: empty ?? this.empty,
      red: red ?? this.red,
      orange: orange ?? this.orange,
      yellow: yellow ?? this.yellow,
      green: green ?? this.green,
      cyan: cyan ?? this.cyan,
      lightBlue: lightBlue ?? this.lightBlue,
      blue: blue ?? this.blue,
      purple: purple ?? this.purple,
      pink: pink ?? this.pink,
    );
  }

  NoteColorPalette harmonize(Color color) {
    return NoteColorPalette.fromColors(
      empty: _harmonizeColor(empty, color),
      red: _harmonizeColor(red, color),
      orange: _harmonizeColor(orange, color),
      yellow: _harmonizeColor(yellow, color),
      green: _harmonizeColor(green, color),
      cyan: _harmonizeColor(cyan, color),
      lightBlue: _harmonizeColor(lightBlue, color),
      blue: _harmonizeColor(blue, color),
      purple: _harmonizeColor(purple, color),
      pink: _harmonizeColor(pink, color),
    );
  }

  Color _harmonizeColor(Color from, Color to) {
    return Color(Blend.harmonize(from.value, to.value));
  }
}

class NoteColor extends Color {
  final NoteColorType type;

  const NoteColor(
    int value,
    this.type,
  ) : super(value);

  @override
  bool operator ==(Object? other) {
    if (other is NoteColor) {
      return value == other.value && type == other.type;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(value, type);
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

@immutable
class IllustrationPalette {
  final Color contrast;
  final Color invertedContrast;
  final Color base;

  const IllustrationPalette({
    required this.contrast,
    required this.invertedContrast,
    required this.base,
  });

  static const IllustrationPalette light = IllustrationPalette(
    invertedContrast: Color(0xFFD1D1D1),
    contrast: Color(0xFF6B6B6B),
    base: Color(0xFF979797),
  );

  static const IllustrationPalette dark = IllustrationPalette(
    contrast: Color(0xFFD1D1D1),
    invertedContrast: Color(0xFF6B6B6B),
    base: Color(0xFF979797),
  );

  factory IllustrationPalette.lerp(
    IllustrationPalette a,
    IllustrationPalette b,
    double t,
  ) {
    return IllustrationPalette(
      contrast: Color.lerp(a.contrast, b.contrast, t)!,
      invertedContrast: Color.lerp(a.invertedContrast, b.invertedContrast, t)!,
      base: Color.lerp(a.base, b.base, t)!,
    );
  }

  @override
  bool operator ==(Object? other) {
    if (other is IllustrationPalette) {
      return contrast.value == other.contrast.value &&
          invertedContrast.value == other.invertedContrast.value &&
          base.value == other.base.value;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(contrast, invertedContrast, base);
}
