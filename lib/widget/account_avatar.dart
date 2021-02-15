import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:potato_notes/internal/providers.dart';

class AccountAvatar extends StatelessWidget {
  final double size;
  final Color backgroundColor;

  AccountAvatar({
    this.size = 24,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final String avatarUrl = prefs.avatarUrl;

        return CircleAvatar(
          radius: size / 2,
          backgroundColor: backgroundColor ?? Colors.transparent,
          child: Icon(
            Icons.person_outline,
            color: Theme.of(context).iconTheme.color,
          ),
          foregroundImage: avatarUrl != null
              ? CachedNetworkImageProvider(
                  avatarUrl,
                  cacheKey: prefs.avatarUrlAsKey,
                )
              : null,
        );
      },
    );
  }
}
