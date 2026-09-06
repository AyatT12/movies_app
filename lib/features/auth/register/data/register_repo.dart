abstract class RegisterRepo {
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
}