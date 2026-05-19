import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/domain/auth/auth_service.dart';
import 'package:unik_mobile/state/session/session_cubit.dart';

final class LoginCubit extends Cubit<bool> {
  LoginCubit(this._auth, this._sessionCubit) : super(false);

  final AuthService _auth;
  final SessionCubit _sessionCubit;

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    emit(true);
    final outcome = await _auth.login(email: email, password: password);
    emit(false);
    if (!outcome.isSuccess) {
      return outcome.errorMessage ?? 'Sign in failed';
    }
    _sessionCubit.syncFromAuthService();
    return null;
  }
}
