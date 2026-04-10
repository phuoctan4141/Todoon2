import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase({required AuthRepository repository})
    : _repository = repository;

  Future<Either<Failure, Unit>> execute() async {
    return _repository.signOut();
  }
}
