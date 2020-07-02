abstract class AccountInterface {
  static Future<bool> register(String username, String email, String password) async{
    return false;
  }

  static Future<String> login(String emailOrUser, String password) async{
    return "Uninplemented";
  }
}
