import 'package:dartz/dartz.dart';

import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/common/base/base_usecase.dart';
import 'package:todoon/features/plan/domain/entities/plan_entity.dart';
import 'package:todoon/features/plan/domain/repositories/plan_repository.dart';

class AddPlanParams {
  final String title;
  final List<PlanEntity> plans;

  const AddPlanParams({required this.title, required this.plans});
}

class AddPlanUseCase implements UseCase<AddPlanParams, Unit> {
  final PlanRepository _repository;

  AddPlanUseCase({required PlanRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, Unit>> execute(AddPlanParams params) async {
    final plan = PlanEntity.create(
      title: params.title,
      position: params.plans.length,
    );
    return await _repository.add(plan);
  }
}
