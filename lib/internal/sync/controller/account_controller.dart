import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/interface/account_interface.dart';

class AccountController implements AccountInterface {

  AccountController();

  static Future<bool> register(String username, String email, String password) async {
    Map<String, String> body = {
      "username": username,
      "email": email,
      "password": password,
    };

    Response newAccount = await post(
      "${prefs.apiUrl.replaceAll('4000', '3000')}/user/register",
      body: json.encode(body),
    );

    return newAccount.statusCode == 200;
  }

  static Future<String> login(String emailOrUser, String password) async {
    Map<String, String> body;

    if (emailOrUser.contains(
        RegExp(".*\..*@.*\..*", dotAll: true))) {
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
    print(json.encode(body));
    Response login;
    try {
      login = await post(
          "${prefs.apiUrl.replaceAll('4000', '3000')}/user/login",
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json"
          }
      );
    } catch (e){
      if(e.runtimeType == SocketException){
        return "Could not connect to server";
      }
    }
    Loggy.d(message: login.body, secure: true);
    if (login.statusCode == 200) {
      Map<String, dynamic> response = json.decode(login.body);
      prefs.accessToken = response["token"];
      prefs.refreshToken = response["refresh_token"];
      return 'Logged in';
    } else {
      return login.body;
    }
  }

  static Future<String> refreshToken() async{
    Response refresh;
    try {
      refresh = await get(
        "${prefs.apiUrl.replaceAll('4000', '3000')}/user/refresh",
        headers: {
          "Authorization": prefs.refreshToken
        }
      );
      if (refresh.statusCode == 200) {
        prefs.accessToken = json.decode(refresh.body);
        Loggy.d(message: refresh.body, secure: true);
        return 'Refreshed';
      } else {
        return "Could not refresh token statuscode: " + refresh.statusCode.toString();
      }
    } catch (e){
      if(e.runtimeType == SocketException){
        return "Could not connect to server";
      } else {
        return e;
      }
    }

  }
}
