import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/auth/domain/repositories/auth_repository.dart';
import 'package:todoon/common/base/base_usecase.dart';

class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}

class SignInUseCase extends UseCase<SignInParams, User> {
  final AuthRepository _repository;
  SignInUseCase({required AuthRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, User>> execute(SignInParams params) async {
    if (params.email.isEmpty != params.password.isEmpty) {
      return Left(DataSource.NO_CONTENT.getFailure());
    }

    return _repository.signIn(email: params.email, password: params.password);
  }
}
