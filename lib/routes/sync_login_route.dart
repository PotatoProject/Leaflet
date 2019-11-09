import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/routes/sync_register_route.dart';
import 'package:potato_notes/ui/custom_icons_icons.dart';
import 'package:potato_notes/ui/sync_inputfield.dart';
import 'package:provider/provider.dart';

class SyncLoginRoute extends StatefulWidget {
  @override createState() => _SyncLoginRouteState();
}

class _SyncLoginRouteState extends State<SyncLoginRoute> {

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  String email = "";
  String password = "";
  bool showPassword = false;

  bool emailSelected = false;
  bool passwordSelected = false;

  bool emailEmpty = false;
  bool passwordEmpty = false;

  bool showLoadingOverlay = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    emailNode.addListener(() => setState(() => emailSelected = !emailSelected));
    passwordNode.addListener(() => setState(() => passwordSelected = !passwordSelected));
  }

  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.only(top: 60),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 60 - MediaQuery.of(context).padding.top,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  CustomIcons.potato_sync,
                                  size: 56,
                                  color: Theme.of(context).accentColor,
                                ),
                                VerticalDivider(
                                  width: 20,
                                  color: Colors.transparent,
                                ),
                                Text(
                                  "PotatoSync",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                          ),
                          SyncInputField(
                            title: "Email or username",
                            errorMessage: "This field can't be empty",
                            selectHandler: emailSelected,
                            emptyHandler: emailEmpty,
                            focusNode: emailNode,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (text) {
                              email = text;
                              if(emailEmpty) setState(() => emailEmpty = false);
                            },
                          ),
                          Divider(
                            height: 20,
                            color: Colors.transparent,
                          ),
                          SyncInputField(
                            title: "Password",
                            errorMessage: "Password can't be empty",
                            selectHandler: passwordSelected,
                            emptyHandler: passwordEmpty,
                            focusNode: passwordNode,
                            onChanged: (text) {
                              password = text;
                              if(passwordEmpty) setState(() => passwordEmpty = false);
                            },
                            isPassword: true,
                            showPassword: showPassword,
                            trailing: IconButton(
                              color: showPassword ? Theme.of(context).iconTheme.color : Theme.of(context).disabledColor,
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: () {
                                setState(() => showPassword = !showPassword);
                              },
                            ),
                          ),
                          Divider(
                            height: 40,
                            color: Colors.transparent,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.5,
                                      )
                                    ),
                                    child: Text("Register"),
                                    textColor: Theme.of(context).accentColor,
                                    onPressed: () async {
                                      bool result = await Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => SyncRegisterRoute()
                                      ));

                                      if(result != null && result == true)
                                          scaffoldKey.currentState.showSnackBar(SnackBar(
                                            content: Text("Registration successful"),
                                          ));
                                    }
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.transparent,
                                ),
                                Expanded(
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    color: Theme.of(context).accentColor,
                                    textColor: Theme.of(context).scaffoldBackgroundColor,
                                    child: Text("Login"),
                                    onPressed: () async {
                                      if(email.isNotEmpty && password.isNotEmpty) {
                                        setState(() => showLoadingOverlay = true);

                                        bool useEmail = false;

                                        if(email.contains(RegExp(".*\..*@.*\..*", dotAll: true))) {
                                          useEmail = true;
                                        }

                                        String body = "";

                                        if(useEmail) {
                                          body = "{\"email\": \"$email\", \"password\": \"$password\"}";
                                        } else {
                                          body = "{\"username\": \"$email\", \"password\": \"$password\"}";
                                        }

                                        Response login = await post("https://sync.potatoproject.co/api/users/login", body: body);

                                        Map<dynamic, dynamic> responseBody = json.decode(login.body);

                                        if(responseBody["status"]) {
                                          appInfo.userName = responseBody["account"]["username"];
                                          appInfo.userEmail = responseBody["account"]["email"];
                                          appInfo.userImage = responseBody["account"]["image_url"] == "" ?
                                              null :
                                              responseBody["account"]["image_url"];

                                          appInfo.userToken = responseBody["account"]["token"];

                                          Response noteList = await get("https://sync.potatoproject.co/api/notes/list",
                                              headers: {"Authorization": appInfo.userToken});
                                          
                                          Map<dynamic, dynamic> body = json.decode(noteList.body);

                                          var result;
                                          List<Note> list = await NoteHelper().getNotes(appInfo.sortMode, NotesReturnMode.ALL);

                                          if(body["notes"].isNotEmpty && list.isNotEmpty) {
                                            result = await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Notes found on your account"),
                                                  content: Text("Your account seem to already have some notes saved.\nWhat do you want to do?"),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text("Keep current"),
                                                      onPressed: () => Navigator.pop(context),
                                                    ),
                                                    FlatButton(
                                                      child: Text("Replace with cloud"),
                                                      onPressed: () async {
                                                        List<Note> list = await NoteHelper().getNotes(appInfo.sortMode, NotesReturnMode.ALL);
                                                        
                                                        for(int i = 0; i < list.length; i++) {
                                                          NoteHelper().delete(list[i].id);
                                                        }

                                                        List<Note> parsedList = await Note.fromRequest(body["notes"], false);

                                                        for(int i = 0; i < parsedList.length; i++) {
                                                          await NoteHelper().insert(parsedList[i]);
                                                        }

                                                        Navigator.pop(context, false);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }
                                            );
                                          }

                                          if(result == null) {
                                            List<Note> list = await NoteHelper().getNotes(appInfo.sortMode, NotesReturnMode.ALL);

                                            for(int i = 0; i < body["notes"].length; i++) {
                                              await post("https://sync.potatoproject.co/api/notes/deleteall",
                                                  headers: {"Authorization": appInfo.userToken});
                                            }

                                            for(int i = 0; i < list.length; i++) {
                                              await post("https://sync.potatoproject.co/api/notes/save",
                                                  body: list[i].readyForRequest,
                                                  headers: {"Authorization": appInfo.userToken});
                                            }
                                          }
                                              

                                          Navigator.pop(context);
                                        } else {
                                          scaffoldKey.currentState.showSnackBar(SnackBar(
                                            content: Text(responseBody["message"].toString()),
                                          ));
                                        }
                                      }

                                      setState(() => showLoadingOverlay = false);

                                      if(email.isEmpty) setState(() => emailEmpty = true);

                                      if(password.isEmpty) setState(() => passwordEmpty = true);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
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