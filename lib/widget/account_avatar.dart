import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:potato_notes/internal/custom_icons.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/sync_routine.dart';
import 'package:potato_notes/internal/utils.dart';
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

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final String? avatarUrl = prefs.avatarUrl;

        return ValueListenableBuilder<bool>(
          valueListenable: SyncRoutine.instance.syncing,
          builder: (context, syncing, _) {
            return BadgeIcon(
              icon: CircleAvatar(
                radius: size / 2,
                backgroundColor: backgroundColor ?? Colors.transparent,
                foregroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: Icon(
                  Icons.person_outline,
                  color: context.theme.iconTheme.color,
                ),
              ),
              size: size,
              badgeIcon: syncing && showBadgeOnSync
                  ? SpinningSyncIcon(spin: syncing)
                  : null,
              badgeSize: size / 2,
            );
          },
        );
      },
    );
  }
}
