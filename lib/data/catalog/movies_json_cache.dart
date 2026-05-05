import 'dart:convert';

import 'package:unik_mobile/core/storage/key_value_storage.dart';
import 'package:unik_mobile/domain/catalog/movie.dart';

final class MoviesJsonCache {
  MoviesJsonCache(this._storage);
  final KeyValueStorage _storage;
  static const String _key = 'lab5_movies_cache_v1';

  Future<void> save(List<Movie> list) async {
    final enc = jsonEncode(list.map((e) => e.toJson()).toList());
    await _storage.writeString(_key, enc);
  }

  Future<List<Movie>?> load() async {
    final raw = await _storage.readString(_key);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((dynamic e) {
      return Movie.fromJson(Map<String, Object?>.from(e as Map));
    }).toList();
  }
}
