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
        return "Already exists. Try logging in";
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
          border: const OutlineInputBorder(),
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
        child: const SizedBox(height: 16),
      ),
      Visibility(
        visible: register,
        child: TextFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "Username",
            errorText: usernameError,
          ),
          autofillHints: const [AutofillHints.username],
          onFieldSubmitted: (_) =>
              context.focusScope.requestFocus(passwordFocusNode),
          controller: usernameController,
          focusNode: usernameFocusNode,
          onChanged: (_) => setState(() {}),
        ),
      ),
      const SizedBox(height: 16),
      Builder(builder: (context) {
        return TextFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
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
          autofillHints: const [AutofillHints.password],
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: obscurePass,
          onChanged: (_) => setState(() {}),
        );
      }),
      const SizedBox(height: 16),
      Row(
        children: <Widget>[
          Visibility(
            visible: !register,
            child: Expanded(
              flex: 12,
              child: TextButton(
                onPressed: () => Utils.launchUrl(
                    "${prefs.apiUrl}/account/password-forgotten"),
                child: const Text(
                  "Forgot password",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Visibility(
            visible: !register,
            child: const Spacer(),
          ),
          Expanded(
            flex: 12,
            child: ElevatedButton(
              onPressed: enabledCondition ? () => onSubmit(context) : null,
              child: Text(register ? "Register" : "Login"),
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
              padding: const EdgeInsets.all(24),
              child: PageTransitionSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder:
                    (child, primaryAnimation, secondaryAnimation) {
                  return FadeThroughTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    fillColor: Colors.transparent,
                    child: child,
                  );
                },
                child: ConstrainedBox(
                  key: register ? const Key("register") : const Key("login"),
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: items,
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 49,
            child: Material(
              child: Column(
                children: <Widget>[
                  const Divider(height: 1),
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
                          padding: const EdgeInsets.all(16),
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
          child: const SizedBox.expand(
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

  Future<void> onSubmit(BuildContext context) async {
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
      if (response.message is Map<String, dynamic>) {
        final Map<String, dynamic> validation =
            response.message as Map<String, dynamic>;
        setState(() {
          usernameError = getString(validation["username"] as int);
          emailError = getString(validation["email"] as int);
          passwordError = getString(validation["password"] as int);
        });
      } else {
        final bool canBeHandled = _statusMessages.containsKey(
          response.message.toString(),
        );

        String message;

        if (register) {
          message = response.message.toString().trim() ?? "Registered!";
        } else {
          if (canBeHandled) {
            message = _statusMessages[response.message.toString()];
          } else {
            message = response.message.toString();
          }
        }

        context.scaffoldMessenger.removeCurrentSnackBar();
        context.scaffoldMessenger.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            width: min(640, context.mSize.width - 32),
            content: Text(message),
          ),
        );
      }
    }
  }

  static final Map<String, String> _statusMessages = {
    'INVALID_CREDENTIALS': 'The username or password is wrong.',
    'USER_NOT_FOUND': 'No such user exists on the server.',
    'USER_NOT_VERIFIED':
        'The user is not verified yet. Please check your inbox.',
    'LOGGED_OUT': 'The user is already logged out.',
    'INVALID_TOKEN': 'The token is not valid, login again.',
    'INVALID_SESSION': 'The current session is not valid, login again.',
  };
}
