import 'package:dartz/dartz.dart';
import 'package:edu_earn/shared/usecases/usecase.dart';
import 'package:edu_earn/src/bookmark/domain/entity/bookmark.dart';
import 'package:edu_earn/src/bookmark/domain/repository/bookmark_repository.dart';

import '../../../../shared/errors/failure.dart';

class RemoveBookmark implements UseCase<Bookmark?, RemoveBookmarkParams> {
  final BookmarkRepository repository;

  RemoveBookmark({required this.repository});

  @override
  Future<Either<Failure, Bookmark?>> call(RemoveBookmarkParams params) async {
    return await repository.removeBookmark(params.bookmark);
  }
}

class RemoveBookmarkParams {
  final Bookmark bookmark;

  RemoveBookmarkParams({required this.bookmark});
}
