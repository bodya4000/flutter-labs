import 'package:unik_mobile/domain/auth/password_hasher.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';
import 'package:unik_mobile/domain/user/user_repository.dart';

final class AuthOutcome {
  const AuthOutcome._({this.errorMessage});

  final String? errorMessage;

  bool get isSuccess => errorMessage == null;

  static const AuthOutcome success = AuthOutcome._();

  factory AuthOutcome.failure(String message) =>
      AuthOutcome._(errorMessage: message);
}

final class AuthService {
  AuthService(this._repository);

  final UserRepository _repository;

  RegisteredUser? _sessionUser;

  RegisteredUser? get sessionUser => _sessionUser;

  Future<bool> isLoggedIn() async {
    final email = await _repository.getSessionEmail();
    if (email == null || email.isEmpty) {
      _sessionUser = null;
      return false;
    }
    final user = await _repository.getStoredUser();
    if (user == null || user.email != email) {
      _sessionUser = null;
      await _repository.setSessionEmail(null);
      return false;
    }
    _sessionUser = user;
    return true;
  }

  Future<AuthOutcome> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final nameErr = RegistrationValidator.validateFullName(fullName);
    if (nameErr != null) {
      return AuthOutcome.failure(nameErr);
    }
    final emailErr = RegistrationValidator.validateEmail(email);
    if (emailErr != null) {
      return AuthOutcome.failure(emailErr);
    }
    final pwdErr = RegistrationValidator.validatePassword(password);
    if (pwdErr != null) {
      return AuthOutcome.failure(pwdErr);
    }
    final matchErr = RegistrationValidator.validateConfirmPassword(
      password,
      confirmPassword,
    );
    if (matchErr != null) {
      return AuthOutcome.failure(matchErr);
    }
    final normalizedEmail = email.trim().toLowerCase();
    final existing = await _repository.getStoredUser();
    if (existing != null) {
      return AuthOutcome.failure(
        'An account already exists on this device. '
        'Sign in or delete it first.',
      );
    }
    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hash(password, salt);
    final user = RegisteredUser(
      fullName: fullName.trim(),
      email: normalizedEmail,
      passwordHash: hash,
      salt: salt,
    );
    await _repository.upsertUser(user);
    await _repository.setSessionEmail(user.email);
    _sessionUser = user;
    return AuthOutcome.success;
  }

  Future<AuthOutcome> login({
    required String email,
    required String password,
  }) async {
    final emailErr = RegistrationValidator.validateEmail(email);
    if (emailErr != null) {
      return AuthOutcome.failure(emailErr);
    }
    if (password.isEmpty) {
      return AuthOutcome.failure('Enter your password');
    }
    final normalizedEmail = email.trim().toLowerCase();
    final user = await _repository.getStoredUser();
    if (user == null || user.email != normalizedEmail) {
      return AuthOutcome.failure('Invalid email or password');
    }
    if (!PasswordHasher.verify(password, user.salt, user.passwordHash)) {
      return AuthOutcome.failure('Invalid email or password');
    }
    await _repository.setSessionEmail(user.email);
    _sessionUser = user;
    return AuthOutcome.success;
  }

  Future<void> logout() async {
    await _repository.setSessionEmail(null);
    _sessionUser = null;
  }

  Future<AuthOutcome> updateProfile({
    required String fullName,
    required String email,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final current = _sessionUser ?? await _repository.getStoredUser();
    if (current == null) {
      return AuthOutcome.failure('Not signed in');
    }
    final nameErr = RegistrationValidator.validateFullName(fullName);
    if (nameErr != null) {
      return AuthOutcome.failure(nameErr);
    }
    final emailErr = RegistrationValidator.validateEmail(email);
    if (emailErr != null) {
      return AuthOutcome.failure(emailErr);
    }
    final pwdBundleErr = RegistrationValidator.validateOptionalNewPassword(
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
    if (pwdBundleErr != null) {
      return AuthOutcome.failure(pwdBundleErr);
    }
    final normalizedEmail = email.trim().toLowerCase();
    RegisteredUser updated = current.copyWith(
      fullName: fullName.trim(),
      email: normalizedEmail,
    );
    if (newPassword.isNotEmpty) {
      final salt = PasswordHasher.generateSalt();
      updated = updated.copyWith(
        salt: salt,
        passwordHash: PasswordHasher.hash(newPassword, salt),
      );
    }
    await _repository.upsertUser(updated);
    await _repository.setSessionEmail(updated.email);
    _sessionUser = updated;
    return AuthOutcome.success;
  }

  Future<void> deleteAccount() async {
    await _repository.deleteStoredUser();
    _sessionUser = null;
  }
}
