import 'package:dartz/dartz.dart';
import 'package:edu_earn/shared/usecases/usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../shared/errors/failure.dart';
import '../repository/auth_repository.dart';

class ContinueWithGoogleUseCase extends UseCase<UserCredential, NoGoogleParams> {
  final AuthRepository repository;

  ContinueWithGoogleUseCase({required this.repository});

  @override
  Future<Either<Failure, UserCredential>> call(NoGoogleParams params) async {
    return await repository.continueWithGoogle();
  }
}

class NoGoogleParams {}
