import 'package:unik_mobile/core/config/key_value_storage_factory.dart';
import 'package:unik_mobile/core/connectivity/connectivity_service.dart';
import 'package:unik_mobile/core/mqtt/mqtt_service.dart';
import 'package:unik_mobile/data/api/api_clients.dart';
import 'package:unik_mobile/data/api/movies_remote_gateway.dart';
import 'package:unik_mobile/data/catalog/cached_movies_catalog.dart';
import 'package:unik_mobile/data/catalog/movies_json_cache.dart';
import 'package:unik_mobile/data/device/key_value_device_pin_vault.dart';
import 'package:unik_mobile/domain/auth/auth_networking.dart';
import 'package:unik_mobile/domain/auth/auth_service.dart';
import 'package:unik_mobile/domain/catalog/movies_catalog_repository.dart';
import 'package:unik_mobile/domain/device/device_pin_vault.dart';
import 'package:unik_mobile/domain/user/local_user_repository.dart';
import 'package:unik_mobile/domain/user/user_repository.dart';

abstract final class AppScope {
  static late UserRepository userRepository;
  static late ConnectivityService connectivity;
  static late AuthService authService;
  static late DevicePinVault devicePinVault;
  static late MoviesCatalogRepository moviesCatalog;
  static late MqttService mqtt;

  static Future<void> init() async {
    final storage = await KeyValueStorageFactory.create();
    userRepository = LocalUserRepository(storage);
    connectivity = ConnectivityService();
    final dio = dioForApi();
    final authRemote = AuthRemoteDataSource(dio);
    final authNet = AuthNetworking(authRemote);
    authService = AuthService(userRepository, connectivity, authNet);
    devicePinVault = KeyValueDevicePinVault(storage);
    moviesCatalog = CachedMoviesCatalog(
      MoviesRemoteGateway(dio),
      MoviesJsonCache(storage),
      connectivity,
      userRepository,
    );
    mqtt = MqttService();
  }
}
