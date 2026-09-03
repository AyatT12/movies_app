abstract class ProfileRepo {
  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  });

  Future<void> deleteAccount();
}