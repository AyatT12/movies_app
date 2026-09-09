import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthGateStatus { loading, authenticated, unauthenticated }

class AuthGateState {
  final AuthGateStatus status;
  final User? user;

  const AuthGateState({
    required this.status,
    this.user,
  });
}

class AuthGateCubit extends Cubit<AuthGateState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSub;

  AuthGateCubit() : super(const AuthGateState(status: AuthGateStatus.loading)) {
    _authSub = _firebaseAuth.authStateChanges().listen((user) {
      emit(
        user == null
            ? const AuthGateState(status: AuthGateStatus.unauthenticated)
            : AuthGateState(status: AuthGateStatus.authenticated, user: user),
      );
    });
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
