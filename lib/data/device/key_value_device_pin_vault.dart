import 'package:unik_mobile/core/storage/key_value_storage.dart';
import 'package:unik_mobile/domain/auth/password_hasher.dart';
import 'package:unik_mobile/domain/device/device_pin_vault.dart';

final class KeyValueDevicePinVault implements DevicePinVault {
  KeyValueDevicePinVault(this._storage);
  final KeyValueStorage _storage;

  static const String _hashKey = 'lab5_device_pin_hash_v1';
  static const String _saltKey = 'lab5_device_pin_salt_v1';

  @override
  Future<bool> hasConfiguredPin() async {
    final h = await _storage.readString(_hashKey);
    return h != null && h.isNotEmpty;
  }

  @override
  Future<void> setPinFromPlain(String pin) async {
    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hash(pin.trim(), salt);
    await _storage.writeString(_saltKey, salt);
    await _storage.writeString(_hashKey, hash);
  }

  @override
  Future<void> clearPin() async {
    await _storage.remove(_hashKey);
    await _storage.remove(_saltKey);
  }

  @override
  Future<bool> verifyPin(String plain) async {
    final hash = await _storage.readString(_hashKey);
    final salt = await _storage.readString(_saltKey);
    if (hash == null || salt == null) {
      return false;
    }
    return PasswordHasher.verify(plain.trim(), salt, hash);
  }
}
