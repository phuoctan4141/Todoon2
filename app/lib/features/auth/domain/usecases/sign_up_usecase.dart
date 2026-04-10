import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/auth/domain/repositories/auth_repository.dart';
import 'package:todoon/features/common/base/base_usecase.dart';

class SignUpParams {
  final String email;
  final String password;

  const SignUpParams({required this.email, required this.password});
}

class SignUpUseCase extends UseCase<SignUpParams, User> {
  final AuthRepository _repository;

  SignUpUseCase({required AuthRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, User>> execute(SignUpParams params) async {
    if (params.email.isEmpty != params.password.isEmpty) {
      return Left(DataSource.NO_CONTENT.getFailure());
    }

    return _repository.signUp(email: params.email, password: params.password);
  }
}
