import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:todoon/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  // Timeout duration for network operations
  static const Duration _timeout = Duration(seconds: 30);

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  User? get currentUser => _remoteDataSource.currentUser;

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      final result = await _remoteDataSource
          .signIn(email: email, password: password)
          .timeout(_timeout);

      return result.fold((f) => Left(f), (userCredential) {
        return Right(userCredential.user!);
      });
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      final result = await _remoteDataSource
          .signUp(email: email, password: password)
          .timeout(_timeout);

      return result.fold((f) => Left(f), (userCredential) {
        return Right(userCredential.user!);
      });
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(unit);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    if (!await _networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      return await _remoteDataSource
          .sendPasswordResetEmail(email)
          .timeout(_timeout);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile({String? displayName}) async {
    if (!await _networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      return await _remoteDataSource
          .updateProfile(displayName: displayName)
          .timeout(_timeout);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      final result = await _remoteDataSource
          .changePassword(oldPassword: oldPassword, newPassword: newPassword)
          .timeout(_timeout);
      return result.fold((f) => Left(f), (_) {
        return const Right(unit);
      });
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    }
  }
}
