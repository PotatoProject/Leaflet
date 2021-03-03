import 'dart:convert';
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';
import 'package:potato_notes/internal/utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailOrUserController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailOrUserFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
      (_) => context.focusScope.requestFocus(emailOrUserFocusNode),
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

    context.dismissibleRoute.requestDisableGestures = showLoadingOverlay;

    final List<Widget> items = [
      TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: register ? "Email" : "Email or username",
          errorText: register ? emailError : (emailError ?? usernameError),
        ),
        autofillHints: [
          AutofillHints.email,
        ],
        onFieldSubmitted: (_) => context.focusScope.requestFocus(
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
              context.focusScope.requestFocus(passwordFocusNode),
          controller: usernameController,
          focusNode: usernameFocusNode,
          onChanged: (_) => setState(() {}),
        ),
      ),
      SizedBox(height: 16),
      Builder(builder: (context) {
        return TextFormField(
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
              ? (text) => onSubmit(context)
              : (text) => context.focusScope.unfocus(),
          autofillHints: [
            AutofillHints.password,
          ],
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: obscurePass,
          onChanged: (_) => setState(() {}),
        );
      }),
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
                onPressed: () => Utils.launchUrl(
                    "${prefs.apiUrl}/account/password-forgotten"),
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
              onPressed: enabledCondition ? () => onSubmit(context) : null,
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
            textTheme: context.theme.textTheme,
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
                              context.focusScope.requestFocus(emailFocusNode);
                            } else {
                              context.focusScope
                                  .requestFocus(emailOrUserFocusNode);
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(16),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: context.theme.textTheme.bodyText2,
                            children: [
                              TextSpan(
                                text: register
                                    ? "Already have an account? "
                                    : "Don't have an account yet? ",
                              ),
                              TextSpan(
                                text: register ? "Login." : "Register.",
                                style: TextStyle(
                                  color: context.theme.accentColor,
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

  void onSubmit(BuildContext context) async {
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
      context.pop();
    } else {
      if (response.message.startsWith("{")) {
        final Map<String, dynamic> validation = json.decode(response.message);
        setState(() {
          usernameError = getString(validation["username"]);
          emailError = getString(validation["email"]);
          passwordError = getString(validation["password"]);
        });
      } else {
        context.scaffoldMessenger.removeCurrentSnackBar();
        context.scaffoldMessenger.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            width: min(640, context.mSize.width - 32),
            content: Text(
              register
                  ? response.message.trim() ?? "Registered!"
                  : response.message.trim(),
            ),
          ),
        );
      }
    }
  }
}
