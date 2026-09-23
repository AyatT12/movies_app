import 'package:movies_app/features/profile_screen/data/profile_-models.dart';


abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();

  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  });

  Future<void> deleteAccount();

  Future<List<ProfileMovieModel>> getWatchList();
}

abstract class ProfileLocalDataSource {
  Future<void> clearUserSession();

  Future<List<ProfileMovieModel>> getHistory();

  Future<void> saveToHistory(ProfileMovieModel movie);
}