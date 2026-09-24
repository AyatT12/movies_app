import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_app/core/utils/app_assets.dart';

import '../domain/profile_entities.dart';
import '../domain/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserEntity> getProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data();

    return UserEntity(
      id: user.uid,
      name: data?['name'] ?? user.displayName ?? '',
      phone: data?['phone'] ?? user.phoneNumber ?? '',
      email: user.email ?? '',
      avatarIndex: data?['avatarIndex'] ?? 0,
    );
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data();

    if (doc.exists && data != null) {
      return {
        'name': data['name'] ?? user.displayName ?? '',
        'phone': data['phone'] ?? user.phoneNumber ?? '',
        'avatarUrl': data['avatarUrl'],
        'email': user.email ?? '',
      };
    }

    return {
      'name': user.displayName ?? '',
      'phone': user.phoneNumber ?? '',
      'avatarUrl': null,
      'email': user.email ?? '',
    };
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    await user.updateDisplayName(name);

    final avatarUrl = (avatarIndex >= 0 && avatarIndex < AppAssets.avatars.length)
        ? AppAssets.avatars[avatarIndex]
        : AppAssets.avatars[0];

    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'phone': phone,
      'avatarIndex': avatarIndex,
      'avatarUrl': avatarUrl,
      'email': user.email,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> updateProfileWithUrl({
    required String name,
    required String phone,
    required String avatarUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    await user.updateDisplayName(name);

    int avatarIndex = AppAssets.avatars.indexOf(avatarUrl);
    if (avatarIndex == -1) avatarIndex = 0;

    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'avatarIndex': avatarIndex,
      'email': user.email,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    await _firestore.collection('users').doc(user.uid).delete();
    await user.delete();
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<void> toggleWatchList(ProfileMovieEntity movie) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .doc(movie.id);

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'posterUrl': movie.posterUrl,
        'rating': movie.rating,
        'title': movie.title,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<bool> isMovieInWatchList(String movieId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .doc(movieId)
        .get();

    return doc.exists;
  }

  @override
  Future<List<ProfileMovieEntity>> getWatchList() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ProfileMovieEntity(
        id: doc.id,
        posterUrl: data['posterUrl'] ?? '',
        rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
        title: data['title'] ?? '',
      );
    }).toList();
  }

  @override
  Stream<List<ProfileMovieEntity>> getWatchListStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return ProfileMovieEntity(
        id: doc.id,
        posterUrl: data['posterUrl'] ?? '',
        rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
        title: data['title'] ?? '',
      );
    }).toList());
  }

  @override
  Future<void> addToHistory(ProfileMovieEntity movie) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .doc(movie.id)
        .set({
      'posterUrl': movie.posterUrl,
      'rating': movie.rating,
      'title': movie.title,
      'viewedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<List<ProfileMovieEntity>> getHistory() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .orderBy('viewedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ProfileMovieEntity(
        id: doc.id,
        posterUrl: data['posterUrl'] ?? '',
        rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
        title: data['title'] ?? '',
      );
    }).toList();
  }

  @override
  Stream<List<ProfileMovieEntity>> getHistoryStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .orderBy('viewedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return ProfileMovieEntity(
        id: doc.id,
        posterUrl: data['posterUrl'] ?? '',
        rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
        title: data['title'] ?? '',
      );
    }).toList());
  }
}