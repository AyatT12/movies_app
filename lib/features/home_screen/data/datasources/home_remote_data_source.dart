import 'dart:convert';
import 'package:http/http.dart' as http;
import '../movie_model.dart';
import '../models/movie_details_model.dart';


class HomeRemoteDataSource {
  static const String _movieListUrl =
      'https://movies-api.accel.li/api/v2/list_movies.json';
  static const String _movieDetailsUrl =
      'https://movies-api.accel.li/api/v2/movie_details.json';
  static const String _movieSuggestionsUrl =
      'https://yts.gg/api/v2/movie_suggestions.json';

  Future<List<MovieModel>> getMovies() async {
    final response = await http.get(Uri.parse(_movieListUrl));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List list = decoded['data']['movies'] ?? [];
      return list.map((item) => MovieModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load movies: ${response.statusCode}');
  }

  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    final uri = Uri.parse('$_movieDetailsUrl?movie_id=$movieId&with_images=true&with_cast=true');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final movieJson = decoded['data']['movie'] ?? {};
      return MovieDetailsModel.fromJson(movieJson);
    }
    throw Exception('Failed to load movie details: ${response.statusCode}');
  }

  Future<List<MovieSuggestionModel>> getMovieSuggestions(int movieId) async {
    final uri = Uri.parse('$_movieSuggestionsUrl?movie_id=$movieId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List list = decoded['data']?['movies'] ?? [];
      return list.map((item) => MovieSuggestionModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load movie suggestions: ${response.statusCode}');
  }
}