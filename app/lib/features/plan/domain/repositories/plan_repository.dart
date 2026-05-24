import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/common/base/base_repository.dart';
import 'package:todoon/features/plan/domain/entities/plan_entity.dart';

abstract class PlanRepository implements BaseRepository<PlanEntity> {
  @override
  Stream<RepositoryEvents<PlanEntity>> get eventStream;

  @override
  void dispatchEvent(RepositoryEvents<PlanEntity> event);

  @override
  void dispose();

  Future<Either<Failure, List<PlanEntity>>> getAll();
  Future<Either<Failure, PlanEntity>> getById(String id);

  Future<Either<Failure, Unit>> add(PlanEntity entity);
  Future<Either<Failure, Unit>> update(PlanEntity entity);
  Future<Either<Failure, Unit>> delete({
    required PlanEntity entity,
    bool softDelete = false,
  });

  Future<Either<Failure, List<PlanEntity>>> backgroundGetAll();
  Future<Either<Failure, Unit>> backgroundAdd(PlanEntity entity);
  Future<Either<Failure, Unit>> backgroundUpdate(PlanEntity entity);
  Future<Either<Failure, Unit>> backgroundDelete({
    required PlanEntity entity,
    bool softDelete = false,
  });

  bool hasDataChanged({
    required List<PlanEntity> local,
    required List<PlanEntity> remote,
  });

  Future<void> mergeAndUpdate({
    required List<PlanEntity> local,
    required List<PlanEntity> remote,
  });
}
