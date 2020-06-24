import 'dart:convert';

import 'package:http/http.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/sync/interface/account_interface.dart';
import 'package:potato_notes/locator.dart';

class AccountController implements AccountInterface {
  Preferences prefs;

  AccountController() {
    this.prefs = locator<Preferences>();
  }

  Future<bool> register(String username, String email, String password) async {
    Map<String, String> body = {
      "username": username,
      "email": email,
      "password": password,
    };

    Response newAccount = await post(
      "${prefs.apiUrl}/api/users/new",
      body: json.encode(body),
    );

    return json.decode(newAccount.body)["status"];
  }

  Future<bool> login(String emailOrUser, String password) async {
    Map<String, String> body;

    if (emailOrUser.contains("@")) {
      body = {
        "email": emailOrUser,
        "password": password,
      };
    } else {
      body = {
        "username": emailOrUser,
        "password": password,
      };
    }

    Response login = await post(
      "${prefs.apiUrl}/api/users/login",
      body: json.encode(body),
    );
    bool status = json.decode(login.body)["status"];
    Map<String, dynamic> loginAccountInfo = json.decode(login.body)["account"];

    if (login.statusCode == 200) {
      prefs.accessToken = loginAccountInfo["access_token"];
      prefs.refreshToken = loginAccountInfo["refresh_token"];
      prefs.username = loginAccountInfo["username"];
      prefs.email = loginAccountInfo["email"];
    }

    return status;
  }
}
