import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

abstract final class PasswordHasher {
  static String generateSalt() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    return base64UrlEncode(bytes);
  }

  static String hash(String password, String salt) {
    final bytes = utf8.encode('$password$salt');
    return sha256.convert(bytes).toString();
  }

  static bool verify(String password, String salt, String storedHash) {
    return hash(password, salt) == storedHash;
  }
}
