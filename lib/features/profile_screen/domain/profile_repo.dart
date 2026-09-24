import 'profile_entities.dart';

abstract class ProfileRepo {
  Future<UserEntity> getProfile();

  Future<Map<String, dynamic>?> getUserData();

  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  });

  Future<void> updateProfileWithUrl({
    required String name,
    required String phone,
    required String avatarUrl,
  });

  Future<void> deleteAccount();

  Future<void> logout();

  Future<void> toggleWatchList(ProfileMovieEntity movie);

  Future<bool> isMovieInWatchList(String movieId);

  Future<List<ProfileMovieEntity>> getWatchList();

  Stream<List<ProfileMovieEntity>> getWatchListStream();

  Future<void> addToHistory(ProfileMovieEntity movie);

  Future<List<ProfileMovieEntity>> getHistory();

  Stream<List<ProfileMovieEntity>> getHistoryStream();
}