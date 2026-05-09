import 'package:unik_mobile/core/connectivity/connectivity_service.dart';
import 'package:unik_mobile/domain/auth/auth_networking.dart';
import 'package:unik_mobile/domain/auth/auth_outcome.dart';
import 'package:unik_mobile/domain/auth/password_hasher.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';
import 'package:unik_mobile/domain/user/user_repository.dart';

final class AuthCredentialsFlow {
  AuthCredentialsFlow(this._users, this._net, this._netAuth);

  final UserRepository _users;
  final ConnectivityService _net;
  final AuthNetworking _netAuth;

  Future<({AuthOutcome outcome, RegisteredUser? user})> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    String nickname = '',
  }) async {
    final regErr = RegistrationValidator.firstOf([
      RegistrationValidator.validateFullName(fullName),
      RegistrationValidator.validateEmail(email),
      RegistrationValidator.validatePassword(password),
      RegistrationValidator.validateConfirmPassword(password, confirmPassword),
      if (nickname.trim().isNotEmpty)
        RegistrationValidator.validateNickname(nickname),
    ]);
    if (regErr != null) {
      return (outcome: AuthOutcome.failure(regErr), user: null);
    }
    if (!await _net.checkOnline()) {
      return (
        outcome: AuthOutcome.failure('Internet required to register'),
        user: null,
      );
    }
    final normalizedEmail = email.trim().toLowerCase();
    final pack = await _netAuth.register(
      email: normalizedEmail,
      password: password,
      fullName: fullName,
      nickname: nickname,
    );
    if (pack.error != null) {
      return (outcome: AuthOutcome.failure(pack.error!), user: null);
    }
    final merged = pack.user!;
    await _users.upsertUser(merged);
    await _users.setSessionEmail(merged.email);
    return (outcome: AuthOutcome.success, user: merged);
  }

  Future<({AuthOutcome outcome, RegisteredUser? user})> login({
    required String email,
    required String password,
  }) async {
    final emailErr = RegistrationValidator.validateEmail(email);
    if (emailErr != null) {
      return (outcome: AuthOutcome.failure(emailErr), user: null);
    }
    if (password.isEmpty) {
      return (outcome: AuthOutcome.failure('Enter your password'), user: null);
    }
    final normalizedEmail = email.trim().toLowerCase();
    if (await _net.checkOnline()) {
      final pack = await _netAuth.remoteLogin(
        email: normalizedEmail,
        password: password,
      );
      if (pack.error != null) {
        return (outcome: AuthOutcome.failure(pack.error!), user: null);
      }
      final merged = pack.user!;
      await _users.upsertUser(merged);
      await _users.setSessionEmail(merged.email);
      return (outcome: AuthOutcome.success, user: merged);
    }
    final user = await _users.getStoredUser();
    if (user == null ||
        user.email != normalizedEmail ||
        user.passwordHash.isEmpty) {
      return (
        outcome: AuthOutcome.failure('Online sign-in required at least once'),
        user: null,
      );
    }
    if (!PasswordHasher.verify(password, user.salt, user.passwordHash)) {
      return (
        outcome: AuthOutcome.failure('Invalid email or password'),
        user: null,
      );
    }
    await _users.setSessionEmail(user.email);
    return (outcome: AuthOutcome.success, user: user);
  }
}
