import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:todoon/core/services/firebase/firebase_auth_service.dart';
import 'package:todoon/core/services/firebase/firestore_collections.dart';
import 'package:todoon/core/services/firebase/firestore_service.dart';
import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/result_type.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;

  Future<Either<Failure, Unit>> handleSignIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> handleSignUp({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> handleResetPassword(String email);

  Future<void> handleSignOut();

  Future<Either<Failure, Unit>> createAccount();
  Future<Either<Failure, Unit>> updateDisplayName();
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _auth;
  final FirestoreService _firestore;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(this._auth, this._firestore, this._networkInfo);

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges;

  @override
  Future<Either<Failure, Unit>> handleSignIn({
    required String email,
    required String password,
  }) async {
    // check isConnected
    if (!await _networkInfo.isConnected) return Left(NoInternetFailure());

    final signInResult = await _auth.signIn(email: email, password: password);
    return signInResult.fold(
      (failure) => Left(failure),
      (_) => const Right(unit),
    );
  }

  @override
  Future<Either<Failure, Unit>> handleSignUp({
    required String email,
    required String password,
  }) async {
    // check isConnected
    if (!await _networkInfo.isConnected) return Left(NoInternetFailure());

    final signUpResult = await _auth.signUp(email: email, password: password);

    if (signUpResult.isLeft()) {
      return signUpResult.fold(
        (failure) => Left(failure),
        (_) => const Right(unit),
      );
    }

    final createResult = await createAccount();
    if (createResult.isLeft()) {
      return createResult;
    }

    final updateResult = await updateDisplayName();
    if (updateResult.isLeft()) {
      return updateResult;
    }

    return const Right(unit);
  }

  @override
  Future<void> handleSignOut() async {
    _auth.signOut();
  }

  @override
  Future<Either<Failure, Unit>> handleResetPassword(String email) async {
    // check isConnected
    if (!await _networkInfo.isConnected) return Left(NoInternetFailure());

    return _auth.sendPasswordResetEmail(email);
  }

  @override
  Future<Either<Failure, Unit>> createAccount() async {
    try {
      final user = _auth.currentUser!;
      final result = await _firestore.upsert(
        collectionPath: FirestoreCollections.users,
        docId: user.uid,
        data: const {},
      );
      return result;
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateDisplayName() async {
    try {
      final user = _auth.currentUser!;
      final displayName = user.email!.split('@').first;

      await user.updateDisplayName(displayName);
      await user.reload();

      return const Right(unit);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }
}

String getNameFromEmail(String email) {
  return email.split('@').first;
}
