import 'package:potato_notes/internal/sync/controller/account_controller.dart';

class SyncHelper {
  AccountController _account;

  SyncHelper() {
    this._account = AccountController();
  }

  Future<bool> accountRegister(
          String username, String email, String password) async =>
      await _account.register(username, email, password);

  Future<bool> accountLogin(String emailOrUser, String password) async =>
      await _account.login(emailOrUser, password);
}
