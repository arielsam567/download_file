import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static SharedPreferences? _sharedPreferences;
  static SharedPreferences? get storage => _sharedPreferences;

  Storage() {
    init();
  }

  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  static Future<String?> getString(String key) async {
    if (_sharedPreferences == null) {
      return init().then((value) => _sharedPreferences!.getString(key));
    }
    return _sharedPreferences!.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    if (_sharedPreferences == null) {
      return init().then((_) => _sharedPreferences!.setString(key, value));
    }
    _sharedPreferences!.setString(key, value);
  }

  Future<void> clear() async {
    if (_sharedPreferences == null) {
      await init();
    }
    _sharedPreferences!.clear();
  }
}
