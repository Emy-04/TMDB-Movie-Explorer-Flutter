import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/movie/bloc/movie_bloc.dart';
import 'features/movie/views/movie_list_screen.dart';
import 'features/movie/views/movie_favorites_screen.dart';
import 'services/movie_service.dart';
import 'models/movie_model.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TMDB Movie App',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color.fromARGB(255, 0, 0, 0),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
            primaryColor: Colors.red.shade400,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey.shade900,
            ),
          ),
          themeMode: currentTheme,
          home: BlocProvider(
            create: (_) => MovieBloc(MovieService()),
            child: MovieListScreenWithTheme(themeNotifier: themeNotifier),
          ),
        );
      },
    );
  }
}

class MovieListScreenWithTheme extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  const MovieListScreenWithTheme({super.key, required this.themeNotifier});

  @override
  State<MovieListScreenWithTheme> createState() =>
      _MovieListScreenWithThemeState();
}

class _MovieListScreenWithThemeState extends State<MovieListScreenWithTheme> {
  final List<Movie> favorites = []; // Holds favorite movies

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 TMDB Movie Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Color.fromARGB(255, 36, 24, 172)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FavoritesScreen(favoriteMovies: favorites),
                ),
              );
            },
          ),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: widget.themeNotifier,
            builder: (context, currentTheme, child) {
              return Switch(
                activeColor: Colors.white,
                value: currentTheme == ThemeMode.dark,
                onChanged: (val) {
                  setState(() {
                    widget.themeNotifier.value =
                        val ? ThemeMode.dark : ThemeMode.light;
                  });
                },
              );
            },
          ),
        ],
      ),
      body: MovieListScreen(favorites: favorites),
    );
  }
}
