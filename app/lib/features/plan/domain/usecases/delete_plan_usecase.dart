import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/common/base/base_usecase.dart';
import 'package:todoon/features/plan/domain/entities/plan_entity.dart';
import 'package:todoon/features/plan/domain/repositories/plan_repository.dart';

class DeletePlanParams {
  final PlanEntity entity;
  final bool softDelete;

  const DeletePlanParams({required this.entity, required this.softDelete});
}

class DeletePlanUseCase extends UseCase<DeletePlanParams, Unit> {
  final PlanRepository _repository;

  DeletePlanUseCase({required PlanRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, Unit>> execute(DeletePlanParams params) async =>
      await _repository.delete(
        entity: params.entity,
        softDelete: params.softDelete,
      );
}
