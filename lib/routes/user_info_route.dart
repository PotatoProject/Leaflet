import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/ui/custom_icons_icons.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';

class UserInfoDialog extends StatefulWidget {
  final void Function(bool) onSortSwitchChange;
  final void Function() onSettingsTileClick;
  final void Function() onPotatoSyncTileClick;

  UserInfoDialog({
    @required this.onSortSwitchChange,
    @required this.onSettingsTileClick,
    @required this.onPotatoSyncTileClick,
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

    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Color(0x8A000000),
          ),
        )),
        Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 70,
                          height: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: appInfo.userImage == null
                                ? Icon(
                                    Icons.person_outline,
                                    size: 36,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: appInfo.userImage,
                                    fadeInDuration: Duration(milliseconds: 0),
                                    fadeOutDuration: Duration(milliseconds: 0),
                                    placeholder: (context, url) {
                                      return ControlledAnimation(
                                        playback: Playback.MIRROR,
                                        tween:
                                            Tween<double>(begin: 0.2, end: 1),
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
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  appInfo.userName,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Visibility(
                                  visible: appInfo.userEmail != "",
                                  child: Text(
                                    appInfo.userEmail,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .title
                                          .color
                                          .withAlpha(180),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ])),
                    ],
                  ),
                  Divider(
                    height: 1,
                    indent: 6,
                    endIndent: 6,
                    thickness: 1,
                  ),
                  SwitchListTile(
                    secondary: Icon(Icons.sort),
                    title: Text(locales.userInfoRoute_sortByDate),
                    value: appInfo.sortMode == SortMode.DATE,
                    onChanged: widget.onSortSwitchChange,
                    activeColor: appInfo.mainColor,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(locales.settingsRoute_title),
                    onTap: widget.onSettingsTileClick,
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                      leading: Icon(
                        CustomIcons.potato_sync,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text("PotatoSync"),
                      onTap: widget.onPotatoSyncTileClick),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
