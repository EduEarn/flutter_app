import 'package:dartz/dartz.dart';
import 'package:edu_earn/shared/errors/failure.dart';
import 'package:edu_earn/shared/usecases/usecase.dart';
import 'package:edu_earn/src/applications/domain/entity/job_application.dart';
import 'package:edu_earn/src/applications/domain/repository/job_application_repository.dart';

class ApplyForJob extends UseCase<JobApplication, JobApplicationParams> {
  JobApplicationRepository repository;

  ApplyForJob({required this.repository});

  @override
  Future<Either<Failure, JobApplication>> call(params) async {
    return await repository.applyForJob(params.jobApplication);
  }
}

class JobApplicationParams {
  final JobApplication jobApplication;

  JobApplicationParams({required this.jobApplication});
}
