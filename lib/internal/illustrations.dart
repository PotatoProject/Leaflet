import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Illustrations {
  BuildContext context;

  Illustrations(this.context);

  Future<Widget> noNotesIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if(isDark)
      return SvgPicture.asset("assets/no_notes_dark.svg");
    else return SvgPicture.asset("assets/no_notes_light.svg");
  }
}
