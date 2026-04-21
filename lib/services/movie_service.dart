import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';
import '../core/api_constants.dart';

class MovieService {
  final String apiKey = ApiConstants.apiKey;

  Future<List<Movie>> fetchPopularMovies() async {
    final url =
        "${ApiConstants.baseUrl}/movie/popular?api_key=$apiKey&language=en-US&page=1";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Movie>.from(
          data['results'].map((movie) => Movie.fromJson(movie)));
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url =
        "${ApiConstants.baseUrl}/search/movie?api_key=$apiKey&language=en-US&query=$query&page=1";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Movie>.from(
          data['results'].map((movie) => Movie.fromJson(movie)));
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<Movie> fetchMovieDetails(int movieId) async {
    final url =
        "${ApiConstants.baseUrl}/movie/$movieId?api_key=$apiKey&language=en-US";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Movie.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }

  Future<List<Movie>> fetchSimilarMovies(int movieId) async {
    final url =
        "${ApiConstants.baseUrl}/movie/$movieId/similar?api_key=$apiKey&language=en-US&page=1";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Movie>.from(
          data['results'].map((movie) => Movie.fromJson(movie)));
    } else {
      throw Exception('Failed to fetch similar movies');
    }
  }
}
