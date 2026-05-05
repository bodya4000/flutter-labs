import 'package:dio/dio.dart';
import 'package:unik_mobile/data/api/api_clients.dart';
import 'package:unik_mobile/domain/auth/password_hasher.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';

final class AuthNetworking {
  AuthNetworking(this._api);
  final AuthRemoteDataSource _api;

  RegisteredUser _withLocalPassword(RegisteredUser profile, String password) {
    final salt = PasswordHasher.generateSalt();
    return profile.copyWith(
      accessToken: profile.accessToken,
      passwordHash: PasswordHasher.hash(password, salt),
      salt: salt,
    );
  }

  String? _dioMsg(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return null;
  }

  Future<({RegisteredUser? user, String? error})> register({
    required String email,
    required String password,
    required String fullName,
    String nickname = '',
  }) async {
    try {
      final (token, profile) = await _api.register(
        email: email,
        password: password,
        fullName: fullName,
        nickname: nickname,
      );
      final merged = _withLocalPassword(
        profile.copyWith(accessToken: token),
        password,
      );
      return (user: merged, error: null);
    } on DioException catch (e) {
      return (user: null, error: _dioMsg(e) ?? 'Registration failed');
    }
  }

  Future<({RegisteredUser? user, String? error})> remoteLogin({
    required String email,
    required String password,
  }) async {
    try {
      final (token, profile) = await _api.login(
        email: email,
        password: password,
      );
      final merged = _withLocalPassword(
        profile.copyWith(accessToken: token),
        password,
      );
      return (user: merged, error: null);
    } on DioException catch (e) {
      return (user: null, error: _dioMsg(e) ?? 'Sign in failed');
    }
  }

  Future<({RegisteredUser? user, String? error})> patchProfile({
    required String token,
    required String fullName,
    required String email,
    String nickname = '',
    String newPassword = '',
  }) async {
    try {
      final patched = await _api.patchProfile(
        token: token,
        fullName: fullName,
        email: email,
        nickname: nickname,
        newPassword: newPassword,
      );
      return (user: patched, error: null);
    } on DioException catch (e) {
      return (user: null, error: _dioMsg(e) ?? 'Update failed');
    }
  }

  Future<void> deleteRemote(String token) async {
    await _api.deleteAccountRemote(token);
  }
}
