import '../../domain/entities/movie_details_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MovieEntity>> getMovies() async {
    final models = await remoteDataSource.getMovies();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<MovieDetailsEntity> getMovieDetails(int movieId) async {
    final model = await remoteDataSource.getMovieDetails(movieId);
    return model.toEntity();
  }
}
