import 'package:edu_earn/src/applications/data/database/job_application_remote_database.dart';
import 'package:edu_earn/src/applications/data/repository/job_application_repository_impl.dart';
import 'package:edu_earn/src/applications/domain/repository/job_application_repository.dart';
import 'package:edu_earn/src/applications/presentation/bloc/job_application_bloc.dart';
import 'package:get_it/get_it.dart';

import 'domain/usecases/apply_job_usecase.dart';
import 'domain/usecases/fetch_jobs.dart';

void initJobApplication() {
  final sl = GetIt.instance;

  sl
    ..registerLazySingleton<JobApplicationRemoteDatabase>(() => JobApplicationRemoteDatabaseImpl())
    ..registerLazySingleton<JobApplicationRepository>(() => JobApplicationRepositoryImpl(remoteDatabase: sl()))
    ..registerLazySingleton<ApplyForJob>(() => ApplyForJob(repository: sl()))
    ..registerLazySingleton<FetchJobApplications>(() => FetchJobApplications(repository: sl()))
    ..registerFactory<JobApplicationBloc>(() => JobApplicationBloc(applyForJob: sl(), fetchJobApplications: sl()));
}
