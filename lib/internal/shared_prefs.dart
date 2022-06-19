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

class SharedPreferencesBackend extends LocalPreferencesBackend {
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
  void setBool(String key, bool? value) {
    _setValue<bool>(key, value);
  }

  @override
  void setDouble(String key, double? value) {
    _setValue<double>(key, value);
  }

  @override
  void setInt(String key, int? value) {
    _setValue<int>(key, value);
  }

  @override
  void setString(String key, String? value) {
    _setValue<String>(key, value);
  }

  @override
  void setStringList(String key, List<String>? value) {
    _setValue<List<String>>(key, value);
  }

  void _setValue<T>(String key, T? value) {
    if (value != null) {
      if (value is bool) {
        prefs.setBool(key, value);
      } else if (value is double) {
        prefs.setDouble(key, value);
      } else if (value is int) {
        prefs.setInt(key, value);
      } else if (value is String) {
        prefs.setString(key, value);
      } else if (value is List<String>) {
        prefs.setStringList(key, value);
      }
    } else {
      prefs.remove(key);
    }
  }
}
