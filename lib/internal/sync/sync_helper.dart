import 'package:potato_notes/internal/sync/controller/account_controller.dart';

class SyncHelper {
  Future<bool> accountRegister(
          String username, String email, String password) async =>
      await AccountController.register(username, email, password);

  Future<String> accountLogin(String emailOrUser, String password) async =>
      await AccountController.login(emailOrUser, password);
}

class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}
