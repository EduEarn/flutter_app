import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_earn/core/job/domain/entity/job.dart';
import 'package:edu_earn/shared/errors/failure.dart';
import 'package:edu_earn/shared/network/network.dart';
import 'package:edu_earn/src/bookmark/data/database/bookmark_local_database.dart';
import 'package:edu_earn/src/bookmark/data/database/bookmark_remote_database.dart';
import 'package:edu_earn/src/bookmark/domain/entity/bookmark.dart';
import 'package:edu_earn/src/bookmark/domain/repository/bookmark_repository.dart';
import 'package:flutter/material.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkRemoteDatabase remoteDatabase;
  final BookmarkLocalDatabase localDatabase;
  final NetworkInfo networkInfo;

  BookmarkRepositoryImpl({
    required this.remoteDatabase,
    required this.localDatabase,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Bookmark>> addBookmark(Bookmark bookmark) async {
    try {
      if (!await (networkInfo.hasInternet())) {
        return Left(Failure("No internet Connection"));
      }
      return Right(await remoteDatabase.addBookmark(bookmark));
    } on FirebaseException catch (err) {
      return Left(Failure(err.message.toString()));
    } catch (err) {
      return Left(Failure(err.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JobEntity>>> getUserBookmarks(String userId) async {
    try {
      if (!await (networkInfo.hasInternet())) {
        debugPrint("Network is unavailable load bookmarks from local database");
        final jobs = localDatabase.loadBookmarks();
        return Right(jobs);
      }
      final jobs = await remoteDatabase.getUserBookmarks(userId);
      localDatabase.uploadLocalBookmarks(jobs: jobs);
      return Right(jobs);
    } on FirebaseException catch (err) {
      return Left(Failure(err.message.toString()));
    } catch (err) {
      return Left(Failure(err.toString()));
    }
  }

  @override
  Future<Either<Failure, Bookmark?>> removeBookmark(Bookmark bookmark) async {
    try {
      return Right(await remoteDatabase.removeBookmark(bookmark));
    } on FirebaseException catch (err) {
      return Left(Failure(err.message.toString()));
    } catch (err) {
      return Left(Failure(err.toString()));
    }
  }
}
