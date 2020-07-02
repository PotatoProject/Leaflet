import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/sync/controller/account_controller.dart';
import 'package:potato_notes/widget/sync_inputfield.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    passwordNode.addListener(
            () => setState(() => passwordSelected = !passwordSelected));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.autorenew,
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
                              fontSize: 30, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  SyncInputField(
                    title: 'Email or username',
                    errorMessage: 'The field is empty',
                    selectHandler: emailSelected,
                    emptyHandler: emailEmpty,
                    focusNode: emailNode,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      email = text;
                      if (emailEmpty) setState(() => emailEmpty = false);
                    },
                  ),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  SyncInputField(
                    title: 'Password',
                    errorMessage: 'The field is empty',
                    selectHandler: passwordSelected,
                    emptyHandler: passwordEmpty,
                    focusNode: passwordNode,
                    onChanged: (text) {
                      password = text;
                      if (passwordEmpty) setState(() => passwordEmpty = false);
                    },
                    isPassword: true,
                    showPassword: showPassword,
                    trailing: IconButton(
                      color: showPassword
                          ? Theme.of(context).iconTheme.color
                          : Theme.of(context).disabledColor,
                      icon: Icon(Icons.remove_red_eye),
                      tooltip: showPassword
                          ? 'Hide text'
                          : 'Show text',
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
                                  )),
                              child: Text('Register'),
                              textColor: Theme.of(context).accentColor, onPressed: () {  },
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
                            textColor:
                            Theme.of(context).scaffoldBackgroundColor,
                            child: Text('Login'),
                            onPressed: () async {
                              if (email.isNotEmpty && password.isNotEmpty) {
                                if(password.length < 5){
                                  await scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Password should be longer than or equal to 5 characters",
                                      style: Theme.of(context).textTheme.bodyText2,),
                                    backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
                                  )).closed;
                                  return;
                                } else if(email.length < 3){
                                  await scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Email or Username should be longer than or equal to 3 characters",
                                      style: Theme.of(context).textTheme.bodyText2,),
                                    backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
                                  )).closed;
                                  return;
                                }
                                setState(() => showLoadingOverlay = true);
                                var response = await AccountController.login(email, password);
                                if(response == 'Logged in'){
                                  setState(() => showLoadingOverlay = false);
                                  Navigator.pop(context);
                                } else {
                                  setState(() => showLoadingOverlay = false);
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        response,
                                    style: Theme.of(context).textTheme.bodyText2,),
                                    backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
                                  ));
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                        tooltip: 'Go back',
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