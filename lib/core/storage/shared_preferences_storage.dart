import 'package:shared_preferences/shared_preferences.dart';
import 'package:unik_mobile/core/storage/key_value_storage.dart';

final class SharedPreferencesStorage implements KeyValueStorage {
  SharedPreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> readString(String key) async => _prefs.getString(key);

  @override
  Future<void> writeString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
