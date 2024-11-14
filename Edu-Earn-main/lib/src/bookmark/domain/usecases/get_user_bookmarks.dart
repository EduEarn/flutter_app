import 'package:dartz/dartz.dart';
import 'package:edu_earn/core/job/domain/entity/job.dart';
import 'package:edu_earn/shared/usecases/usecase.dart';
import 'package:edu_earn/src/bookmark/domain/repository/bookmark_repository.dart';

import '../../../../shared/errors/failure.dart';

class GetUserBookmarks implements UseCase<List<JobEntity>, GetUserBookmarksParams> {
  final BookmarkRepository repository;

  GetUserBookmarks({required this.repository});

  @override
  Future<Either<Failure, List<JobEntity>>> call(GetUserBookmarksParams params) async {
    return await repository.getUserBookmarks(params.userId);
  }
}

class GetUserBookmarksParams {
  final String userId;

  GetUserBookmarksParams({required this.userId});
}
