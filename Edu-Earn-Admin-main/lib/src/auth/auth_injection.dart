import 'package:get_it/get_it.dart';

import 'data/database/auth_remote_database.dart';
import 'data/repository/auth_repository_impl.dart';
import 'domain/repository/auth_repository.dart';
import 'domain/usecase/login_usecase.dart';
import 'domain/usecase/login_with_google_usecase.dart';
import 'domain/usecase/signup_usecase.dart';

import 'presentation/bloc/auth_bloc.dart';

void initAuth() {
  final sl = GetIt.instance;

  sl
    ..registerLazySingleton<AuthRemoteDatabase>(() => AuthRemoteDatabaseImpl())
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
          remoteDatabase: sl(),
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
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        login: sl(),
        signUp: sl(),
        continueWithGoogle: sl(),
      ),
    );
}
