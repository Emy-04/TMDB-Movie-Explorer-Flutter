class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres; 

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres, 
  });

  factory Movie.fromJson(Map<String, dynamic> json) { 
    List<String> genreList = [];
    if (json['genres'] != null) {
      genreList = List<String>.from(
          json['genres'].map((genre) => genre['name'] as String));
    }

    return Movie(
      id: json['id'],
      title: json['title'] ?? "",
      overview: json['overview'] ?? "",
      posterPath: json['poster_path'] ?? "",
      backdropPath: json['backdrop_path'] ?? "",
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? "",
      genres: genreList,
    );
  }
}
