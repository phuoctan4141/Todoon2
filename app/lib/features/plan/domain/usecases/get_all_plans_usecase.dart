import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/common/base/base_usecase.dart';
import 'package:todoon/features/plan/domain/entities/plan_entity.dart';
import 'package:todoon/features/plan/domain/repositories/plan_repository.dart';

class GetAllPlansUseCase extends UseCaseNoParams<List<PlanEntity>> {
  final PlanRepository _repository;

  GetAllPlansUseCase({required PlanRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<PlanEntity>>> call() async =>
      await _repository.getAll();
}
