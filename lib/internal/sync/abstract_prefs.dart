import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/providers.dart';

class AbstractPrefs {
  String? get(String provider, String key) {
    final finalKey = "$provider-$key";
    Logger("AbstractPrefs").i("Getting $finalKey");
    return sharedPrefs.prefs.getString(finalKey);
  }

  Future put(String provider, String key, String value) async {
    final finalKey = "$provider-$key";
    await Logger("AbstractPrefs").i("Setting $finalKey");
    await sharedPrefs.prefs.setString(finalKey, value);
    await Logger("AbstractPrefs").i("Set $finalKey to $value", secure: true);
  }
}
