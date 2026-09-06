import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential> signIn(String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signUp(
    String email,
    String password,
    String name,
    String phone,
    String avatarUrl,
  );
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Stream<User?> get authStateChanges;
}
