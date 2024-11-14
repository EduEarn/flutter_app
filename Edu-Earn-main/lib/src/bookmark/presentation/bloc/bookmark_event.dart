part of 'bookmark_bloc.dart';

@immutable
sealed class BookmarkEvent {}

final class SaveBookmark extends BookmarkEvent {
  final Bookmark bookmark;

  SaveBookmark({required this.bookmark});
}

final class DeleteBookmark extends BookmarkEvent {
  final Bookmark bookmark;

  DeleteBookmark({required this.bookmark});
}

final class RetrieveUserBookmark extends BookmarkEvent {
  final String userId;

  RetrieveUserBookmark({required this.userId});
}
