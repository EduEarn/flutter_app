import 'package:dartz/dartz.dart';
import 'package:edu_earn_admin/core/company/entity/company.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class LoginUseCase implements UseCase<void, LoginParams> {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(LoginParams params) async {
    return await repository.login(params.company);
  }
}

class LoginParams {
  final Company company;

  LoginParams({required this.company});
}
