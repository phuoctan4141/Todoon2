import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/common/base/base_usecase.dart';
import 'package:todoon/features/plan/domain/entities/plan_entity.dart';
import 'package:todoon/features/plan/domain/repositories/plan_repository.dart';

class UpdatePlanParams {
  final PlanEntity entity;

  const UpdatePlanParams({required this.entity});
}

class UpdatePlanUseCase extends UseCase<UpdatePlanParams, Unit> {
  final PlanRepository _repository;

  UpdatePlanUseCase({required PlanRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, Unit>> execute(UpdatePlanParams params) async =>
      await _repository.update(params.entity);
}
