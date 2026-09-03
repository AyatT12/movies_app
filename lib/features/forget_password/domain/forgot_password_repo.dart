abstract class ForgotPasswordRepo {
  Future<void> sendResetEmail({required String email});
}