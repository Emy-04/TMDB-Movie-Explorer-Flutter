import 'package:flutter/material.dart';
import '../../../models/movie_model.dart';
import '../../../widgets/movie_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Movie> favoriteMovies;
  const FavoritesScreen({super.key, required this.favoriteMovies});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('❤️ Favorites'),
      ),
      body: favoriteMovies.isEmpty
          ? Center(
              child: Text(
                "No favorite movies yet!",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 18,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).size.width > 1000
                        ? 5
                        : MediaQuery.of(context).size.width > 700
                            ? 3
                            : 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) =>
                  MovieCard(
                    movie: favoriteMovies[index],
                    favorites: favoriteMovies,
                    onFavoriteToggle: () {
                      favoriteMovies.remove(favoriteMovies[index]);
                      (context as Element).markNeedsBuild();
                    },
                  ),
            ),
    );
  }
}
