import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/badge_icon.dart';

class AccountAvatar extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final bool showBadgeOnSync;

  const AccountAvatar({
    this.size = 24,
    this.backgroundColor,
    this.showBadgeOnSync = true,
  });

  String? getAvatarUrl() {
    final user = pocketbase.authStore.model as UserModel;
    if (user.profile == null) {
      return null;
    }
    final profile = user.profile!;
    final String avatarFile = profile.getStringValue("avatar");
    if (avatarFile.isEmpty) {
      return null;
    }
    var url = pocketbase
        .buildUrl(
          "/api/files/${profile.collectionId}/${profile.id}/$avatarFile?thumb=${size}x${size}",
        )
        .toString();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final avatarUrl = getAvatarUrl();
        /* return ValueListenableBuilder<bool>(
          valueListenable: syncRoutine.syncing,
          builder: (context, syncing, _) { */
        return BadgeIcon(
          icon: CircleAvatar(
            radius: size / 2,
            backgroundColor: backgroundColor ?? Colors.transparent,
            foregroundImage: avatarUrl != null
                ? NetworkImage(
                    avatarUrl,
                    headers: {
                      "Authorization": "User ${pocketbase.authStore.token}"
                    },
                  )
                : null,
            child: Icon(
              Icons.person_outline,
              color: context.theme.iconTheme.color,
            ),
          ),
          size: size,
          /* badgeIcon: syncing && showBadgeOnSync
                  ? SpinningSyncIcon(spin: syncing)
                  : null,
              badgeSize: size / 2, */
        );
      },
    );
    /*   },
    ); */
  }
}
