import 'package:unik_mobile/domain/user/registered_user.dart';

abstract interface class UserRepository {
  Future<RegisteredUser?> getStoredUser();

  Future<void> upsertUser(RegisteredUser user);

  Future<void> deleteStoredUser();

  Future<String?> getSessionEmail();

  Future<void> setSessionEmail(String? email);
}
