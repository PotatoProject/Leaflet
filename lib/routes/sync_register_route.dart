import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/ui/custom_icons.dart';
import 'package:potato_notes/ui/sync_inputfield.dart';

class SyncRegisterRoute extends StatefulWidget {
  @override
  createState() => _SyncRegisterRouteState();
}

class _SyncRegisterRouteState extends State<SyncRegisterRoute> {
  FocusNode usernameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  String username = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  bool showPassword = false;

  bool usernameSelected = false;
  bool emailSelected = false;
  bool passwordSelected = false;
  bool confirmPasswordSelected = false;

  bool usernameEmpty = false;
  bool emailEmpty = false;
  bool invalidEmail = false;
  bool passwordEmpty = false;
  bool passwordNotMatch = false;

  bool showLoadingOverlay = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    usernameNode.addListener(
        () => setState(() => usernameSelected = !usernameSelected));
    emailNode.addListener(() => setState(() => emailSelected = !emailSelected));
    passwordNode.addListener(
        () => setState(() => passwordSelected = !passwordSelected));
    confirmPasswordNode.addListener(() =>
        setState(() => confirmPasswordSelected = !confirmPasswordSelected));
  }

  @override
  Widget build(BuildContext context) {
    final locales = AppLocalizations.of(context);

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 60),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height -
                      60 -
                      MediaQuery.of(context).padding.top,
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
                                    locales.syncRegisterRoute_register,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            SyncInputField(
                              title: locales.syncRegisterRoute_username,
                              errorMessage:
                                  locales.syncRegisterRoute_username_empty,
                              selectHandler: usernameSelected,
                              focusNode: usernameNode,
                              emptyHandler: usernameEmpty,
                              onChanged: (text) {
                                username = text;
                                if (usernameEmpty)
                                  setState(() => usernameEmpty = false);
                              },
                            ),
                            Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            SyncInputField(
                              title: locales.syncRegisterRoute_email,
                              errorMessage: invalidEmail
                                  ? locales
                                      .syncRegisterRoute_email_invalidFormat
                                  : locales.syncRegisterRoute_email_empty,
                              selectHandler: emailSelected,
                              focusNode: emailNode,
                              emptyHandler: emailEmpty,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (text) {
                                email = text;
                                if (emailEmpty)
                                  setState(() => emailEmpty = false);
                                if (invalidEmail)
                                  setState(() => invalidEmail = false);
                              },
                            ),
                            Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            SyncInputField(
                              title: locales.syncRegisterRoute_password,
                              errorMessage:
                                  locales.syncRegisterRoute_password_empty,
                              selectHandler: passwordSelected,
                              focusNode: passwordNode,
                              emptyHandler: passwordEmpty,
                              isPassword: true,
                              showPassword: showPassword,
                              onChanged: (text) {
                                password = text;
                                if (passwordEmpty)
                                  setState(() => passwordEmpty = false);
                              },
                              trailing: IconButton(
                                color: showPassword
                                    ? Theme.of(context).iconTheme.color
                                    : Theme.of(context).disabledColor,
                                icon: Icon(Icons.remove_red_eye),
                                tooltip: showPassword
                                    ? "Hide password"
                                    : "Show password",
                                onPressed: () {
                                  setState(() => showPassword = !showPassword);
                                },
                              ),
                            ),
                            Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            SyncInputField(
                              title: locales.syncRegisterRoute_confirmPassword,
                              errorMessage: locales
                                  .syncRegisterRoute_confirmPassword_noMatch,
                              selectHandler: confirmPasswordSelected,
                              focusNode: confirmPasswordNode,
                              emptyHandler: passwordNotMatch,
                              isPassword: true,
                              showPassword: showPassword,
                              onChanged: (text) {
                                confirmPassword = text;
                                if (passwordNotMatch)
                                  setState(() => passwordNotMatch = false);
                              },
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
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      color: Theme.of(context).accentColor,
                                      textColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: Text(
                                          locales.syncRegisterRoute_register),
                                      onPressed: () async {
                                        if ((username.isNotEmpty &&
                                                username.length >= 5) &&
                                            (email.isNotEmpty &&
                                                email.contains(RegExp(
                                                    ".*\..*@.*\..*",
                                                    dotAll: true))) &&
                                            (password.isNotEmpty &&
                                                confirmPassword.isNotEmpty &&
                                                password == confirmPassword)) {
                                          setState(
                                              () => showLoadingOverlay = true);

                                          String body =
                                              "{\"username\": \"$username\", \"email\": \"$email\", \"password\": \"$password\"}";

                                          Response login = await post(
                                              "https://sync.potatoproject.co/api/users/new",
                                              body: body);

                                          Map<dynamic, dynamic> responseBody =
                                              json.decode(login.body);

                                          if (responseBody["status"]) {
                                            Navigator.pop(context, true);
                                          } else {
                                            scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  Utils.parseErrorMessage(
                                                      context,
                                                      responseBody["message"]
                                                          .toString())),
                                            ));
                                          }
                                        }

                                        setState(
                                            () => showLoadingOverlay = false);

                                        if (username.isEmpty)
                                          setState(() => usernameEmpty = true);

                                        if (email.isEmpty)
                                          setState(() => emailEmpty = true);

                                        if (!email
                                            .contains(RegExp(".*\..*@.*\..*")))
                                          setState(() {
                                            invalidEmail = true;
                                            emailEmpty = true;
                                          });

                                        if (password.isEmpty)
                                          setState(() => passwordEmpty = true);
                                        else if (password != confirmPassword)
                                          setState(
                                              () => passwordNotMatch = true);
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
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        tooltip: "Back",
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
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
              )),
            ),
          ],
        ),
      ),
    );
  }
}
