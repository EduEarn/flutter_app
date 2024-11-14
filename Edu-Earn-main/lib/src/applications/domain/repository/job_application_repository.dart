import 'package:dartz/dartz.dart';
import 'package:edu_earn/shared/errors/failure.dart';

import '../entity/job_application.dart';

abstract class JobApplicationRepository {
  Future<Either<Failure, JobApplication>> applyForJob(JobApplication jobApplication);

  Future<Either<Failure, List<JobApplication>>> fetchApplications(String userId);
}
