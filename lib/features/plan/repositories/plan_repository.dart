import 'package:dartz/dartz.dart';
import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/result_type.dart';
import 'package:todoon/features/plan/datasources/plan_local_datasource.dart';
import 'package:todoon/features/plan/datasources/plan_remote_datasource.dart';
import 'package:todoon/features/plan/models/plan_model.dart';

abstract class PlanRepository {
  Future<Either<Failure, List<PlanModel>>> getAll();
  Future<Either<Failure, PlanModel>> create(PlanModel plan);
  Future<Either<Failure, PlanModel>> update(PlanModel plan);
  Future<Either<Failure, Unit>> delete(String uid);
  Future<Either<Failure, Unit>> sync();
}

class PlanRepositoryImpl implements PlanRepository {
  final PlanLocalDataSource _local;
  final PlanRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  PlanRepositoryImpl(this._local, this._remote, this._networkInfo);

  @override
  Future<Either<Failure, List<PlanModel>>> getAll() async {
    final localPlans = await _local.getAll();

    try {
      if (!await _networkInfo.isConnected) {
        return Right(localPlans);
      }

      final remotePlans = await _remote.getAll();

      final filteredRemote = remotePlans
          .where((e) => e.deletedAt == null)
          .toList();

      // Sync remote → local
      for (final plan in filteredRemote) {
        await _local.put(plan.copyWith(isSynced: true));
      }

      return Right(filteredRemote);
    } catch (_) {
      return Right(localPlans);
    }
  }

  @override
  Future<Either<Failure, PlanModel>> create(PlanModel plan) async {
    try {
      final now = DateTime.now();

      final newPlan = plan.copyWith(
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );

      await _local.put(newPlan);

      if (await _networkInfo.isConnected) {
        await _remote.upsert(newPlan);
        await _local.put(newPlan.copyWith(isSynced: true));
      }

      return Right(newPlan);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, PlanModel>> update(PlanModel plan) async {
    try {
      final updated = plan.copyWith(updatedAt: DateTime.now(), isSynced: false);

      await _local.put(updated);

      if (await _networkInfo.isConnected) {
        await _remote.upsert(updated);
        await _local.put(updated.copyWith(isSynced: true));
      }

      return Right(updated);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String uid) async {
    try {
      await _local.softDelete(uid);

      if (await _networkInfo.isConnected) {
        await _remote.softDelete(uid);
      }

      return const Right(unit);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> sync() async {
    if (!await _networkInfo.isConnected) {
      return const Right(unit);
    }

    final unsyncedPlans = await _local.getUnsynced();

    for (final plan in unsyncedPlans) {
      await _remote.upsert(plan);
      await _local.put(plan.copyWith(isSynced: true));
    }

    return const Right(unit);
  }
}
