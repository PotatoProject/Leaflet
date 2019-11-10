import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/ui/list_label_divider.dart';
import 'package:potato_notes/ui/sync_inputfield.dart';
import 'package:provider/provider.dart';

class SyncManageRoute extends StatefulWidget {
  @override createState() => _SyncManageRouteState();
}

class _SyncManageRouteState extends State<SyncManageRoute> {
  bool showLoadingOverlay = false;
  AppLocalizations locales;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);
    locales = AppLocalizations.of(context);

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.only(top: 60),
              children: <Widget>[
                ListLabelDivider(
                  label: locales.syncManageRoute_account,
                ),
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text(locales.syncManageRoute_account_loggedInAs(appInfo.userName)),
                  subtitle: Text(appInfo.userEmail),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () async {
                          Response info = await get("https://potatosync.herokuapp.com/api/users/info",
                              headers: {"Authorization": appInfo.userToken});
                          
                          Map<dynamic, dynamic> body = json.decode(info.body);

                          if(body["status"]) {
                            Map<dynamic, dynamic> account = body["account"];

                            appInfo.userName = account["username"];
                            appInfo.userEmail = account["email"];
                            appInfo.userImage = account["image_url"];
                          }
                        },
                      ),
                      RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).scaffoldBackgroundColor,
                        child: Text(locales.syncManageRoute_account_logout),
                        onPressed: () {
                          appInfo.userEmail = "";
                          appInfo.userName = locales.syncManageRoute_account_guest;
                          appInfo.userToken = null;
                          appInfo.userImage = null;

                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ),
                ListTile(
                  leading: Icon(
                    Icons.ac_unit,
                    color: Colors.transparent,
                  ),
                  title: Text(locales.syncManageRoute_account_changeUsername),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) => UsernameDialog(context: context)
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.ac_unit,
                    color: Colors.transparent,
                  ),
                  title: Text(locales.syncManageRoute_account_changeImage),
                  onTap: () async {
                    setState(() => showLoadingOverlay = true);
                    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

                    if(image != null) {
                      List<int> imageBytes = await image.readAsBytes();

                      Response imageToImgur = await post("https://api.imgur.com/3/image", body: imageBytes,
                          headers: {"Authorization": "Client-ID f856a5e4fd5b2af"});
                      
                      String url = json.decode(imageToImgur.body)["data"]["link"];

                      Response uploadImage = await post("https://sync.potatoproject.co/api/users/manage/image",
                          body: "{\"image_url\": \"$url\"}", headers: {"Authorization": appInfo.userToken});
                      
                      Map<dynamic, dynamic> parsedBody = json.decode(uploadImage.body);

                      if(parsedBody["status"]) {
                        appInfo.userImage = url;
                      } else {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(Utils.parseErrorMessage(context, parsedBody["message"].toString())),
                        ));
                      }

                      setState(() => showLoadingOverlay = false);
                    }
                  },
                ),
                ListLabelDivider(
                  label: locales.syncManageRoute_sync,
                ),
                SwitchListTile(
                  secondary: Icon(Icons.sync),
                  title: Text(locales.syncManageRoute_sync_enableAutoSync),
                  value: appInfo.autoSync,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (value) {
                    appInfo.autoSync = value;
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.ac_unit,
                    color: Colors.transparent,
                  ),
                  enabled: appInfo.autoSync,
                  title: Text(locales.syncManageRoute_sync_autoSyncInterval),
                  trailing: DropdownButton(
                    onChanged: appInfo.autoSync ? (value) {
                      appInfo.autoSync = false;
                      appInfo.autoSyncTimeInterval = value;
                      Future.delayed(Duration(seconds: 1), () {
                        appInfo.autoSync = true;
                      });
                    } : null,
                    disabledHint: Text(appInfo.autoSyncTimeInterval.toString()),
                    value: appInfo.autoSyncTimeInterval,
                    items: [
                      DropdownMenuItem(
                        value: 2,
                        child: Text("2"),
                      ),
                      DropdownMenuItem(
                        value: 5,
                        child: Text("5"),
                      ),
                      DropdownMenuItem(
                        value: 10,
                        child: Text("10"),
                      ),
                      DropdownMenuItem(
                        value: 15,
                        child: Text("15"),
                      ),
                      DropdownMenuItem(
                        value: 30,
                        child: Text("30"),
                      ),
                      DropdownMenuItem(
                        value: 60,
                        child: Text("60"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 60,
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showLoadingOverlay,
              child: SizedBox.expand(
                child: AnimatedOpacity(
                  opacity: showLoadingOverlay ? 1 : 0,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black45,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsernameDialog extends StatefulWidget {
  final BuildContext context;
  
  UsernameDialog({@required this.context});

  @override createState() => _UsernameDialogState();
}

class _UsernameDialogState extends State<UsernameDialog> {
  FocusNode node = FocusNode();
  bool selected = false;
  bool error = false;
  bool firstRun = true;

  String message = "";
  String username = "";

  bool loading = false;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);
    final locales = AppLocalizations.of(context);
    
    if(firstRun) {
      controller.text = appInfo.userName;
      username = appInfo.userName;
      firstRun = false;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      contentPadding: EdgeInsets.only(top: 20),
      content: SyncInputField(
        title: "New username",
        controller: controller,
        sidePadding: 0,
        errorMessage: message,
        emptyHandler: error,
        selectHandler: selected,
        focusNode: node,
        onChanged: (text) => setState(() {
          username = text;

          if(username.length < 5) {
            error = true;
            message = "Username too short";
          } else if(error) error = false;
        }),
      ),
      actions: <Widget>[
        Visibility(
          visible: loading,
          child: CircularProgressIndicator(),
        ),
        FlatButton(
          textColor: Theme.of(context).accentColor,
          child: Text(locales.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        RaisedButton(
          color: Theme.of(context).accentColor,
          textColor: Theme.of(context).scaffoldBackgroundColor,
          child: Text(locales.confirm),
          disabledTextColor: Theme.of(context).scaffoldBackgroundColor,
          onPressed: (username == appInfo.userName || username.length < 5) ? null : () async {
            setState(() => loading = true);

            String body = "{\"email\": \"${appInfo.userEmail}\", \"username\": \"$username\"}";
            Map<String, String> headers = {
              "Authorization": appInfo.userToken
            };

            Response changeUser = await post("https://potatosync.herokuapp.com/api/users/manage/username",
                body: body, headers: headers);
            
            Map<dynamic, dynamic> responseBody = json.decode(changeUser.body);

            if(responseBody["status"]) {
              appInfo.userName = username;

              Navigator.pop(context);
            } else {
              if(responseBody["message"] == "OutOfBoundsError") {
                setState(() {
                  message = "Username is too long";
                  error = true;
                });
              } else {
                setState(() {
                  message = Utils.parseErrorMessage(context, responseBody["message"].toString());
                  error = true;
                });
              }
            }

            setState(() => loading = false);
          },
        )
      ],
    );
  }
}