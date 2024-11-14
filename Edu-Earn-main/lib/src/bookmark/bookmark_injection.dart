import 'package:edu_earn/src/bookmark/data/database/bookmark_local_database.dart';
import 'package:edu_earn/src/bookmark/data/database/bookmark_remote_database.dart';
import 'package:edu_earn/src/bookmark/data/repository/bookmark_repository_impl.dart';
import 'package:edu_earn/src/bookmark/domain/repository/bookmark_repository.dart';
import 'package:edu_earn/src/bookmark/domain/usecases/add_bookmark.dart';
import 'package:edu_earn/src/bookmark/domain/usecases/get_user_bookmarks.dart';
import 'package:edu_earn/src/bookmark/domain/usecases/remove_bookmark.dart';
import 'package:edu_earn/src/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

void initBookmark() {
  final sl = GetIt.instance;
  sl
    ..registerLazySingleton<BookmarkRemoteDatabase>(() => BookmarkRemoteDatabaseImpl())
    ..registerLazySingleton<BookmarkLocalDatabase>(() => BookmarkLocalDatabaseImpl(box: Hive.box(name: "bookmarks")))
    ..registerLazySingleton<BookmarkRepository>(() => BookmarkRepositoryImpl(
          remoteDatabase: sl(),
          localDatabase: sl(),
          networkInfo: sl(),
        ))
    ..registerLazySingleton<AddBookmark>(() => AddBookmark(
          repository: sl(),
        ))
    ..registerLazySingleton<RemoveBookmark>(() => RemoveBookmark(
          repository: sl(),
        ))
    ..registerLazySingleton<GetUserBookmarks>(() => GetUserBookmarks(
          repository: sl(),
        ))
    ..registerFactory<BookmarkBloc>(() => BookmarkBloc(
          addBookmark: sl(),
          removeBookmark: sl(),
          getUserBookmarks: sl(),
        ));
}
