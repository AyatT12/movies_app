import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserCredential> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await _firebaseAuth.signInWithCredential(
      credential,
    );

    if (userCredential.additionalUserInfo?.isNewUser == true) {
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': userCredential.user!.displayName ?? '',
        'email': userCredential.user!.email ?? '',
        'phone': userCredential.user!.phoneNumber ?? '',
        'avatarUrl': userCredential.user!.photoURL ?? '',
        'uid': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return userCredential;
  }

  @override
  Future<UserCredential> signUp(
    String email,
    String password,
    String name,
    String phone,
    String avatarUrl,
  ) async {
    UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    if (credential.user != null) {
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'avatarUrl': avatarUrl,
        'uid': credential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
