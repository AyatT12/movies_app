import '../../../home_screen/data/movie_model.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    return await remoteDataSource.searchMovies(query);
  }
}
