import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/core/errors/failure.dart';

enum ForgetPasswordStatus { idle, loading, success, failure }

class ForgetPasswordState {
  final ForgetPasswordStatus status;
  final String? message;

  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.idle,
    this.message,
  });

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
    String? message,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepository _repository;

  ForgetPasswordCubit(this._repository) : super(const ForgetPasswordState());

  Future<void> resetPassword(String email) async {
    final normalizedEmail = email.trim();

    if (normalizedEmail.isEmpty) {
      emit(
        state.copyWith(
          status: ForgetPasswordStatus.failure,
          message: 'Email is required',
        ),
      );
      return;
    }

    emit(state.copyWith(status: ForgetPasswordStatus.loading));

    try {
      await _repository.resetPassword(normalizedEmail);

      emit(
        state.copyWith(
          status: ForgetPasswordStatus.success,
          message: 'Reset password email sent. Please check your email.',
        ),
      );
    } catch (e) {
      final failure = Failure.fromFirebaseException(e);
      emit(
        state.copyWith(
          status: ForgetPasswordStatus.failure,
          message: failure.message,
        ),
      );
    }
  }
}
