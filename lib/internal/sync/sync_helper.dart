import 'package:dartz/dartz.dart';
import 'package:potato_notes/internal/sync/controller/account_controller.dart';

class SyncHelper {
  Future<Either<Failure, void>> accountRegister(
          String username, String email, String password) async =>
      await AccountController.register(username, email, password);

  Future<Either<Failure, void>> accountLogin(String emailOrUser, String password) async =>
      await AccountController.login(emailOrUser, password);
}

class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}
