import 'dart:convert';
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';
import 'package:potato_notes/widget/dismissible_route.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailOrUserController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final emailOrUserFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool obscurePass = true;
  bool register = false;
  bool showLoadingOverlay = false;

  String usernameError;
  String emailError;
  String passwordError;

  String getString(int statusCode) {
    switch (statusCode) {
      case 1:
        return "Too short";
      case 2:
        return "Too long";
      case 3:
        return "Invalid format";
      case 4:
        return "Already exists";
      case 5:
        return "Missing";
      case 0:
      default:
        return null;
    }
  }

  @override
  void initState() {
    BackButtonInterceptor.add((_, __) => showLoadingOverlay, name: "antiPop");
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => FocusScope.of(context).requestFocus(emailOrUserFocusNode),
    );
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName("antiPop");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool enabledCondition;

    if (register) {
      enabledCondition = usernameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    } else {
      enabledCondition = emailOrUserController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    }

    DismissibleRoute.of(context).requestDisableGestures = showLoadingOverlay;

    final items = [
      TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: register ? "Email" : "Email or username",
          errorText: register ? emailError : (emailError ?? usernameError),
        ),
        autofillHints: [
          AutofillHints.email,
        ],
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(
          register ? usernameFocusNode : passwordFocusNode,
        ),
        controller: register ? emailController : emailOrUserController,
        focusNode: register ? emailFocusNode : emailOrUserFocusNode,
        onChanged: (_) => setState(() {}),
      ),
      Visibility(
        visible: register,
        child: SizedBox(height: 16),
      ),
      Visibility(
        visible: register,
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Username",
            errorText: usernameError,
          ),
          autofillHints: [
            AutofillHints.username,
          ],
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(passwordFocusNode),
          controller: usernameController,
          focusNode: usernameFocusNode,
          onChanged: (_) => setState(() {}),
        ),
      ),
      SizedBox(height: 16),
      TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
          errorText: passwordError,
          suffixIcon: IconButton(
            icon: Icon(
              obscurePass
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () => setState(() => obscurePass = !obscurePass),
          ),
        ),
        focusNode: passwordFocusNode,
        onFieldSubmitted: enabledCondition
            ? (text) => onSubmit()
            : (text) => FocusScope.of(context).unfocus(),
        autofillHints: [
          AutofillHints.password,
        ],
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscurePass,
        onChanged: (_) => setState(() {}),
      ),
      SizedBox(height: 16),
      Row(
        children: <Widget>[
          Visibility(
            visible: !register,
            child: Expanded(
              flex: 12,
              child: TextButton(
                child: Text(
                  "Forgot password",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {},
              ),
            ),
          ),
          Visibility(
            visible: !register,
            child: Spacer(),
          ),
          Expanded(
            flex: 12,
            child: ElevatedButton(
              child: Text(register ? "Register" : "Login"),
              onPressed: enabledCondition ? onSubmit : null,
            ),
          ),
        ],
      ),
    ];

    return Stack(
      children: [
        Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(register ? "Register" : "Login"),
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
                    children: items,
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 49,
            child: Material(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Divider(height: 1),
                  Expanded(
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          emailOrUserController.clear();
                          emailController.clear();
                          usernameController.clear();
                          passwordController.clear();
                          usernameError = null;
                          emailError = null;
                          passwordError = null;
                          setState(() => register = !register);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (register) {
                              FocusScope.of(context)
                                  .requestFocus(emailFocusNode);
                            } else {
                              FocusScope.of(context)
                                  .requestFocus(emailOrUserFocusNode);
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(16),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText2,
                            children: [
                              TextSpan(
                                text: register
                                    ? "Already have an account? "
                                    : "Don't have an account yet? ",
                              ),
                              TextSpan(
                                text: register ? "Login." : "Register.",
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
          visible: showLoadingOverlay,
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
    );
  }

  void onSubmit() async {
    AuthResponse response;

    setState(() {
      usernameError = null;
      emailError = null;
      passwordError = null;
      showLoadingOverlay = true;
    });
    if (register) {
      response = await AccountController.register(
        usernameController.text,
        emailController.text,
        passwordController.text,
      );
    } else {
      response = await AccountController.login(
        emailOrUserController.text,
        passwordController.text,
      );
    }

    setState(() => showLoadingOverlay = false);

    if (response.status && !register) {
      Navigator.pop(context);
    } else {
      if (response.message.startsWith("{")) {
        var validation = json.decode(response.message);
        setState(() {
          usernameError = getString(validation["username"]);
          emailError = getString(validation["email"]);
          passwordError = getString(validation["password"]);
        });
      } else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            width: min(640, MediaQuery.of(context).size.width - 32),
            content: Text(
              register ? response.message ?? "Registered!" : response.message,
            ),
          ),
        );
      }
    }
  }
}
