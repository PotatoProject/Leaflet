import 'package:flutter/material.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/base_page.dart';
import 'package:potato_notes/routes/login_page.dart';
import 'package:potato_notes/widget/account_info.dart';
import 'package:potato_notes/widget/notes_logo.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> extraActions;
  final Widget title;

  const DefaultAppBar({
    this.extraActions = const [],
    this.title,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(56.0);
  }

  @override
  Widget build(BuildContext context) {
    final state = BasePage.of(context);
    final _leading = state != null
        ? Center(
            child: IconLogo(
              height: 28,
            ),
          )
        : null;
    final _title = state != null
        ? Text(
            "leaflet",
            style: TextStyle(fontFamily: "ValeraRound"),
          )
        : title ?? null;

    return AppBar(
      leading: _leading,
      titleSpacing: 0,
      title: _title,
      textTheme: Theme.of(context).textTheme,
      actions: [
        Visibility(
          visible: state != null,
          child: IconButton(
            padding: EdgeInsets.all(16),
            icon: Icon(Icons.person_outlined),
            splashRadius: 28,
            tooltip: LocaleStrings.mainPage.account,
            onPressed: () async {
              bool loggedIn = prefs.accessToken != null;

              if (loggedIn) {
                Utils.showNotesModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => AccountInfo(),
                );
              } else {
                Utils.showSecondaryRoute(
                  context,
                  LoginPage(),
                );
              }
            },
          ),
        ),
      ]..insertAll(0, extraActions),
    );
  }
}
