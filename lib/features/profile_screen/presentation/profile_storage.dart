import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StoredMovie {
  final int id;
  final String title;
  final String posterUrl;
  final double rating;

  StoredMovie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
  });

  factory StoredMovie.fromJson(Map<String, dynamic> json) {
    return StoredMovie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterUrl': posterUrl,
      'rating': rating,
    };
  }
}

class ProfileMoviesStorage {
  static const String _watchlistKey = 'user_watchlist';
  static const String _historyKey = 'user_history';



  static Future<List<StoredMovie>> getWatchList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_watchlistKey);
    if (data == null || data.isEmpty) return [];
    try {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => StoredMovie.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<bool> isFavorite(int movieId) async {
    final list = await getWatchList();
    return list.any((item) => item.id == movieId);
  }

  static Future<bool> toggleFavorite(StoredMovie movie) async {
    final prefs = await SharedPreferences.getInstance();
    List<StoredMovie> list = await getWatchList();

    final exists = list.any((item) => item.id == movie.id);
    if (exists) {
      list.removeWhere((item) => item.id == movie.id);
    } else {
      list.add(movie);
    }

    final encoded = jsonEncode(list.map((m) => m.toJson()).toList());
    await prefs.setString(_watchlistKey, encoded);
    return !exists;
  }

  static Future<List<StoredMovie>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_historyKey);
    if (data == null || data.isEmpty) return [];
    try {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => StoredMovie.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> addToHistory(StoredMovie movie) async {
    final prefs = await SharedPreferences.getInstance();
    List<StoredMovie> list = await getHistory();


    list.removeWhere((item) => item.id == movie.id);
    list.insert(0, movie);

    final encoded = jsonEncode(list.map((m) => m.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }
}