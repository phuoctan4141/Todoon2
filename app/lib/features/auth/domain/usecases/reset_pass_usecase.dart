import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/auth/domain/repositories/auth_repository.dart';
import 'package:todoon/common/base/base_usecase.dart';

class ResetPassParams {
  final String email;
  const ResetPassParams({required this.email});
}

class ResetPassUseCase extends UseCase<ResetPassParams, Unit> {
  final AuthRepository _repository;
  ResetPassUseCase({required AuthRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, Unit>> execute(ResetPassParams params) async {
    if (params.email.isEmpty) {
      return Left(DataSource.NO_CONTENT.getFailure());
    }

    return _repository.sendPasswordResetEmail(params.email);
  }
}
