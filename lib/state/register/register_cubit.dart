import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/core/connectivity/connectivity_service.dart';
import 'package:unik_mobile/domain/auth/auth_service.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';
import 'package:unik_mobile/state/register/register_models.dart';
import 'package:unik_mobile/state/session/session_cubit.dart';

final class RegisterCubit extends Cubit<RegisterRunning> {
  RegisterCubit(this._auth, this._connectivity, this._session)
    : super(RegisterRunning(busy: false));

  final AuthService _auth;
  final ConnectivityService _connectivity;
  final SessionCubit _session;

  Future<RegisterEnd> submit({
    required String fullName,
    required String email,
    required String nickname,
    required String password,
    required String confirm,
  }) async {
    final nicknameErr = RegistrationValidator.firstOf([
      if (nickname.trim().isNotEmpty)
        RegistrationValidator.validateNickname(nickname),
    ]);
    final nameErr = RegistrationValidator.validateFullName(fullName);
    final emailErr = RegistrationValidator.validateEmail(email);
    final pwdErr = RegistrationValidator.validatePassword(password);
    final matchErr = RegistrationValidator.validateConfirmPassword(
      password,
      confirm,
    );
    final errs = RegisterFieldErrors(
      name: nameErr,
      email: emailErr,
      nickname: nicknameErr,
      password: pwdErr,
      confirm: matchErr,
    );
    emit(RegisterRunning(busy: false, lastErrors: errs));
    if (errs.hasAny) {
      return RegisterEndValidation(errs);
    }
    final online = await _connectivity.checkOnline();
    if (!online) {
      return RegisterEndOffline();
    }
    emit(RegisterRunning(busy: true));
    final outcome = await _auth.register(
      fullName: fullName,
      email: email,
      password: password,
      confirmPassword: confirm,
      nickname: nickname,
    );
    emit(RegisterRunning(busy: false));
    if (outcome.isSuccess) {
      _session.syncFromAuthService();
      return RegisterEndSuccess();
    }
    return RegisterEndFailure(outcome.errorMessage ?? 'Registration failed');
  }
}
