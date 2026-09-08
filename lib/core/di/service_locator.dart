import 'package:get_it/get_it.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movies_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:movies_app/features/profile/data/repositories/profile_repository_impl.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
}
