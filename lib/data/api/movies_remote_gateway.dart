import 'package:dio/dio.dart';

import 'package:unik_mobile/domain/catalog/movie.dart';

final class MoviesRemoteGateway {
  MoviesRemoteGateway(this._dio);
  final Dio _dio;

  Future<List<Movie>> fetch(String token) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/movies',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final raw = res.data!['movies']! as List<dynamic>;
    return raw
        .map(
          (dynamic e) => Movie.fromJson(
            Map<String, Object?>.from(e as Map),
          ),
        )
        .toList();
  }
}
