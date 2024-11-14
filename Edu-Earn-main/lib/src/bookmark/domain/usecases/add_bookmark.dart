import 'package:dartz/dartz.dart';
import 'package:edu_earn/shared/usecases/usecase.dart';
import 'package:edu_earn/src/bookmark/domain/entity/bookmark.dart';
import 'package:edu_earn/src/bookmark/domain/repository/bookmark_repository.dart';

import '../../../../shared/errors/failure.dart';

class AddBookmark implements UseCase<Bookmark, AddBookmarkParams> {
  BookmarkRepository repository;

  AddBookmark({required this.repository});

  @override
  Future<Either<Failure, Bookmark>> call(AddBookmarkParams params) async {
    return await repository.addBookmark(params.bookmark);
  }
}

class AddBookmarkParams {
  final Bookmark bookmark;

  AddBookmarkParams({required this.bookmark});
}
