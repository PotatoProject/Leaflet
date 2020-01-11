import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/ui/custom_icons_icons.dart';
import 'package:potato_notes/ui/user_info_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';

class UserInfoDialog extends StatefulWidget {
  final Color backgroundColor;
  final void Function() onSettingsTileClick;
  final void Function() onPotatoSyncTileClick;
  final List<Widget> extraItems;

  UserInfoDialog({
    this.backgroundColor,
    @required this.onSettingsTileClick,
    @required this.onPotatoSyncTileClick,
    this.extraItems,
  });

  @override
  createState() => _UserInfoDialogState();
}

class _UserInfoDialogState extends State<UserInfoDialog> {
  AppInfoProvider appInfo;
  AppLocalizations locales;

  TextEditingController userNameController;

  bool firstRun = true;

  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      appInfo = Provider.of<AppInfoProvider>(context);
      locales = AppLocalizations.of(context);

      userNameController = TextEditingController(text: appInfo.userName);

      firstRun = false;
    }

    return Material(
      color: widget.backgroundColor ?? Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          UserInfoListTile(
            height: 80,
            icon: appInfo.userImage == null
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                        child: Icon(
                      OMIcons.person,
                      color: Theme.of(context).iconTheme.color.withOpacity(0.7),
                    )),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: CachedNetworkImage(
                      imageUrl: appInfo.userImage,
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      placeholder: (context, url) {
                        return ControlledAnimation(
                          playback: Playback.MIRROR,
                          tween: Tween<double>(begin: 0.2, end: 1),
                          duration: Duration(milliseconds: 400),
                          builder: (context, animation) {
                            return Opacity(
                              opacity: animation,
                              child: Icon(Icons.image),
                            );
                          },
                        );
                      },
                    ),
                  ),
            text: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  appInfo.userName,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                Visibility(
                  visible: appInfo.userEmail != "",
                  child: Text(
                    appInfo.userEmail,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
          Column(
            children: widget.extraItems ?? [],
          ),
          Divider(
            height: 1,
          ),
          UserInfoListTile(
            icon: Icon(
              OMIcons.settings,
              color: Theme.of(context).iconTheme.color.withOpacity(0.7),
            ),
            text: Text(
              locales.settingsRoute_title,
              style: TextStyle(fontSize: 16),
            ),
            onTap: widget.onSettingsTileClick,
          ),
          UserInfoListTile(
            icon: Icon(
              CustomIcons.potato_sync,
              color: Theme.of(context).iconTheme.color.withOpacity(0.7),
            ),
            text: Text(
              "PotatoSync",
              style: TextStyle(fontSize: 16),
            ),
            onTap: widget.onPotatoSyncTileClick,
          ),
        ],
      ),
    );
  }
}
