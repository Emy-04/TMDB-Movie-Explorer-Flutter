import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/movie_service.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieService service;

  MovieBloc(this.service) : super(MovieInitial()) {
    on<LoadPopularMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        final movies = await service.fetchPopularMovies();
        emit(MovieLoaded(movies));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });

    on<SearchMoviesEvent>((event, emit) async {
      emit(MovieLoading());
      try {
        final movies = await service.searchMovies(event.query);
        emit(MovieLoaded(movies));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });
  }
}
