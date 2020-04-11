import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences prefs;

  SharedPrefs._(this.prefs);
  static Future<SharedPrefs> newInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return SharedPrefs._(preferences);
  }

  Future<bool> getUseGrid() async {
    return prefs.getBool("use_grid") ?? false;
  }

  void setUseGrid(bool value) async {
    await prefs.setBool("use_grid", value);
  }
}
