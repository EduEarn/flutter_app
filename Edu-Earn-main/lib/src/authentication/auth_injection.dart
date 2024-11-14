import 'package:edu_earn/src/authentication/data/database/auth_local_database.dart';
import 'package:edu_earn/src/authentication/domain/usecases/login_usecase.dart';
import 'package:edu_earn/src/authentication/domain/usecases/signup_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'data/database/auth_remote_database.dart';
import 'data/repository/auth_repository_impl.dart';
import 'domain/repository/auth_repository.dart';
import 'domain/usecases/get_user_usecase.dart';
import 'domain/usecases/login_with_google_usecase.dart';
import 'presentation/bloc/auth_bloc.dart';

void initAuth() {
  final sl = GetIt.instance;

  sl
    ..registerLazySingleton<AuthRemoteDatabase>(() => AuthRemoteDatabaseImpl())
    ..registerLazySingleton<AuthLocalDatabase>(() => AuthLocalDatabaseImpl(userBox: Hive.box(name: "userInfo")))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
          remoteDatabase: sl(),
          networkInfo: sl(),
          localDatabase: sl(),
        ))
    ..registerLazySingleton<LoginUseCase>(() => LoginUseCase(
          repository: sl(),
        ))
    ..registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(
          repository: sl(),
        ))
    ..registerLazySingleton<ContinueWithGoogleUseCase>(() => ContinueWithGoogleUseCase(
          repository: sl(),
        ))
    ..registerLazySingleton<GetCurrentUserInfo>(() => GetCurrentUserInfo(
          repository: sl(),
        ))
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        login: sl(),
        signUp: sl(),
        continueWithGoogle: sl(),
        getCurrentUserInfo: sl(),
      ),
    );
}
