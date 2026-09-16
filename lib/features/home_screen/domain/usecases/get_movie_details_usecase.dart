import '../entities/movie_details_entity.dart';
import '../repositories/home_repository.dart';

class GetMovieDetailsUseCase {
  final HomeRepository repository;

  GetMovieDetailsUseCase(this.repository);

  Future<MovieDetailsEntity> call(int movieId) async {
    return await repository.getMovieDetails(movieId);
  }
}
