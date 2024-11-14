import 'package:dartz/dartz.dart';
import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:edu_earn/shared/usecases/usecase.dart';

import '../../../../shared/errors/failure.dart';
import '../repository/auth_repository.dart';

class GetCurrentUserInfo implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  GetCurrentUserInfo({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(NoParams noParams) async {
    return await repository.getCurrentUserInfo();
  }
}

class NoParams {}
