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

    Response newAccount = await post(
      "${prefs.apiUrl.replaceAll('4000', '3000')}/user/register",
      body: json.encode(body),
    );

    switch (newAccount.statusCode) {
      case 200:
        {
          return Right(null);
        }
      case 400:
        {
          return Left(Failure(json.decode(newAccount.body)["message"]));
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
    print(json.encode(body));
    Response login;
    try {
      login = await post(
          "${prefs.apiUrl.replaceAll('4000', '3000')}/user/login",
          body: json.encode(body),
          headers: {"Content-Type": "application/json"});
    } catch (e) {
      if (e.runtimeType == SocketException) {
        return Left(Failure("Could not connect to server"));
      }
    }
    Loggy.d(message: login.body, secure: true);
    switch (login.statusCode) {
      case 200:
        {
          Map<String, dynamic> response = json.decode(login.body);
          prefs.accessToken = response["token"];
          prefs.refreshToken = response["refresh_token"];
          return Right(null);
        }
      case 400:
        {
          if(login.body.startsWith("[")){
            return Left(Failure(json.decode(login.body)[0]["constraints"]["length"]));
          } else {
            return Left(Failure(login.body));
          }
        }
    }
  }

  static Future<Either<Failure, void>> refreshToken() async {
    Response refresh;
    try {
      refresh = await get(
          "${prefs.apiUrl.replaceAll('4000', '3000')}/user/refresh",
          headers: {"Authorization": prefs.refreshToken});
      switch (refresh.statusCode) {
        case 200:
          {
            prefs.accessToken = json.decode(refresh.body);
            Loggy.d(message: refresh.body, secure: true);
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
        return e;
      }
    }
  }
}
