import 'package:unik_mobile/core/connectivity/connectivity_service.dart';
import 'package:unik_mobile/domain/auth/auth_networking.dart';
import 'package:unik_mobile/domain/auth/auth_outcome.dart';
import 'package:unik_mobile/domain/auth/password_hasher.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';
import 'package:unik_mobile/domain/user/user_repository.dart';

final class ProfilePatchCoordinator {
  ProfilePatchCoordinator(this._users, this._net, this._netAuth);

  final UserRepository _users;
  final ConnectivityService _net;
  final AuthNetworking _netAuth;

  Future<({AuthOutcome outcome, RegisteredUser? user})> run({
    required RegisteredUser current,
    required String fullName,
    required String email,
    required String newPassword,
    required String confirmNewPassword,
    String nickname = '',
  }) async {
    final err = RegistrationValidator.firstOf([
      RegistrationValidator.validateFullName(fullName),
      RegistrationValidator.validateEmail(email),
      RegistrationValidator.validateOptionalNewPassword(
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      ),
      if (nickname.trim().isNotEmpty)
        RegistrationValidator.validateNickname(nickname),
    ]);
    if (err != null) {
      return (outcome: AuthOutcome.failure(err), user: null);
    }
    final normalizedEmail = email.trim().toLowerCase();
    final tok = current.accessToken;
    RegisteredUser next = current.copyWith(
      fullName: fullName.trim(),
      email: normalizedEmail,
      nickname: nickname.trim(),
    );
    if (await _net.checkOnline() && tok != null && tok.isNotEmpty) {
      final pack = await _netAuth.patchProfile(
        token: tok,
        fullName: fullName,
        email: email,
        nickname: nickname,
        newPassword: newPassword,
      );
      if (pack.error != null) {
        return (outcome: AuthOutcome.failure(pack.error!), user: null);
      }
      next = pack.user!.copyWith(
        accessToken: tok,
        passwordHash: current.passwordHash,
        salt: current.salt,
      );
    }
    if (newPassword.isNotEmpty) {
      final salt = PasswordHasher.generateSalt();
      next = next.copyWith(
        passwordHash: PasswordHasher.hash(newPassword, salt),
        salt: salt,
      );
    }
    await _users.upsertUser(next);
    await _users.setSessionEmail(next.email);
    return (outcome: AuthOutcome.success, user: next);
  }
}
