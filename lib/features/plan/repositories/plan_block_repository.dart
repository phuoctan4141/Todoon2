import 'package:dartz/dartz.dart';
import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/result_type.dart';
import 'package:todoon/features/plan/datasources/plan_block_local_datasource.dart';
import 'package:todoon/features/plan/datasources/plan_block_remote_datasource.dart';
import 'package:todoon/features/plan/models/plan_block_model.dart';

abstract class PlanBlockRepository {
  Future<Either<Failure, List<PlanBlockModel>>> getByPlanId(String planId);
  Future<Either<Failure, PlanBlockModel>> create(PlanBlockModel block);
  Future<Either<Failure, PlanBlockModel>> update(PlanBlockModel block);
  Future<Either<Failure, Unit>> updateBlocks(
    List<PlanBlockModel> blocks,
    bool localOnly,
  );
  Future<Either<Failure, Unit>> delete(String uid);
  Future<Either<Failure, Unit>> sync();
}

class PlanBlockRepositoryImpl implements PlanBlockRepository {
  final PlanBlockLocalDataSource _local;
  final PlanBlockRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  PlanBlockRepositoryImpl(this._local, this._remote, this._networkInfo);

  @override
  Future<Either<Failure, List<PlanBlockModel>>> getByPlanId(
    String planId,
  ) async {
    final localBlocks = await _local.getByPlanId(planId);
    print('Lenght localBlocks:${localBlocks.length}');

    try {
      if (!await _networkInfo.isConnected) {
        return Right(localBlocks);
      }

      final remoteBlocks = await _remote.getAll();

      final filteredRemote = remoteBlocks
          .where((e) => e.planId == planId && e.deletedAt == null)
          .toList();

      // sync remote → local
      for (final block in filteredRemote) {
        print('filteredRemote:${block.uid}');
        await _local.put(block.copyWith(isSynced: true));
      }

      return Right(filteredRemote);
    } catch (_) {
      return Right(localBlocks);
    }
  }

  @override
  Future<Either<Failure, PlanBlockModel>> create(PlanBlockModel block) async {
    try {
      final now = DateTime.now();

      final newBlock = block.copyWith(createdAt: now, isSynced: false);

      await _local.put(newBlock);

      if (await _networkInfo.isConnected) {
        await _remote.upsert(newBlock);
        await _local.put(newBlock.copyWith(isSynced: true));
      }

      return Right(newBlock);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, PlanBlockModel>> update(PlanBlockModel block) async {
    try {
      final updated = block.copyWith(
        updatedAt: DateTime.now(),
        isSynced: false,
      );

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

    final unsyncedBlocks = await _local.getUnsynced();

    for (final block in unsyncedBlocks) {
      await _remote.upsert(block);
      await _local.put(block.copyWith(isSynced: true));
    }

    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> updateBlocks(
    List<PlanBlockModel> blocks,
    bool localOnly,
  ) async {
    try {
      // update local immediately
      for (int i = 0; i < blocks.length; i++) {
        await _local.put(blocks[i].copyWith(position: i, isSynced: false));
      }

      if (localOnly) return Right(unit);

      if (await _networkInfo.isConnected) {
        for (int i = 0; i < blocks.length; i++) {
          final updated = blocks[i].copyWith(
            position: i,
            updatedAt: DateTime.now(),
          );

          await _remote.upsert(updated);

          await _local.put(updated.copyWith(isSynced: true));
        }
      }

      return Right(unit);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }
}
