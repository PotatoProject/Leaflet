import 'package:flutter/material.dart';
import 'package:monet/monet.dart';
import 'package:potato_notes/internal/providers.dart';

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
}
