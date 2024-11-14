import 'package:dartz/dartz.dart';

import 'package:edu_earn_admin/core/company/entity/company.dart';

import 'package:edu_earn_admin/shared/error/failure.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repository/auth_repository.dart';
import '../database/auth_remote_database.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatabase remoteDatabase;

  AuthRepositoryImpl({required this.remoteDatabase});

  @override
  Future<Either<Failure, UserCredential>> continueWithGoogle() async {
    // TODO: implement continueWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> login(Company company) async {
    try {
      return Right(await remoteDatabase.login(company));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.toString()));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signUp(Company company) async {
    try {
      return Right(await remoteDatabase.signUp(company));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.toString()));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
