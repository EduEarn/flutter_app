import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_earn/shared/errors/failure.dart';
import 'package:edu_earn/src/applications/data/database/job_application_remote_database.dart';
import 'package:edu_earn/src/applications/domain/entity/job_application.dart';
import 'package:edu_earn/src/applications/domain/repository/job_application_repository.dart';

class JobApplicationRepositoryImpl implements JobApplicationRepository {
  final JobApplicationRemoteDatabase remoteDatabase;

  JobApplicationRepositoryImpl({required this.remoteDatabase});

  @override
  Future<Either<Failure, JobApplication>> applyForJob(JobApplication jobApplication) async {
    try {
      return Right(await remoteDatabase.applyForJob(jobApplication));
    } on FirebaseException catch (err) {
      return Left(Failure(err.message.toString()));
    } catch (err) {
      return Left(Failure(err.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JobApplication>>> fetchApplications(String userId) async {
    try {
      return Right(await remoteDatabase.fetchApplications(userId));
    } on FirebaseException catch (err) {
      return Left(Failure(err.message.toString()));
    } catch (err) {
      return Left(Failure(err.toString()));
    }
  }
}
