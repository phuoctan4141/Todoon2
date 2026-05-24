import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/common/base/base_usecase.dart';
import 'package:todoon/features/plan/domain/entities/plan_entity.dart';
import 'package:todoon/features/plan/domain/repositories/plan_repository.dart';

class GetPlanByIdParams {
  final String id;

  const GetPlanByIdParams({required this.id});
}

class GetPlanByIdUseCase extends UseCase<GetPlanByIdParams, PlanEntity> {
  final PlanRepository _repository;

  GetPlanByIdUseCase({required PlanRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, PlanEntity>> execute(GetPlanByIdParams params) async =>
      await _repository.getById(params.id);
}
