import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/internal/custom_icons.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';
import 'package:potato_notes/internal/sync/image/files_controller.dart';
import 'package:potato_notes/internal/sync/sync_routine.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/login_page.dart';
import 'package:potato_notes/widget/account_avatar.dart';

class AccountInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SyncRoutine.instance.syncing,
      builder: (context, syncing, _) {
        final bool loggedIn = prefs.accessToken != null;
        final String lastSync = prefs.lastUpdated != 0
            ? DateFormat('EEE dd MMM y, HH:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(prefs.lastUpdated))
            : "never";
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  AccountAvatar(
                    size: 36,
                    backgroundColor:
                        context.theme.iconTheme.color.withOpacity(0.1),
                    showBadgeOnSync: false,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prefs.username ?? "Guest",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        prefs.email ?? "Not logged in",
                        style: TextStyle(
                          fontSize: 14,
                          color: context.theme.iconTheme.color.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (loggedIn)
              FutureBuilder(
                future: FilesController.getStats(),
                builder: (context, snapshot) {
                  return ListTile(
                    leading: Icon(Icons.image_outlined),
                    title: Text("Image upload capacity"),
                    subtitle: LinearProgressIndicator(
                      value: snapshot.hasData
                          ? snapshot.data.used / snapshot.data.limit
                          : null,
                      backgroundColor:
                          context.theme.accentColor.withOpacity(0.2),
                    ),
                    trailing: Text(
                      snapshot.hasData
                          ? LocaleStrings.common
                              .xOfY(snapshot.data.used, snapshot.data.limit)
                          : '-',
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 24),
                  );
                },
              ),
            if (loggedIn)
              ListTile(
                leading: SpinningSyncIcon(spin: syncing),
                title: Text("Sync notes"),
                subtitle: AnimatedSwitcher(
                  child: Text(
                    syncing ? "Syncing..." : "Last sync: $lastSync",
                    key: ValueKey(syncing),
                  ),
                  duration: Duration(milliseconds: 150),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  layoutBuilder: (currentChild, previousChildren) => Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      ...previousChildren,
                      currentChild,
                    ],
                  ),
                ),
                onTap: () async {
                  SyncRoutine.instance.sync();
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
              ),
            Divider(),
            if (loggedIn)
              ListTile(
                leading: Icon(MdiIcons.accountSettingsOutline),
                title: Text("Manage account"),
                onTap: () async {
                  Utils.launchUrl("${prefs.apiUrl}/account");
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
              ),
            if (loggedIn)
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () async {
                  context.pop();
                  await AccountController.logout();
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
              ),
            if (!loggedIn)
              ListTile(
                leading: Icon(Icons.login),
                title: Text("Login"),
                onTap: () async {
                  context.pop();
                  await Utils.showSecondaryRoute(context, LoginPage());
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
              ),
            SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
