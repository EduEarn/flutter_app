part of 'job_application_bloc.dart';

@immutable
sealed class JobApplicationEvent {}

final class JobApplied extends JobApplicationEvent {
  final JobApplication jobApplication;

  JobApplied({required this.jobApplication});
}

final class JobApplicationFetched extends JobApplicationEvent {
  final String userId;

  JobApplicationFetched({required this.userId});
}
