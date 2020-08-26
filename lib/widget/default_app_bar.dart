import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/sync/sync_routine.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/login_page.dart';
import 'package:potato_notes/widget/account_info.dart';
import 'package:potato_notes/widget/notes_logo.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> extraActions;

  DefaultAppBar({
    this.extraActions = const [],
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(56.0);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Center(
        child: NotesLogo(
          height: 28,
        ),
      ),
      titleSpacing: 0,
      title: Text("PotatoNotes"),
      textTheme: Theme.of(context).textTheme,
      actions: [
        IconButton(
          icon: Icon(OMIcons.person),
          tooltip: LocaleStrings.mainPage.account,
          onPressed: () async {
            bool loggedIn = await SyncRoutine.checkLoginStatus();

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
      ]..addAll(extraActions),
    );
  }
}
