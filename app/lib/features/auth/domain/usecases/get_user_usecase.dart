import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoon/features/auth/domain/repositories/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository _repository;
  GetUserUseCase({required AuthRepository repository})
    : _repository = repository;

  Stream<User?> call() => _repository.userChanges;
}
