import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';

final class SessionCubit extends Cubit<RegisteredUser?> {
  SessionCubit() : super(AppScope.authService.sessionUser);

  void syncFromAuthService() => emit(AppScope.authService.sessionUser);

  Future<void> hydrateFromStoredSession() async {
    await AppScope.authService.isLoggedIn();
    syncFromAuthService();
  }

  Future<void> signOutAndDisconnectMqtt() async {
    await AppScope.authService.logout();
    await AppScope.mqtt.disconnect();
    emit(null);
  }

  Future<void> deleteAccountClearSession() async {
    await AppScope.authService.deleteAccount();
    emit(null);
  }
}
