# 🎬 TMDB Movie Explorer

A cross-platform Flutter application that lets users browse, search, and save their favorite movies using the [TMDB (The Movie Database) API](https://www.themoviedb.org/).

---

## 📱 Features

- **Browse Popular Movies** — Loads the current trending/popular movies from TMDB on launch
- **Search Movies** — Real-time search by movie title
- **Movie Details** — View detailed info including overview, rating, release date, and runtime
- **Similar Movies** — Discover related movies on the details screen
- **Favorites** — Add/remove movies to a local favorites list
- **Dark / Light Theme** — Toggle between dark and light mode via a switch in the app bar
- **Responsive Grid Layout** — Adapts to mobile, tablet, and desktop screen widths

---

## 🏗️ Architecture

This project follows a **Feature-First Clean Architecture** with **BLoC** state management:

```
lib/
├── core/
│   └── api_constants.dart        # Base URLs and API key
├── features/
│   └── movie/
│       ├── bloc/
│       │   ├── movie_bloc.dart   # Business logic
│       │   ├── movie_event.dart  # Events
│       │   └── movie_state.dart  # States
│       ├── controller/
│       │   └── movie_controller.dart
│       └── views/
│           ├── movie_list_screen.dart
│           ├── movie_details_screen.dart
│           └── movie_favorites_screen.dart
├── models/
│   └── movie_model.dart          # Movie data model
├── services/
│   └── movie_service.dart        # TMDB API calls
├── widgets/
│   └── movie_card.dart           # Reusable movie card widget
└── main.dart
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | flutter_bloc ^9.1.1 |
| HTTP Client | http ^1.6.0 |
| Data Equality | equatable ^2.0.7 |
| API | TMDB REST API v3 |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.8.1`
- A free TMDB API key — [get one here](https://www.themoviedb.org/settings/api)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/movie_app_project.git
cd movie_app_project

# 2. Install dependencies
flutter pub get

# 3. Add your TMDB API key
# Open lib/core/api_constants.dart and replace the placeholder:
static const String apiKey = "YOUR_API_KEY_HERE";

# 4. Run the app
flutter run
```

### Supported Platforms

| Platform | Status |
|---|---|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ |
| Windows | ✅ |
| macOS | ✅ |
| Linux | ✅ |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^9.1.1
  http: ^1.6.0
  equatable: ^2.0.7
  cupertino_icons: ^1.0.8
```

---

## 👤 Author

**Emy Ihab**  
Flutter Developer · Software Engineering Student  
[GitHub](https://github.com/Emy-04) · [LinkedIn](https://linkedin.com/in/emy-ehab/)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
