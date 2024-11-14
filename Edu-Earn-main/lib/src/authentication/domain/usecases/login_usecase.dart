import 'package:dartz/dartz.dart';
import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:edu_earn/shared/usecases/usecase.dart';

import '../../../../shared/errors/failure.dart';
import '../repository/auth_repository.dart';

class LoginUseCase implements UseCase<void, LoginParams> {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(LoginParams params) async {
    return await repository.login(params.user);
  }
}

class LoginParams {
  final UserEntity user;

  LoginParams({required this.user});
}
