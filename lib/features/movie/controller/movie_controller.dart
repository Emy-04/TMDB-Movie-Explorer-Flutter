import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';

class MovieController {
  final MovieBloc bloc;

  MovieController(this.bloc);

  void loadPopular() => bloc.add(LoadPopularMovies());
  void search(String query) => bloc.add(SearchMoviesEvent(query));
}
