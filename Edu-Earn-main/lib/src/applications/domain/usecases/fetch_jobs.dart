import 'package:dartz/dartz.dart';
import 'package:edu_earn/shared/errors/failure.dart';
import 'package:edu_earn/shared/usecases/usecase.dart';
import 'package:edu_earn/src/applications/domain/entity/job_application.dart';
import 'package:edu_earn/src/applications/domain/repository/job_application_repository.dart';

class FetchJobApplications extends UseCase<List<JobApplication>, FetchJobsParams> {
  JobApplicationRepository repository;

  FetchJobApplications({required this.repository});

  @override
  Future<Either<Failure, List<JobApplication>>> call(params) async {
    return await repository.fetchApplications(params.userId);
  }
}

class FetchJobsParams {
  final String userId;

  FetchJobsParams({required this.userId});
}
