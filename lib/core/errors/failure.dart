import 'package:firebase_auth/firebase_auth.dart';

class Failure {
  final String message;

  Failure(this.message);

  factory Failure.fromFirebaseException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return Failure('No user found for that email.');
        case 'wrong-password':
          return Failure('Wrong password provided.');
        case 'email-already-in-use':
          return Failure('The account already exists for that email.');
        case 'invalid-email':
          return Failure('The email address is not valid.');
        case 'weak-password':
          return Failure('The password is too weak.');
        case 'invalid-credential':
          return Failure('Invalid email or password.');
        default:
          return Failure(
            e.message ?? 'An unknown authentication error occurred.',
          );
      }
    }
    return Failure(e.toString());
  }
}
