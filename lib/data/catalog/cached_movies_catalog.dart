import 'package:dio/dio.dart';

import 'package:unik_mobile/core/connectivity/connectivity_service.dart';
import 'package:unik_mobile/data/api/movies_remote_gateway.dart';
import 'package:unik_mobile/data/catalog/movies_json_cache.dart';
import 'package:unik_mobile/domain/catalog/movie.dart';
import 'package:unik_mobile/domain/catalog/movies_catalog_repository.dart';
import 'package:unik_mobile/domain/user/user_repository.dart';

final class CachedMoviesCatalog implements MoviesCatalogRepository {
  CachedMoviesCatalog(this._remote, this._cache, this._network, this._users);

  final MoviesRemoteGateway _remote;
  final MoviesJsonCache _cache;
  final ConnectivityService _network;
  final UserRepository _users;

  @override
  Future<List<Movie>> loadPreferRemote() async {
    final online = await _network.checkOnline();
    final user = await _users.getStoredUser();
    final token = user?.accessToken;
    if (online && token != null && token.isNotEmpty) {
      try {
        final movies = await _remote.fetch(token);
        await _cache.save(movies);
        return movies;
      } on DioException catch (_) {}
    }
    final cached = await _cache.load();
    return cached ?? <Movie>[];
  }
}
