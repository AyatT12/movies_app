import '../entities/movie_entity.dart';
import '../repositories/home_repository.dart';

class GetMoviesUseCase {
  final HomeRepository repository;

  GetMoviesUseCase(this.repository);

  Future<List<MovieEntity>> call() async {
    return await repository.getMovies();
  }
}