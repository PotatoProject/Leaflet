import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/interface/account_interface.dart';
import 'package:potato_notes/internal/sync/sync_helper.dart';

class AccountController implements AccountInterface {
  AccountController();

  static Future<Either<Failure, void>> register(
      String username, String email, String password) async {
    Map<String, String> body = {
      "username": username,
      "email": email,
      "password": password,
    };

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
        {
          return Right(null);
        }
      case 400:
        {
          return Left(Failure(json.decode(registerResponse.body)["message"]));
        }
      default:
        {
          return Left(Failure("Unexpected response from server"));
        }
    }
  }

  static Future<Either<Failure, void>> login(
      String emailOrUser, String password) async {
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
          {
            Map<String, dynamic> response = json.decode(loginResponse.body);
            prefs.accessToken = response["token"];
            prefs.refreshToken = response["refresh_token"];
            return Right(null);
          }
        case 400:
          {
            if (loginResponse.body.startsWith("[")) {
              return Left(
                  Failure(json.decode(loginResponse.body)[0]["constraints"]["length"]));
            } else {
              return Left(Failure(loginResponse.body));
            }
          }
      }
    } catch (e) {
      if (e.runtimeType == SocketException) {
        return Left(Failure("Could not connect to server"));
      } else {
        return Left(Failure(e));
      }
    }
  }

  static Future<Either<Failure, void>> refreshToken() async {
    Response refresh;
    try {
      var url = "${prefs.apiUrl}/login/user/refresh";
      Loggy.v(message: "Going to send GET to " + url);
      refresh = await get(url,
          headers: {"Authorization": "Bearer " + prefs.refreshToken});
      Loggy.v(
          message:
              "(refreshToken) Server responded with (${refresh.statusCode}): ${refresh.body}",
          secure: true);
      switch (refresh.statusCode) {
        case 200:
          {
            prefs.accessToken = json.decode(refresh.body)["token"];
            Loggy.d(message: "accessToken: " + prefs.accessToken, secure: true);
            return Right(null);
          }
        case 400:
          {
            return Left(Failure(refresh.body));
          }
      }
    } catch (e) {
      if (e.runtimeType == SocketException) {
        return Left(Failure("Could not connect to server"));
      } else {
        return Left(Failure(e.toString()));
      }
    }
  }
}
