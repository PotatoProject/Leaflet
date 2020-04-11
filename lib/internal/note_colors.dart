import 'package:flutter/material.dart';

class NoteColors {
  static List<Map<String, dynamic>> colorList(BuildContext context) => [
        NoteColors.none(context),
        NoteColors.red(context),
        NoteColors.orange(context),
        NoteColors.yellow(context),
        NoteColors.green(context),
        NoteColors.cyan(context),
        NoteColors.lightBlue(context),
        NoteColors.blue(context),
        NoteColors.purple(context),
        NoteColors.pink(context),
      ];

  static Map<String, dynamic> none(BuildContext context) {
    return {
      "label": "None",
      "hex": Theme.of(context).cardColor.value,
    };
  }

  static Map<String, dynamic> red(BuildContext context) {
    return {
      "label": "Red",
      "hex": Theme.of(context).brightness == Brightness.light
          ? 0xFFF99B94
          : 0xFF5B2925,
    };
  }

  static Map<String, dynamic> orange(BuildContext context) {
    return {
      "label": "Orange",
      "hex": Theme.of(context).brightness == Brightness.light
          ? 0xFFF9CE94
          : 0xFF5B4325,
    };
  }

  static Map<String, dynamic> yellow(BuildContext context) {
    return {
      "label": "Yellow",
      "hex": Theme.of(context).brightness == Brightness.light
          ? 0xFFF9EF94
          : 0xFF5B5525,
    };
  }

  static Map<String, dynamic> green(BuildContext context) {
    return {
      "label": "Green",
      "hex": Theme.of(context).brightness == Brightness.light
          ? 0xFF94F998
          : 0xFF255B27,
    };
  }

  static Map<String, dynamic> cyan(BuildContext context) {
    return {
      "label": "Cyan",
      "hex": Theme.of(context).brightness == Brightness.light
          ? 0xFF94F9EC
          : 0xFF255B53,
    };
  }

  static Map<String, dynamic> lightBlue(BuildContext context) {
    return {
      "label": "Light Blue",
      "hex": Theme.of(context).brightness == Brightness.light
          ? 0xFF94D9F9
          : 0xFF254A5B,
    };
  }

  static Map<String, dynamic> blue(BuildContext context) {
    return {
      "label": "Blue",
      "hex": Theme.of(context).brightness == Brightness.light
          ? 0xFF94A5F9
          : 0xFF252E5B,
    };
  }

  static Map<String, dynamic> purple(BuildContext context) {
    return {
      "label": "Purple",
      "hex": Theme.of(context).brightness == Brightness.light
          ? 0xFFBD94F9
          : 0xFF3A255B,
    };
  }

  static Map<String, dynamic> pink(BuildContext context) {
    return {
      "label": "Magenta",
      "hex": Theme.of(context).brightness == Brightness.light
          ? 0xFFF994D4
          : 0xFF5B2547,
    };
  }
}
