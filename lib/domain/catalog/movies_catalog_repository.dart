import 'package:unik_mobile/domain/catalog/movie.dart';

abstract interface class MoviesCatalogRepository {
  Future<List<Movie>> loadPreferRemote();
}
