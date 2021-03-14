import 'package:flutter/material.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/widget/account_avatar.dart';
import 'package:potato_notes/widget/account_info.dart';
import 'package:potato_notes/widget/illustrations.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> extraActions;
  final Widget? title;

  const DefaultAppBar({
    this.extraActions = const [],
    this.title,
  });

  @override
  Size get preferredSize {
    return const Size.fromHeight(56.0);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.basePage;
    final Widget? _leading = state != null
        ? const Center(
            child: Illustration.leaflet(
              height: 28,
            ),
          )
        : null;
    final Widget? _title = state != null
        ? const Text(
            "leaflet",
            style: TextStyle(fontFamily: "ValeraRound"),
          )
        : title;

    return Padding(
      padding: EdgeInsets.only(
        left: context.viewPadding.left,
        right: context.viewPadding.right,
      ),
      child: AppBar(
        leading: _leading,
        titleSpacing: 0,
        title: _title,
        textTheme: context.theme.textTheme,
        centerTitle: false,
        actions: [
          Visibility(
            visible: state != null,
            child: IconButton(
              padding: const EdgeInsets.all(16),
              icon: const AccountAvatar(),
              splashRadius: 28,
              tooltip: LocaleStrings.mainPage.account,
              onPressed: () {
                Utils.showNotesModalBottomSheet(
                  context: context,
                  builder: (context) => AccountInfo(),
                );
              },
            ),
          ),
        ]..insertAll(0, extraActions),
      ),
    );
  }
}
