import 'package:dartz/dartz.dart';
import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../shared/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(UserEntity user);

  Future<Either<Failure, void>> signUp(UserEntity user);

  Future<Either<Failure, UserEntity>> getCurrentUserInfo();

  Future<Either<Failure, UserCredential>> continueWithGoogle();
}
