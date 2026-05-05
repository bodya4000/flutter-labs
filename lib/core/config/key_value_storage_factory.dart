import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unik_mobile/core/storage/key_value_storage.dart';
import 'package:unik_mobile/core/storage/shared_preferences_storage.dart';
import 'package:unik_mobile/core/storage/user_defaults_storage.dart';

abstract final class KeyValueStorageFactory {
  static Future<KeyValueStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    if (!kIsWeb && Platform.isIOS) {
      return UserDefaultsStorage(prefs);
    }
    return SharedPreferencesStorage(prefs);
  }
}
