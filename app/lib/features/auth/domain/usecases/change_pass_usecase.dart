import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/auth/domain/repositories/auth_repository.dart';
import 'package:todoon/common/base/base_usecase.dart';

class ChangePassParams {
  final String oldPassword;
  final String newPassword;

  const ChangePassParams({
    required this.oldPassword,
    required this.newPassword,
  });
}

class ChangePassUseCase extends UseCase<ChangePassParams, Unit> {
  final AuthRepository _repository;
  ChangePassUseCase({required AuthRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, Unit>> execute(ChangePassParams params) async {
    if (params.oldPassword.isEmpty || params.newPassword.isEmpty) {
      return Left(DataSource.NO_CONTENT.getFailure());
    }

    if (params.oldPassword.compareTo(params.newPassword) == 0) {
      return Left(DataSource.BAD_REQUEST.getFailure());
    }

    return _repository.changePassword(
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );
  }
}
