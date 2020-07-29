import 'package:flutter/material.dart';

class Illustrations {
  Illustrations();

  Future<Widget> noNotesIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset(
        "assets/images/no_notes_dark.png",
        scale: 2,
      );
    else
      return Image.asset(
        "assets/images/no_notes_light.png",
        scale: 2,
      );
  }

  Future<Widget> emptyArchiveIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset(
        "assets/images/empty_archive_dark.png",
        scale: 2,
      );
    else
      return Image.asset(
        "assets/images/empty_archive_light.png",
        scale: 2,
      );
  }

  Future<Widget> emptyTrashIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset(
        "assets/images/empty_trash_dark.png",
        scale: 2,
      );
    else
      return Image.asset(
        "assets/images/empty_trash_light.png",
        scale: 2,
      );
  }

  Future<Widget> noFavouritesIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset(
        "assets/images/no_favourites_dark.png",
        scale: 2,
      );
    else
      return Image.asset(
        "assets/images/no_favourites_light.png",
        scale: 2,
      );
  }

  Future<Widget> nothingFoundIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset(
        "assets/images/nothing_found_dark.png",
        scale: 2,
      );
    else
      return Image.asset(
        "assets/images/nothing_found_light.png",
        scale: 2,
      );
  }

  Future<Widget> typeToSearchIllustration(Brightness themeMode) async {
    bool isDark = themeMode == Brightness.dark;

    if (isDark)
      return Image.asset(
        "assets/images/type_to_search_dark.png",
        scale: 2,
      );
    else
      return Image.asset(
        "assets/images/type_to_search_light.png",
        scale: 2,
      );
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
