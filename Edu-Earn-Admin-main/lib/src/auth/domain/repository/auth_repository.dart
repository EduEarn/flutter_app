import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/company/entity/company.dart';
import '../../../../shared/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(Company company);

  Future<Either<Failure, void>> signUp(Company company);

  Future<Either<Failure, UserCredential>> continueWithGoogle();
}
