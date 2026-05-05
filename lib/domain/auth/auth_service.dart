import 'package:unik_mobile/core/connectivity/connectivity_service.dart';
import 'package:unik_mobile/domain/auth/auth_credentials_flow.dart';
import 'package:unik_mobile/domain/auth/auth_networking.dart';
import 'package:unik_mobile/domain/auth/auth_outcome.dart';
import 'package:unik_mobile/domain/auth/profile_patch_coordinator.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';
import 'package:unik_mobile/domain/user/user_repository.dart';

final class AuthService {
  AuthService(this._users, this._net, this._netAuth)
    : _creds = AuthCredentialsFlow(_users, _net, _netAuth),
      _profilePatch = ProfilePatchCoordinator(_users, _net, _netAuth);

  final UserRepository _users;
  final ConnectivityService _net;
  final AuthNetworking _netAuth;
  final AuthCredentialsFlow _creds;
  final ProfilePatchCoordinator _profilePatch;

  RegisteredUser? _sessionUser;
  RegisteredUser? get sessionUser => _sessionUser;

  Future<bool> isLoggedIn() async {
    final email = await _users.getSessionEmail();
    if (email == null || email.isEmpty) {
      _sessionUser = null;
      return false;
    }
    final user = await _users.getStoredUser();
    if (user == null || user.email != email) {
      _sessionUser = null;
      await _users.setSessionEmail(null);
      return false;
    }
    _sessionUser = user;
    return true;
  }

  Future<void> logout() async {
    final stored = await _users.getStoredUser();
    await _users.setSessionEmail(null);
    if (stored != null) {
      await _users.upsertUser(stored.clearAccessToken());
    }
    _sessionUser = null;
  }

  Future<AuthOutcome> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    String nickname = '',
  }) async {
    final pack = await _creds.register(
      fullName: fullName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      nickname: nickname,
    );
    if (!pack.outcome.isSuccess) {
      return pack.outcome;
    }
    _sessionUser = pack.user!;
    return AuthOutcome.success;
  }

  Future<AuthOutcome> login({
    required String email,
    required String password,
  }) async {
    final pack = await _creds.login(email: email, password: password);
    if (!pack.outcome.isSuccess) {
      return pack.outcome;
    }
    _sessionUser = pack.user!;
    return AuthOutcome.success;
  }

  Future<AuthOutcome> updateProfile({
    required String fullName,
    required String email,
    required String newPassword,
    required String confirmNewPassword,
    String nickname = '',
  }) async {
    final current = _sessionUser ?? await _users.getStoredUser();
    if (current == null) {
      return AuthOutcome.failure('Not signed in');
    }
    final p = await _profilePatch.run(
      current: current,
      fullName: fullName,
      email: email,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
      nickname: nickname,
    );
    if (p.outcome.isSuccess) {
      _sessionUser = p.user!;
    }
    return p.outcome;
  }

  Future<void> deleteAccount() async {
    final current = _sessionUser ?? await _users.getStoredUser();
    if (await _net.checkOnline() &&
        current?.accessToken != null &&
        current!.accessToken!.isNotEmpty) {
      try {
        await _netAuth.deleteRemote(current.accessToken!);
      } catch (_) {}
    }
    await _users.deleteStoredUser();
    _sessionUser = null;
  }
}
