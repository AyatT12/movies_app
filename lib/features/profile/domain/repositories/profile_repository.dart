abstract class ProfileRepository {
  Future<void> updateProfile(String name, String phone, String avatarUrl);
  Future<void> deleteAccount();
  Future<Map<String, dynamic>?> getUserData();
}
