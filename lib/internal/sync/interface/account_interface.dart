abstract class AccountInterface {
  Future<bool> register(String username, String email, String password);

  Future<bool> login(String emailOrUser, String password);
}