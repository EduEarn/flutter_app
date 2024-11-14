import 'package:dartz/dartz.dart';
import 'package:edu_earn/core/job/domain/entity/job.dart';

import '../../../../shared/errors/failure.dart';
import '../entity/bookmark.dart';

abstract class BookmarkRepository {
  Future<Either<Failure, Bookmark>> addBookmark(Bookmark bookmark);

  Future<Either<Failure, Bookmark?>> removeBookmark(Bookmark bookmark);

  Future<Either<Failure, List<JobEntity>>> getUserBookmarks(String userId);
}
