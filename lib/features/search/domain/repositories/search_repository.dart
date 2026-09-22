import '../../../home_screen/data/movie_model.dart';

abstract class SearchRepository {
  Future<List<MovieModel>> searchMovies(String query);
}
