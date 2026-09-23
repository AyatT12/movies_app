import 'profile_entities.dart';

abstract class ProfileRepo {
  Future<UserEntity> getProfile();

  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  });

  Future<void> deleteAccount();

  Future<void> logout();

  Future<List<ProfileMovieEntity>> getWatchList();

  Future<List<ProfileMovieEntity>> getHistory();
}