import 'package:dartz/dartz.dart';
import 'package:edu_earn_admin/core/company/entity/company.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class SignUpUseCase implements UseCase<void, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SignUpParams params) async {
    return await repository.signUp(params.company);
  }
}

class SignUpParams {
  final Company company;

  SignUpParams({required this.company});
}
