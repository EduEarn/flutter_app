import 'package:dartz/dartz.dart';

import 'package:edu_earn/core/user/domain/entity/user.dart';

import 'package:edu_earn/shared/errors/failure.dart';
import 'package:edu_earn/src/authentication/data/database/auth_local_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../shared/errors/exception.dart';
import '../../../../shared/network/network.dart';
import '../../domain/repository/auth_repository.dart';
import '../database/auth_remote_database.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatabase remoteDatabase;
  final AuthLocalDatabase localDatabase;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDatabase,
    required this.networkInfo,
    required this.localDatabase,
  });

  @override
  Future<Either<Failure, UserCredential>> continueWithGoogle() async {
    try {
      if (!await (networkInfo.hasInternet())) {
        return Left(Failure("No internet connection"));
      }
      return Right(await remoteDatabase.continueWithGoogle());
    } on DeviceException catch (e) {
      return Left(Failure(e.message));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.message.toString()));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> login(UserEntity user) async {
    try {
      if (!await (networkInfo.hasInternet())) {
        return Left(Failure("No internet connection"));
      }
      return Right(await remoteDatabase.login(user));
    } on DeviceException catch (e) {
      return Left(Failure(e.message));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.message.toString()));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signUp(UserEntity user) async {
    try {
      if (!await (networkInfo.hasInternet())) {
        return Left(Failure("No internet connection"));
      }
      return Right(await remoteDatabase.signUp(user));
    } on DeviceException catch (e) {
      return Left(Failure(e.message));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.message.toString()));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUserInfo() async {
    try {
      if (!await (networkInfo.hasInternet())) {
        debugPrint("No connection load userInfo from local database");
        final user = localDatabase.loadUserInfo();
        return Right(user);
      }
      final user = await remoteDatabase.getCurrentUserInfo();
      localDatabase.uploadUserInfo(userEntity: user);
      return Right(user);
    } on DeviceException catch (e) {
      return Left(Failure(e.message));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.message.toString()));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
