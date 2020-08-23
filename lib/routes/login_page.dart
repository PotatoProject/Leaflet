import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailOrUserController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePass = true;
  bool register = false;
  bool showLoadingOverlay = false;

  @override
  void initState() {
    BackButtonInterceptor.add((_) => showLoadingOverlay, name: "antiPop");
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName("antiPop");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: register ? "Email" : "Email or username",
        ),
        autofillHints: [
          AutofillHints.email,
        ],
        controller: register ? emailController : emailOrUserController,
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
          ),
          controller: usernameController,
          onChanged: (_) => setState(() {}),
        ),
      ),
      SizedBox(height: 16),
      TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
          suffixIcon: IconButton(
            icon: Icon(
              obscurePass ? MdiIcons.eyeOffOutline : MdiIcons.eyeOutline,
            ),
            onPressed: () => setState(() => obscurePass = !obscurePass),
          ),
        ),
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
              child: FlatButton(
                child: Text("Forgot password"),
                onPressed: () {},
                textColor: Theme.of(context).accentColor,
              ),
            ),
          ),
          Visibility(
            visible: !register,
            child: Spacer(),
          ),
          Expanded(
            flex: 12,
            child: Builder(
              builder: (context) {
                bool enabledCondition;

                if (register) {
                  enabledCondition = usernameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty;
                } else {
                  enabledCondition = emailOrUserController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty;
                }
                return RaisedButton(
                  child: Text(register ? "Register" : "Login"),
                  disabledColor: Theme.of(context).disabledColor,
                  disabledTextColor: Theme.of(context).scaffoldBackgroundColor,
                  onPressed: enabledCondition
                      ? () async {
                          AuthResponse response;

                          setState(() => showLoadingOverlay = true);

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
                            Scaffold.of(context).removeCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  register
                                      ? response.message ?? "Registered!"
                                      : response.message,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    ];
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(register ? "Register" : "Login"),
            textTheme: Theme.of(context).textTheme,
          ),
          body: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: items,
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: FlatButton(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText2,
                            children: [
                              TextSpan(
                                text: register
                                    ? "Already have an account?"
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
                        onPressed: () {
                          emailOrUserController.clear();
                          emailController.clear();
                          usernameController.clear();
                          passwordController.clear();
                          setState(() => register = !register);
                        },
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
}
