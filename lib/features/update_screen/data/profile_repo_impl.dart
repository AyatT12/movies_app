import '../domain/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {

  }

  @override
  Future<void> deleteAccount() async {

  }
}