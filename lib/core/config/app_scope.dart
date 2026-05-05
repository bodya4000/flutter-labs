import 'package:unik_mobile/core/config/key_value_storage_factory.dart';
import 'package:unik_mobile/domain/auth/auth_service.dart';
import 'package:unik_mobile/domain/user/local_user_repository.dart';
import 'package:unik_mobile/domain/user/user_repository.dart';

abstract final class AppScope {
  static late final UserRepository userRepository;
  static late final AuthService authService;

  static Future<void> init() async {
    final storage = await KeyValueStorageFactory.create();
    userRepository = LocalUserRepository(storage);
    authService = AuthService(userRepository);
  }
}
