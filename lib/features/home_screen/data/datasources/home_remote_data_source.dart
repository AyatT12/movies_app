import 'dart:convert';
import 'package:http/http.dart' as http;
import '../movie_model.dart';

class HomeRemoteDataSource {
  static const String _url = 'https://movies-api.accel.li/api/v2/list_movies.json';

  Future<List<MovieModel>> getMovies() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List list = decoded['data']['movies'] ?? [];
      return list.map((item) => MovieModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load movies: ${response.statusCode}');
  }
}