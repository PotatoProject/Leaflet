import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/providers.dart';

class AccountController {
  AccountController._();

  // used for registering a user, all it needs is username, email, password.
  // When there is an error it throws an exception which needs to be catched
  static Future<AuthResponse> register(
      String username, String email, String password) async {
    Map<String, String> body = {
      "username": username,
      "email": email,
      "password": password,
    };
    try {
      Response registerResponse = await post(
        "${prefs.apiUrl}/login/user/register",
        body: json.encode(body),
      );
      Loggy.v(
          message:
              "(register) Server responded with (${registerResponse.statusCode}): ${registerResponse.body}",
          secure: true);

      switch (registerResponse.statusCode) {
        case 200:
          return AuthResponse(status: true);
        case 400:
          return AuthResponse(
            status: false,
            message: json.decode(registerResponse.body)["message"],
          );
        default:
          throw ("Unexpected response from auth server");
      }
    } on SocketException {
      throw ("Could not connect to auth server");
    } catch (e) {
      rethrow;
    }
  }

  // Logs in the user and puts tokens in shared_prefs
  // When there is an error it throws an exception which needs to be catched
  static Future<AuthResponse> login(String emailOrUser, String password) async {
    Map<String, String> body;

    if (emailOrUser.contains(RegExp(".*\..*@.*\..*", dotAll: true))) {
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

    try {
      Response loginResponse = await post("${prefs.apiUrl}/login/user/login",
          body: json.encode(body),
          headers: {"Content-Type": "application/json"});
      Loggy.v(
          message:
              "(login) Server responded with (${loginResponse.statusCode}): ${loginResponse.body}",
          secure: true);
      switch (loginResponse.statusCode) {
        case 200:
          Map<String, dynamic> response = json.decode(loginResponse.body);
          prefs.accessToken = response["token"];
          prefs.refreshToken = response["refresh_token"];
          return AuthResponse(status: true);
        case 400:
          if (loginResponse.body.startsWith("[")) {
            return AuthResponse(
              status: false,
              message: json.decode(loginResponse.body)[0]["constraints"]
                  ["length"],
            );
          } else {
            return AuthResponse(
              status: false,
              message: loginResponse.body,
            );
          }
          break;
        default:
          throw ("Unexpected response from auth server");
      }
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      rethrow;
    }
  }

  // When the api the app uses returns a 401 (Unauthorized) this likely means the token is expired and needs to be refreshed
  // If the refreshing returns an exception with the body, it means it couldnt request access again
  // This means that the user needs to log back in.
  // When there is an error it throws an exception which needs to be catched
  static Future<AuthResponse> refreshToken() async {
    Response refresh;
    try {
      var url = "${prefs.apiUrl}/login/user/refresh";
      Loggy.v(message: "Going to send GET to " + url);
      refresh = await get(
        url,
        headers: {
          "Authorization": "Bearer " + prefs.refreshToken,
        },
      );
      Loggy.v(
        message:
            "(refreshToken) Server responded with (${refresh.statusCode}): ${refresh.body}",
        secure: true,
      );
      switch (refresh.statusCode) {
        case 200:
          {
            prefs.accessToken = json.decode(refresh.body)["token"];
            Loggy.d(message: "accessToken: " + prefs.accessToken, secure: true);
            return AuthResponse(status: true);
          }
        case 400:
          return AuthResponse(
            status: false,
            message: refresh.body,
          );
        default:
          throw ("Unexpected response from auth server");
      }
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      rethrow;
    }
  }
}

class AuthResponse {
  final bool status;
  final String message;

  AuthResponse({
    @required this.status,
    this.message,
  });
}
