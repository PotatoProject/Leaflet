import 'package:flutter/material.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/constants.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
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
        ? title ??
            const Text(
              "leaflet",
              style: TextStyle(fontFamily: Constants.leafletLogoFontFamily),
            )
        : title;

    return AppBar(
      leading: _leading,
      titleSpacing: 0,
      title: _title,
      centerTitle: (context.theme.platform == TargetPlatform.iOS ||
              context.theme.platform == TargetPlatform.macOS) &&
          deviceInfo.uiSizeFactor < 3,
      actions: [
        Visibility(
          visible: state != null && AppInfo.supportsNotesApi,
          child: IconButton(
            padding: const EdgeInsets.all(16),
            icon: const AccountAvatar(),
            splashRadius: 28,
            tooltip: LocaleStrings.mainPage.account,
            onPressed: () {
              Utils.showModalBottomSheet(
                context: context,
                builder: (context) => AccountInfo(),
              );
            },
          ),
        ),
      ]..insertAll(0, extraActions),
    );
  }
}
