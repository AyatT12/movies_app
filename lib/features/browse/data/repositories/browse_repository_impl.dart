import '../../../home_screen/data/datasources/home_remote_data_source.dart';
import '../../../home_screen/data/movie_model.dart';
import '../../domain/repositories/browse_repository.dart';

class BrowseRepositoryImpl implements BrowseRepository {
  final HomeRemoteDataSource remoteDataSource;

  BrowseRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MovieModel>> getMovies() async {
    return await remoteDataSource.getMovies();
  }
}
