import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/result_type.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Khởi tạo service (đặt emulator nếu cần)
  static Future<FirebaseAuthService> init({
    bool useEmulator = false,
    String emulatorHost = '192.168.1.5',
    int emulatorPort = 9099,
  }) async {
    if (useEmulator) {
      await FirebaseAuth.instance.useAuthEmulator(emulatorHost, emulatorPort);
    }
    return _instance;
  }

  FirebaseAuth get instance => _auth;

  /// Lắng nghe trạng thái user (đăng nhập / đăng xuất)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Lấy user hiện tại (nếu có)
  User? get currentUser => _auth.currentUser;

  /// Đăng nhập bằng email + password
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
      return Left(DefaultFailure());
    }
  }

  /// Đăng ký tài khoản mới bằng email + password
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
      return Left(DefaultFailure());
    }
  }

  /// Đăng xuất user hiện
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Gửi email reset mật khẩu
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }
}
