import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potato_notes/internal/custom_icons.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/controller.dart';
import 'package:potato_notes/internal/sync/image/files_controller.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/login_page.dart';
import 'package:potato_notes/widget/account_avatar.dart';

class AccountInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: syncRoutine.syncing,
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  AccountAvatar(
                    size: 36,
                    backgroundColor:
                        context.theme.iconTheme.color!.withOpacity(0.1),
                    showBadgeOnSync: false,
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prefs.username ?? "Guest",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        prefs.email ?? "Not logged in",
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              context.theme.iconTheme.color!.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (loggedIn)
              FutureBuilder<FilesApiStats>(
                future: Controller.files.getStats(),
                builder: (context, snapshot) {
                  return ListTile(
                    leading: const Icon(Icons.image_outlined),
                    title: const Text("Image upload capacity"),
                    subtitle: LinearProgressIndicator(
                      value: snapshot.hasData
                          ? snapshot.data!.used / snapshot.data!.limit
                          : null,
                      backgroundColor:
                          context.theme.accentColor.withOpacity(0.2),
                    ),
                    trailing: Text(
                      snapshot.hasData
                          ? LocaleStrings.common
                              .xOfY(snapshot.data!.used, snapshot.data!.limit)
                          : '-',
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  );
                },
              ),
            if (loggedIn)
              ListTile(
                leading: SpinningSyncIcon(spin: syncing),
                title: const Text("Sync notes"),
                subtitle: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  layoutBuilder: (currentChild, previousChildren) => Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      ...previousChildren,
                      currentChild ?? const SizedBox(),
                    ],
                  ),
                  child: Text(
                    syncing ? "Syncing..." : "Last sync: $lastSync",
                    key: ValueKey(syncing),
                  ),
                ),
                onTap: () async {
                  syncRoutine.sync();
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            const Divider(),
            if (loggedIn)
              ListTile(
                leading: const Icon(Icons.manage_accounts_outlined),
                title: const Text("Manage account"),
                onTap: () async {
                  Utils.launchUrl("${prefs.apiUrl}/account");
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            if (loggedIn)
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () async {
                  context.pop();
                  await Controller.account.logout();
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            if (!loggedIn)
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text("Login"),
                onTap: () async {
                  context.pop();
                  await Utils.showSecondaryRoute(context, LoginPage());
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
