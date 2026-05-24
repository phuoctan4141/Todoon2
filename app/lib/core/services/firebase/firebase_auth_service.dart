import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initEmulator({
    bool useEmulator = true,
    String emulatorHost = '192.168.1.11',
    int emulatorPort = 9099,
  }) async {
    if (useEmulator) {
      await _auth.useAuthEmulator(emulatorHost, emulatorPort);
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get userChanges => _auth.userChanges();

  /// SignIn with email, password
  Future<Either<Failure, UserCredential>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  /// SignUp with email, password
  Future<Either<Failure, UserCredential>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  /// SignOut
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send a email to reset password
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  /// Update Profile
  Future<Either<Failure, Unit>> updateProfile({String? displayName}) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        return Left(DataSource.UNAUTHORIZED.getFailure());
      }

      await user.updateDisplayName(displayName);

      await user.reload();

      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  /// Change password
  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null || user.email == null) {
        return Left(DataSource.UNAUTHORIZED.getFailure());
      }

      // Re-authenticate
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      return Left(UnknownFailure());
    }
  }
}
