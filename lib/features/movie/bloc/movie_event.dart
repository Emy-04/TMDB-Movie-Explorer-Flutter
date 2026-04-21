import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPopularMovies extends MovieEvent {}

class SearchMoviesEvent extends MovieEvent {
  final String query;
  SearchMoviesEvent(this.query);

  @override
  List<Object> get props => [query];
}
