import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_state.dart';
import '../bloc/movie_event.dart';
import '../controller/movie_controller.dart';
import '../../../widgets/movie_card.dart';
import '../../../models/movie_model.dart';

class MovieListScreen extends StatefulWidget {
  final List<Movie> favorites;
  const MovieListScreen({super.key, required this.favorites});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(LoadPopularMovies());

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = MovieController(context.read<MovieBloc>());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputColor = isDark ? Colors.grey.shade900 : Colors.grey.shade200;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search movies...',
                labelStyle: TextStyle(
                  color: isDark ? Colors.red.shade200 : Colors.redAccent,
                ),
                filled: true,
                fillColor: inputColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: isDark ? Colors.red.shade200 : Colors.redAccent,
                  ),
                  onPressed: () => controller.search(_controller.text),
                ),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: isDark ? Colors.red.shade200 : Colors.redAccent,
                      ),
                    );
                  } else if (state is MovieLoaded) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 1000
                            ? 5
                            : MediaQuery.of(context).size.width > 700
                                ? 3
                                : 2,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: state.movies.length,
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        return MovieCard(
                          movie: movie,
                          favorites: widget.favorites,
                          onFavoriteToggle: () {
                            setState(() {
                              if (widget.favorites.contains(movie)) {
                                widget.favorites.remove(movie);
                              } else {
                                widget.favorites.add(movie);
                              }
                            });
                          },
                        );
                      },
                    );
                  } else if (state is MovieError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: isDark ? Colors.red.shade200 : Colors.red,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No movies found.',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
