import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoon/core/services/firebase/firebase_auth_service.dart';
import 'package:todoon/core/utils/failure.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Stream<User?> get userChanges;

  Future<Either<Failure, UserCredential>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserCredential>> signUp({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);

  Future<Either<Failure, Unit>> updateProfile({String? displayName});

  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuthService _authService;

  AuthRemoteDataSourceImpl({FirebaseAuthService? authService})
    : _authService = authService ?? FirebaseAuthService();

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  User? get currentUser => _authService.currentUser;

  @override
  Stream<User?> get userChanges => _authService.userChanges;

  @override
  Future<Either<Failure, UserCredential>> signIn({
    required String email,
    required String password,
  }) => _authService.signIn(email: email, password: password);

  @override
  Future<Either<Failure, UserCredential>> signUp({
    required String email,
    required String password,
  }) => _authService.signUp(email: email, password: password);

  @override
  Future<void> signOut() => _authService.signOut();

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) =>
      _authService.sendPasswordResetEmail(email);

  @override
  Future<Either<Failure, Unit>> updateProfile({String? displayName}) =>
      _authService.updateProfile(displayName: displayName);

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) => _authService.changePassword(
    oldPassword: oldPassword,
    newPassword: newPassword,
  );
}
