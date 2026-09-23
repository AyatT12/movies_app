import '../domain/profile_repo.dart';
import '../domain/profile_entities.dart';
import 'profile_data_sources.dart';


class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> getProfile() async {
    final model = await remoteDataSource.getProfile();
    return UserEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      phone: model.phone,
      avatarIndex: model.avatarIndex,
    );
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {
    await remoteDataSource.updateProfile(
      name: name,
      phone: phone,
      avatarIndex: avatarIndex,
    );
  }

  @override
  Future<void> deleteAccount() async {
    await remoteDataSource.deleteAccount();
    await localDataSource.clearUserSession();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUserSession();
  }

  @override
  Future<List<ProfileMovieEntity>> getWatchList() async {
    final list = await remoteDataSource.getWatchList();
    return list
        .map((model) => ProfileMovieEntity(
      id: model.id,
      title: model.title,
      posterUrl: model.posterUrl,
      rating: model.rating,
    ))
        .toList();
  }

  @override
  Future<List<ProfileMovieEntity>> getHistory() async {
    final list = await localDataSource.getHistory();
    return list
        .map((model) => ProfileMovieEntity(
      id: model.id,
      title: model.title,
      posterUrl: model.posterUrl,
      rating: model.rating,
    ))
        .toList();
  }
}