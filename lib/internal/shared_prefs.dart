import 'package:liblymph/providers.dart';
import 'package:potato_notes/generated/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs extends GeneratedSharedPrefs {
  const SharedPrefs({required super.backend});

  static Future<SharedPrefs> newInstance() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    return SharedPrefs(
      backend: SharedPreferencesBackend(instance),
    );
  }
}

class SharedPreferencesBackend extends TypedPreferencesBackend {
  final SharedPreferences prefs;

  const SharedPreferencesBackend(this.prefs);

  @override
  bool? getBool(String pref) => prefs.getBool(pref);

  @override
  double? getDouble(String pref) => prefs.getDouble(pref);

  @override
  int? getInt(String pref) => prefs.getInt(pref);

  @override
  String? getString(String pref) => prefs.getString(pref);

  @override
  List<String>? getStringList(String pref) => prefs.getStringList(pref);

  @override
  void setBool(String key, bool value) {
    prefs.setBool(key, value);
  }

  @override
  void setDouble(String key, double value) {
    prefs.setDouble(key, value);
  }

  @override
  void setInt(String key, int value) {
    prefs.setInt(key, value);
  }

  @override
  void setString(String key, String value) {
    prefs.setString(key, value);
  }

  @override
  void setStringList(String key, List<String> value) {
    prefs.setStringList(key, value);
  }

  @override
  void delete(String key) {
    prefs.remove(key);
  }
}
