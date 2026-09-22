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
import 'package:movies_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:movies_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:movies_app/features/search/domain/repositories/search_repository.dart';
import 'package:movies_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:movies_app/features/browse/data/repositories/browse_repository_impl.dart';
import 'package:movies_app/features/browse/domain/repositories/browse_repository.dart';
import 'package:movies_app/features/browse/presentation/bloc/browse_bloc.dart';

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
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(SearchRemoteDataSource()),
  );
  sl.registerFactory<SearchBloc>(() => SearchBloc(sl<SearchRepository>()));
  sl.registerLazySingleton<BrowseRepository>(
    () => BrowseRepositoryImpl(HomeRemoteDataSource()),
  );
  sl.registerFactory<BrowseBloc>(() => BrowseBloc(sl<BrowseRepository>()));
}
