import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../home_screen/data/movie_model.dart';

class SearchRemoteDataSource {
  static const String _movieListUrl =
      'https://movies-api.accel.li/api/v2/list_movies.json';

  Future<List<MovieModel>> searchMovies(String query) async {
    final uri = Uri.parse('$_movieListUrl?query_term=$query');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List list = decoded['data']['movies'] ?? [];
      return list.map((item) => MovieModel.fromJson(item)).toList();
    }
    throw Exception('Failed to search movies: ${response.statusCode}');
  }
}
