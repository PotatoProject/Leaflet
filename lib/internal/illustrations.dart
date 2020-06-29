import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Illustrations {
  Illustrations();

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

  Future<Widget> noFavouritesIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return SvgPicture.asset("assets/no_favourites_dark.svg");
    else
      return SvgPicture.asset("assets/no_favourites_light.svg");
  }

  Future<Widget> nothingFoundIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return SvgPicture.asset("assets/nothing_found_dark.svg");
    else
      return SvgPicture.asset("assets/nothing_found_light.svg");
  }

  Future<Widget> typeToSearchIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return SvgPicture.asset("assets/type_to_search_dark.svg");
    else
      return SvgPicture.asset("assets/type_to_search_light.svg");
  }

  static Widget quickIllustration(
      BuildContext context, Widget illustration, String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 148,
            child: Center(
              child: illustration,
            ),
          ),
          SizedBox(height: 24),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).iconTheme.color,
            ),
          )
        ],
      ),
    );
  }
}
