import 'package:flutter/material.dart';

class Illustrations {
  Illustrations();

  Future<Widget> noNotesIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset("assets/no_notes_dark.png");
    else
      return Image.asset("assets/no_notes_light.png");
  }

  Future<Widget> emptyArchiveIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset("assets/empty_archive_dark.png");
    else
      return Image.asset("assets/empty_archive_light.png");
  }

  Future<Widget> emptyTrashIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset("assets/empty_trash_dark.png");
    else
      return Image.asset("assets/empty_trash_light.png");
  }

  Future<Widget> noFavouritesIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset("assets/no_favourites_dark.png");
    else
      return Image.asset("assets/no_favourites_light.png");
  }

  Future<Widget> nothingFoundIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset("assets/nothing_found_dark.png");
    else
      return Image.asset("assets/nothing_found_light.png");
  }

  Future<Widget> typeToSearchIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset("assets/type_to_search_dark.png");
    else
      return Image.asset("assets/type_to_search_light.png");
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
