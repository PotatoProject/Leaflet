import 'dart:math';

import 'package:animations/animations.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';
import 'package:potato_notes/widget/dismissible_route.dart';
import 'package:stacked/stacked.dart';

import 'login_page_model.dart';

class LoginPage extends StatelessWidget {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool obscurePass = true;
  bool register = false;
  bool showLoadingOverlay = false;

  @override
  Widget build(BuildContext context) {

    /*if (register) {
      enabledCondition = usernameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    } else {
      enabledCondition = emailOrUserController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    }*/

    DismissibleRoute.of(context)?.requestDisableGestures = showLoadingOverlay;

    return ViewModelBuilder<LoginPageModel>.reactive(
      viewModelBuilder: () => LoginPageModel(),
      builder: (context, model, _) => Stack(
        children: [
          Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(model.loginState == LoginState.REGISTER
                  ? "Register"
                  : "Login"),
              textTheme: Theme.of(context).textTheme,
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: PageTransitionSwitcher(
                  duration: Duration(milliseconds: 250),
                  transitionBuilder:
                      (child, primaryAnimation, secondaryAnimation) {
                    return FadeThroughTransition(
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                      fillColor: Colors.transparent,
                    );
                  },
                  child: ConstrainedBox(
                    key: register ? Key("register") : Key("login"),
                    constraints: BoxConstraints(
                      maxWidth: 480,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        buildEmailOrUsernameField(model),
                        Visibility(
                          visible: model.registering,
                          child: SizedBox(height: 16),
                        ),
                        buildUsernameField(model),
                        SizedBox(height: 16),
                        buildPasswordField(context, model),
                        SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            Visibility(
                              visible: model.loggingIn,
                              child: Expanded(
                                flex: 12,
                                child: FlatButton(
                                  child: Text(
                                    "Forgot password",
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {},
                                  textColor: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: model.loggingIn,
                              child: Spacer(),
                            ),
                            Expanded(
                              flex: 12,
                              child: RaisedButton(
                                child: Text(model.registering ? "Register" : "Login"),
                                disabledColor: Theme.of(context).disabledColor,
                                disabledTextColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                textColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                onPressed: () => model.submitEnabled ? model.onSubmit(context) : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              height: 49,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Material(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Divider(height: 1),
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          model.switchState();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText2,
                              children: [
                                TextSpan(
                                  text: model.loginState == LoginState.REGISTER
                                      ? "Already have an account? "
                                      : "Don't have an account yet? ",
                                ),
                                TextSpan(
                                  text: model.loginState == LoginState.REGISTER
                                      ? "Login."
                                      : "Register.",
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: model.isLoading,
            child: SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black54,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmailOrUsernameField(LoginPageModel model) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: model.loginState == LoginState.REGISTER
            ? "Email"
            : "Email or username",
      ),
      autofillHints: [
        AutofillHints.email,
      ],
      //onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(
      //  register ? usernameFocusNode : passwordFocusNode,
      //),
      //controller: register ? emailController : emailOrUserController,
      //focusNode: register ? emailFocusNode : emailOrUserFocusNode,
      onChanged: (text) => model.email = text,
    );
  }

  Widget buildUsernameField(LoginPageModel model) {
    return Visibility(
      visible: model.registering,
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Username",
        ),
        autofillHints: [
          AutofillHints.username,
        ],
        //onFieldSubmitted: (_) =>
        //    FocusScope.of(context).requestFocus(passwordFocusNode),
        //controller: usernameController,
        //focusNode: usernameFocusNode,
        onChanged: (text) => model.username = text,
      ),
    );
  }

  Widget buildPasswordField(BuildContext context, LoginPageModel model) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Password",
        suffixIcon: IconButton(
          icon: Icon(
            model.obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () => model.switchObscurePassword(),
        ),
      ),
      onFieldSubmitted: model.submitEnabled
          ? (text) => model.onSubmit(context)
          : (text) => {},
      autofillHints: [
        AutofillHints.password,
      ],
      keyboardType: TextInputType.visiblePassword,
      obscureText: model.obscurePassword,
      onChanged: (text) => model.password = text,
    );
  }
}
