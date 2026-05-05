import 'dart:io';

import 'package:dio/dio.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';

abstract final class ApiConfig {
  static String baseOrigin() {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) {
      return fromEnv.endsWith('/')
          ? fromEnv.substring(0, fromEnv.length - 1)
          : fromEnv;
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://127.0.0.1:3000';
  }

  static String apiPrefix() => '${baseOrigin()}/api';
}

Dio dioForApi() {
  return Dio(
    BaseOptions(
      baseUrl: ApiConfig.apiPrefix(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 12),
      sendTimeout: const Duration(seconds: 12),
      headers: const {'Accept': 'application/json'},
      contentType: 'application/json',
    ),
  );
}

final class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);
  final Dio _dio;

  Future<(String token, RegisteredUser profile)> register({
    required String email,
    required String password,
    required String fullName,
    String nickname = '',
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email.trim().toLowerCase(),
        'password': password,
        'fullName': fullName.trim(),
        'nickname': nickname.trim(),
      },
    );
    return _unpack(res.data!);
  }

  Future<(String token, RegisteredUser profile)> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email.trim().toLowerCase(), 'password': password},
    );
    return _unpack(res.data!);
  }

  Future<RegisteredUser> patchProfile({
    required String token,
    required String fullName,
    required String email,
    String nickname = '',
    String newPassword = '',
  }) async {
    final payload = <String, dynamic>{
      'fullName': fullName.trim(),
      'email': email.trim().toLowerCase(),
      'nickname': nickname.trim(),
    };
    if (newPassword.isNotEmpty) {
      payload['password'] = newPassword;
    }
    final res = await _dio.patch<Map<String, dynamic>>(
      '/auth/me',
      data: payload,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final u = res.data!['user']! as Map<String, dynamic>;
    return _personBare(u);
  }

  Future<void> deleteAccountRemote(String token) async {
    await _dio.delete<dynamic>(
      '/auth/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  (String token, RegisteredUser profile) _unpack(Map<String, dynamic> data) {
    final token = data['token']! as String;
    final profile = data['user']! as Map<String, dynamic>;
    return (token, _personBare(profile));
  }

  RegisteredUser _personBare(Map<String, dynamic> u) {
    return RegisteredUser(
      fullName: u['fullName']! as String,
      email: (u['email']! as String).toLowerCase(),
      nickname: (u['nickname'] as String?)?.trim() ?? '',
      passwordHash: '',
      salt: '',
    );
  }
}
