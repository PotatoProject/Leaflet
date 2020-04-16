import 'package:flutter/material.dart';
import 'package:potato_notes/internal/sync/controller/account_controller.dart';

class SyncHelper {
  AccountController _account;

  SyncHelper(BuildContext context) {
    this._account = AccountController(context);
  }

  Future<bool> accountRegister(
          String username, String email, String password) async =>
      await _account.register(username, email, password);

  Future<bool> accountLogin(String emailOrUser, String password) async =>
      await _account.login(emailOrUser, password);
}
