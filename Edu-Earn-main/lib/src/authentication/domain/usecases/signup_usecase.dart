import 'package:dartz/dartz.dart';
import 'package:edu_earn/core/user/domain/entity/user.dart';

import '../../../../shared/errors/failure.dart';
import '../../../../shared/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class SignUpUseCase implements UseCase<void, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SignUpParams params) async {
    return await repository.signUp(params.user);
  }
}

class SignUpParams {
  final UserEntity user;

  SignUpParams({required this.user});
}
