import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/base_page.dart';
import 'package:potato_notes/routes/login_page.dart';
import 'package:potato_notes/widget/account_info.dart';
import 'package:potato_notes/widget/notes_logo.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> extraActions;
  final String title;

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
            child: NotesLogo(
              height: 28,
            ),
          )
        : null;
    final _title = state != null ? "PotatoNotes" : title ?? "";

    return AppBar(
      leading: _leading,
      titleSpacing: 0,
      title: Text(_title),
      textTheme: Theme.of(context).textTheme,
      actions: [
        Visibility(
          visible: state != null,
          child: IconButton(
            icon: Icon(OMIcons.person),
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
      ]..addAll(extraActions),
    );
  }
}
