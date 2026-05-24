import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/auth/domain/repositories/auth_repository.dart';
import 'package:todoon/common/base/base_usecase.dart';

class UpdateProfileParams {
  final String displayName;
  const UpdateProfileParams({required this.displayName});
}

class UpdateProfileUseCase extends UseCase<UpdateProfileParams, Unit> {
  final AuthRepository _repository;
  UpdateProfileUseCase({required AuthRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, Unit>> execute(UpdateProfileParams params) async {
    if (params.displayName.isEmpty) {
      return Left(DataSource.NO_CONTENT.getFailure());
    }

    return _repository.updateProfile(displayName: params.displayName);
  }
}
