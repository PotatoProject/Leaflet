import 'package:potato_notes/internal/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences prefs;

  SharedPrefs._(this.prefs);
  static Future<SharedPrefs> newInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return SharedPrefs._(preferences);
  }

  PassType getPassType() {
    switch(prefs.getInt("pass_type") ?? 0) {
      case 0:
        return PassType.NONE;
      case 1:
        return PassType.PASSWORD;
      case 2:
        return PassType.PIN;
      default:
        return PassType.NONE;
    }
  }

  void setPassType(PassType value) async {
    switch(value) {
      case PassType.NONE:
        await prefs.setInt("pass_type", 0);
        break;
      case PassType.PASSWORD:
        await prefs.setInt("pass_type", 1);
        break;
      case PassType.PIN:
        await prefs.setInt("pass_type", 2);
        break;
    }
  }

  String getMasterPassword() {
    return prefs.getString("master_password");
  }

  void setMasterPassword(String value) async {
    await prefs.setString("master_password", value);
  }

  String getMasterPin() {
    return prefs.getString("master_pin");
  }

  void setMasterPin(String value) async {
    await prefs.setString("master_pin", value);
  }

  bool getUseGrid() {
    return prefs.getBool("use_grid") ?? false;
  }

  void setUseGrid(bool value) async {
    await prefs.setBool("use_grid", value);
  }
}
