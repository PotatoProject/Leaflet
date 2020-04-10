import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Illustrations {
  BuildContext context;

  Illustrations(this.context);

  Future<Widget> noNotesIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return SvgPicture.asset("assets/no_notes_dark.svg");
    else
      return SvgPicture.asset("assets/no_notes_light.svg");
  }

  Future<Widget> emptyArchiveIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return SvgPicture.asset("assets/empty_archive_dark.svg");
    else
      return SvgPicture.asset("assets/empty_archive_light.svg");
  }

  Future<Widget> emptyTrashIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return SvgPicture.asset("assets/empty_trash_dark.svg");
    else
      return SvgPicture.asset("assets/empty_trash_light.svg");
  }
}
