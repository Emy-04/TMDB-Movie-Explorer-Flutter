import 'package:flutter/material.dart';
import '../features/movie/views/movie_details_screen.dart';
import '../models/movie_model.dart';
import '../core/api_constants.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final List<Movie>? favorites; // Optional favorites list
  final VoidCallback? onFavoriteToggle; // Optional toggle callback

  const MovieCard({
    super.key,
    required this.movie,
    this.favorites,
    this.onFavoriteToggle,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardGradient = _isHovered
        ? [Colors.redAccent.shade400, Colors.pinkAccent.shade200]
        : [isDark ? Colors.red.shade900 : Colors.red.shade300,
           isDark ? Colors.red.shade700 : Colors.red.shade200];

    final isFavorite = widget.favorites?.contains(widget.movie) ?? false;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => MovieDetailsScreen(
                movieId: widget.movie.id,
                movie: widget.movie,
              ),
            ),
          );
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + _controller.value,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: cardGradient),
                  boxShadow: [
                    BoxShadow(
                      color: cardGradient.last.withOpacity(0.7),
                      blurRadius: _isHovered ? 20 : 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Hero(
                                tag: 'movie_${widget.movie.id}',
                                child: FadeInImage.assetNetwork(
                                  placeholder: "assets/loading.gif",
                                  image: widget.movie.posterPath.isNotEmpty
                                      ? "${ApiConstants.imageBaseUrl}${widget.movie.posterPath}"
                                      : "https://via.placeholder.com/500x750?text=No+Image",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 80,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      isDark
                                          ? Colors.black.withOpacity(0.8)
                                          : Colors.white.withOpacity(0.6)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (widget.onFavoriteToggle != null)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: widget.onFavoriteToggle,
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.redAccent,
                                    size: 28,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: isDark
                            ? Colors.black.withOpacity(0.8)
                            : Colors.white.withOpacity(0.8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  widget.movie.voteAverage.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
