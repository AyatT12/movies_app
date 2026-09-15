import 'package:get_it/get_it.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movies_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:movies_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:movies_app/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_gate_cubit.dart';
import 'package:movies_app/features/home_screen/data/datasources/home_remote_data_source.dart';
import 'package:movies_app/features/home_screen/data/repositories/home_repository_impl.dart';
import 'package:movies_app/features/home_screen/domain/repositories/home_repository.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(sl<AuthRepository>()),
  );
  sl.registerFactory<AuthGateCubit>(() => AuthGateCubit());
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(HomeRemoteDataSource()),
  );
}
