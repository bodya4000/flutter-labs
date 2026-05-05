import 'dart:convert';

import 'package:unik_mobile/core/storage/key_value_storage.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';
import 'package:unik_mobile/domain/user/user_repository.dart';

final class LocalUserRepository implements UserRepository {
  LocalUserRepository(this._storage);

  final KeyValueStorage _storage;

  static const String _userKey = 'lab5_registered_user_v2';
  static const String _sessionKey = 'lab5_session_email_v1';

  @override
  Future<RegisteredUser?> getStoredUser() async {
    final raw = await _storage.readString(_userKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    return RegisteredUser.fromJson(Map<String, Object?>.from(decoded));
  }

  @override
  Future<void> upsertUser(RegisteredUser user) async {
    await _storage.writeString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<void> deleteStoredUser() async {
    await _storage.remove(_userKey);
    await _storage.remove(_sessionKey);
  }

  @override
  Future<String?> getSessionEmail() async {
    final value = await _storage.readString(_sessionKey);
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  @override
  Future<void> setSessionEmail(String? email) async {
    if (email == null || email.isEmpty) {
      await _storage.remove(_sessionKey);
      return;
    }
    await _storage.writeString(_sessionKey, email);
  }
}
