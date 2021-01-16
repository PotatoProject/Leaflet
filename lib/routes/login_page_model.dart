import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';


enum LoginState {
  LOGIN,
  REGISTER
}
class LoginPageModel extends ChangeNotifier {
  LoginState loginState = LoginState.LOGIN;
  bool get registering => loginState == LoginState.REGISTER;
  bool get loggingIn => loginState == LoginState.LOGIN;
  bool obscurePassword = true;
  bool isLoading = false;
  bool submitEnabled = true;

  String password = "";
  String username = "";
  String email = "";

  void switchObscurePassword(){
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void switchState(){
    password = "";
    username = "";
    email = "";
    loginState = loginState == LoginState.REGISTER ? LoginState.LOGIN : LoginState.REGISTER;
    notifyListeners();
  }

  void onSubmit(BuildContext context) async {
    AuthResponse response;

    isLoading = true;
    notifyListeners();

    if (registering) {
      response = await AccountController.register(
        username,
        email,
        password,
      );
    } else {
      response = await AccountController.login(
        email,
        password,
      );
    }

    isLoading = false;
    notifyListeners();

    if (response.status && loggingIn) {
      Navigator.pop(context);
    } else {
      if (response.message == null) return;
      showError(context, response);
    }
  }

  void showError(BuildContext context, AuthResponse response){
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: min(640, MediaQuery
            .of(context)
            .size
            .width - 32),
        content: Text(
          registering ? response.message ?? "Registered!" : response.message!,
        ),
      ),
    );
  }
}
