import 'profile_repo.dart';
import 'profile_entities.dart';

class GetProfileUseCase {
  final ProfileRepo repository;
  GetProfileUseCase(this.repository);
  Future<UserEntity> call() => repository.getProfile();
}

class UpdateProfileUseCase {
  final ProfileRepo repository;
  UpdateProfileUseCase(this.repository);
  Future<void> call({
    required String name,
    required String phone,
    required int avatarIndex,
  }) {
    return repository.updateProfile(
      name: name,
      phone: phone,
      avatarIndex: avatarIndex,
    );
  }
}

class DeleteAccountUseCase {
  final ProfileRepo repository;
  DeleteAccountUseCase(this.repository);
  Future<void> call() => repository.deleteAccount();
}

class LogoutUseCase {
  final ProfileRepo repository;
  LogoutUseCase(this.repository);
  Future<void> call() => repository.logout();
}

class GetWatchListUseCase {
  final ProfileRepo repository;
  GetWatchListUseCase(this.repository);
  Future<List<ProfileMovieEntity>> call() => repository.getWatchList();
}

class GetHistoryUseCase {
  final ProfileRepo repository;
  GetHistoryUseCase(this.repository);
  Future<List<ProfileMovieEntity>> call() => repository.getHistory();
}