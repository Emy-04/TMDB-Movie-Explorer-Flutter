import 'package:flutter/material.dart';
import 'package:movie_app_project/widgets/movie_card.dart';
import '../../../models/movie_model.dart';
import '../../../core/api_constants.dart';
import '../../../services/movie_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
    required this.movie,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen>
    with SingleTickerProviderStateMixin {
  late Future<Movie> movieDetails;
  late Future<List<Movie>> similarMovies;
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    movieDetails = MovieService().fetchMovieDetails(widget.movieId);
    similarMovies = MovieService().fetchSimilarMovies(widget.movieId);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildGenreChips(List<String> genres) {
    return Wrap(
      spacing: 6,
      children: genres.map((genre) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.redAccent.shade700, Colors.pinkAccent.shade400],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            genre,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRating(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.amber.shade700, Colors.orangeAccent.shade700],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.6),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Movie>(
        future: movieDetails,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }
          final movie = snapshot.data!;

          return Stack(
            children: [
              // Backdrop Image
              Hero(
                tag: 'movie_${movie.id}',
                child: Image.network(
                  "${ApiConstants.imageBaseUrl}${movie.backdropPath.isNotEmpty ? movie.backdropPath : movie.posterPath}",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
              ),

              // Main Content
              FadeTransition(
                opacity: _fadeIn,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                      const SizedBox(height: 180),

                      // Movie Title
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Rating & Release
                      Row(
                        children: [
                          _buildRating(movie.voteAverage),
                          const SizedBox(width: 16),
                          Text(
                            movie.releaseDate,
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Genres
                      FutureBuilder<Movie>(
                        future: movieDetails,
                        builder: (context, snap) {
                          if (!snap.hasData) return const SizedBox();
                          final genres = snap.data!.genres;
                          return _buildGenreChips(genres);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Overview
                      const Text(
                        "Overview",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview.isNotEmpty
                            ? movie.overview
                            : "No overview available.",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Similar Movies Carousel
                      const Text(
                        "Similar Movies",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: FutureBuilder<List<Movie>>(
                          future: similarMovies,
                          builder: (context, snap) {
                            if (!snap.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator(color: Colors.redAccent));
                            }
                            final similar = snap.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: similar.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 140,
                                  child: MovieCard(movie: similar[index]),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
