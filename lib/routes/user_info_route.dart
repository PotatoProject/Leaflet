import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/note_helper.dart';
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
                                  image: appInfo.userImagePath == null
                                      ? null
                                      : DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                              File(appInfo.userImagePath)),
                                        ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(150)),
                                  color: appInfo.mainColor,
                                ),
                                child: appInfo.userImagePath == null
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
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(locales.chooseAction),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 0),
                                            leading: Icon(Icons.photo_library),
                                            title: Text(locales.userInfoRoute_avatar_change),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              File image =
                                                  await ImagePicker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (image != null)
                                                appInfo.userImagePath =
                                                    image.path;
                                            },
                                          ),
                                          ListTile(
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 0),
                                            leading: Icon(Icons.delete),
                                            title: Text(locales.userInfoRoute_avatar_remove),
                                            onTap: () async {
                                              appInfo.userImagePath = null;
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                          ),
                        )
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: userNameController,
                            onChanged: (value) => appInfo.userName = value,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "User"
                            ),
                          ),
                        ),
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
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}