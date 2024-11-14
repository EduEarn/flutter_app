import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/job_application.dart';
import '../../domain/usecases/apply_job_usecase.dart';
import '../../domain/usecases/fetch_jobs.dart';

part 'job_application_event.dart';

part 'job_application_state.dart';

class JobApplicationBloc extends Bloc<JobApplicationEvent, JobApplicationState> {
  final ApplyForJob _applyForJob;
  final FetchJobApplications _fetchJobApplications;

  JobApplicationBloc({required ApplyForJob applyForJob, required FetchJobApplications fetchJobApplications})
      : _applyForJob = applyForJob,
        _fetchJobApplications = fetchJobApplications,
        super(JobApplicationInitial()) {
    // on<JobApplicationEvent>((event, emit) => emit(JobApplicationLoading()));
    on<JobApplied>((event, emit) async {
      final res = await _applyForJob(JobApplicationParams(jobApplication: event.jobApplication));
      return res.fold(
          (failure) => emit(JobApplicationFailure(failure.message)), (success) => emit(JobApplicationSuccess()));
    });

    on<JobApplicationFetched>((event, emit) async {
      // emit(JobApplicationLoading());
      final res = await _fetchJobApplications(FetchJobsParams(userId: event.userId));

      return res.fold((failure) => emit(JobApplicationFailure(failure.message)),
          (applications) => emit(JobApplicationLoaded(jobApplication: applications)));
    });
  }
}
