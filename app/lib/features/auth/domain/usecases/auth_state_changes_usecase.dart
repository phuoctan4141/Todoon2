import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoon/features/auth/domain/repositories/auth_repository.dart';

class AuthStateChangesUseCase {
  final AuthRepository _repository;

  AuthStateChangesUseCase({required AuthRepository repository})
    : _repository = repository;

  Stream<User?> call() => _repository.authStateChanges;
}
