import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) {
    return _sharedPreferences!.setString(key, value);
  }

  static String? getString(String key) {
    return _sharedPreferences!.getString(key);
  }
}
