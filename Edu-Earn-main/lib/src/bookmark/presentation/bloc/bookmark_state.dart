part of 'bookmark_bloc.dart';

@immutable
sealed class BookmarkState {}

final class BookmarkInitial extends BookmarkState {}

final class BookmarkLoading extends BookmarkState {}

final class BookmarkSaveSuccess extends BookmarkState {
  final Bookmark bookmark;

  BookmarkSaveSuccess({required this.bookmark});
}

final class BookmarkRemoveSuccess extends BookmarkState {
  final Bookmark bookmark;

  BookmarkRemoveSuccess({required this.bookmark});
}

final class UserBookmarkListSuccess extends BookmarkState {
  final List<JobEntity> jobs;

  UserBookmarkListSuccess({required this.jobs});
}

final class BookmarkFailure extends BookmarkState {
  final String message;

  BookmarkFailure(this.message);
}
