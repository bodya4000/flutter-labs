import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/state/auth_gate/auth_gate_view_state.dart';

final class AuthGateCubit extends Cubit<AuthGateViewState> {
  AuthGateCubit() : super(const AuthGateViewState(AuthGatePhase.loading));

  bool _warnOfflineDashboard = false;

  Future<void> bootstrap() async {
    emit(const AuthGateViewState(AuthGatePhase.loading));
    final loggedIn = await AppScope.authService.isLoggedIn();
    final online = await AppScope.connectivity.checkOnline();
    final pinActive = await AppScope.devicePinVault.hasConfiguredPin();
    _warnOfflineDashboard = !online;
    if (!loggedIn) {
      emit(const AuthGateViewState(AuthGatePhase.login));
      return;
    }
    if (pinActive) {
      emit(
        AuthGateViewState(
          AuthGatePhase.pin,
          warnOfflineDashboard: _warnOfflineDashboard,
        ),
      );
      return;
    }
    emit(
      AuthGateViewState(
        AuthGatePhase.home,
        warnOfflineDashboard: _warnOfflineDashboard,
      ),
    );
  }

  void onPinUnlocked() {
    emit(
      AuthGateViewState(
        AuthGatePhase.home,
        warnOfflineDashboard: _warnOfflineDashboard,
      ),
    );
  }

  void restartGate() {
    unawaited(bootstrap());
  }
}
