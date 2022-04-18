abstract class IAuthController {
  Future<void> login(String username, String password);

  Future<void> logout();

  Map<String, String> getData();

  bool isLoggedIn();
}
