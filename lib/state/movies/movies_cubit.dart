import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/domain/catalog/movies_catalog_repository.dart';
import 'package:unik_mobile/state/movies/movies_state.dart';

final class MoviesCubit extends Cubit<MoviesCatalogState> {
  MoviesCubit(this._catalog)
    : super(const MoviesCatalogState(phase: MoviesPhase.idle));

  final MoviesCatalogRepository _catalog;

  Future<void> load() async {
    emit(const MoviesCatalogState(phase: MoviesPhase.loading));
    try {
      final list = await _catalog.loadPreferRemote();
      emit(MoviesCatalogState(phase: MoviesPhase.ready, items: list));
    } on Object {
      emit(const MoviesCatalogState(phase: MoviesPhase.error));
    }
  }
}
