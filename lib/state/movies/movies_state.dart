import 'package:unik_mobile/domain/catalog/movie.dart';

enum MoviesPhase { idle, loading, ready, error }

final class MoviesCatalogState {
  const MoviesCatalogState({required this.phase, this.items = const <Movie>[]});

  final MoviesPhase phase;
  final List<Movie> items;
}
