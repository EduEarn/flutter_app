import 'package:edu_earn/core/job/domain/entity/job.dart';
import 'package:edu_earn/src/bookmark/domain/entity/bookmark.dart';
import 'package:edu_earn/src/bookmark/domain/usecases/remove_bookmark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_bookmark.dart';
import '../../domain/usecases/get_user_bookmarks.dart';

part 'bookmark_event.dart';

part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final AddBookmark _addBookmark;
  final RemoveBookmark _removeBookmark;
  final GetUserBookmarks _getUserBookmarks;

  BookmarkBloc({
    required AddBookmark addBookmark,
    required RemoveBookmark removeBookmark,
    required GetUserBookmarks getUserBookmarks,
  })  : _addBookmark = addBookmark,
        _removeBookmark = removeBookmark,
        _getUserBookmarks = getUserBookmarks,
        super(BookmarkInitial()) {
    on<BookmarkEvent>((event, emit) => emit(BookmarkLoading()));
    on<SaveBookmark>((event, emit) async {
      final res = await _addBookmark(AddBookmarkParams(bookmark: event.bookmark));
      return res.fold((failure) => emit(BookmarkFailure(failure.message)),
          (bookmark) => emit(BookmarkSaveSuccess(bookmark: bookmark)));
    });
    on<DeleteBookmark>((event, emit) async {
      final res = await _removeBookmark(RemoveBookmarkParams(bookmark: event.bookmark));
      return res.fold((failure) => emit(BookmarkFailure(failure.message)),
          (bookmark) => emit(BookmarkRemoveSuccess(bookmark: bookmark!)));
    });

    on<RetrieveUserBookmark>((event, emit) async {
      final res = await _getUserBookmarks(GetUserBookmarksParams(userId: event.userId));
      return res.fold((failure) => emit(BookmarkFailure(failure.message)), (jobs) {
        emit(UserBookmarkListSuccess(jobs: jobs));
      });
    });
  }
}
