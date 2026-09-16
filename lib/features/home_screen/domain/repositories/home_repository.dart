import '../entities/movie_details_entity.dart';
import '../entities/movie_entity.dart';

abstract class HomeRepository {
  Future<List<MovieEntity>> getMovies();
  Future<MovieDetailsEntity> getMovieDetails(int movieId);
  Future<List<MovieSuggestionEntity>> getMovieSuggestions(int movieId);
}