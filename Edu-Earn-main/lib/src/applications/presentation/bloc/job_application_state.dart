part of 'job_application_bloc.dart';

@immutable
sealed class JobApplicationState {}

final class JobApplicationInitial extends JobApplicationState {}

final class JobApplicationSuccess extends JobApplicationState {}

final class JobApplicationLoaded extends JobApplicationState {
  final List<JobApplication> jobApplication;

  JobApplicationLoaded({required this.jobApplication});
}

final class JobApplicationFailure extends JobApplicationState {
  final String message;

  JobApplicationFailure(this.message);
}

final class JobApplicationLoading extends JobApplicationState {}
