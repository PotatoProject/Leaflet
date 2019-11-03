import 'package:flutter/material.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/routes/sync_login_route.dart';
import 'package:potato_notes/routes/sync_manage_route.dart';
import 'package:potato_notes/ui/custom_icons_icons.dart';
import 'package:provider/provider.dart';

class UserInfoDialog extends StatefulWidget {
  final void Function(bool) onSortSwitchChange;
  final void Function() onSettingsTileClick;

  UserInfoDialog({@required this.onSortSwitchChange, @required this.onSettingsTileClick});

  @override createState() => _UserInfoDialogState();
}

class _UserInfoDialogState extends State<UserInfoDialog> {
  AppInfoProvider appInfo;
  AppLocalizations locales;

  TextEditingController userNameController;

  bool firstRun = true;
  
  @override
  Widget build(BuildContext context) {
    if(firstRun) {
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
          )
        ),
        Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                        tag: "userimage",
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  image: appInfo.userImage == null
                                      ? null
                                      : DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              appInfo.userImage),
                                        ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(150)),
                                  color: appInfo.mainColor,
                                ),
                                child: appInfo.userImage == null
                                    ? Center(
                                        child: Icon(
                                          Icons.account_circle,
                                          size: 65,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                          ),
                        )
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
                                  color: Theme.of(context).textTheme.title.color.withAlpha(180),
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ]
                        )
                      ),
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
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => appInfo.userToken != null ? SyncManageRoute() : SyncLoginRoute()
                    )),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}