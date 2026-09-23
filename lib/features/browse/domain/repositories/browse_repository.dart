import '../../../home_screen/data/movie_model.dart';

abstract class BrowseRepository {
  Future<List<MovieModel>> getMovies();
}
