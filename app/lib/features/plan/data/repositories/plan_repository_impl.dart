import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/strings_manager.dart';
import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/common/base/base_repository.dart';
import 'package:todoon/features/plan/data/datasources/plan_localdatasource.dart';
import 'package:todoon/features/plan/data/datasources/plan_remotedatasource.dart';
import 'package:todoon/features/plan/data/models/plan_model.dart';
import 'package:todoon/features/plan/domain/entities/plan_entity.dart';
import 'package:todoon/features/plan/domain/repositories/plan_repository.dart';

class PlanRepositoryImpl implements PlanRepository {
  final NetworkInfo _networkInfo;
  final PlanRemoteDataSource _remote;
  final PlanLocalDataSource _local;

  PlanRepositoryImpl({
    required NetworkInfo networkInfo,
    required PlanRemoteDataSource remoteDataSource,
    required PlanLocalDataSource localDataSource,
  }) : _networkInfo = networkInfo,
       _remote = remoteDataSource,
       _local = localDataSource;

  final _eventController =
      StreamController<RepositoryEvents<PlanEntity>>.broadcast();

  @override
  Stream<RepositoryEvents<PlanEntity>> get eventStream =>
      _eventController.stream;

  @override
  void dispatchEvent(RepositoryEvents<PlanEntity> event) {
    _eventController.add(event);
  }

  @override
  void dispose() {
    _eventController.close();
  }

  @override
  Future<Either<Failure, List<PlanEntity>>> getAll() async {
    try {
      // 1. Get local data first
      final localResult = await _local.getAll();
      List<PlanEntity> localPlans = [];

      localResult.fold(
        (failure) {
          // Log error but continue to fetch remote
          debugPrint(
            AppStrings.error(
              tag: 'PlanRepository.getAll - local',
              message: failure.message,
            ),
          );
        },
        (localData) {
          localPlans = localData.map((e) => e.toEntity()).toList();
        },
      );

      // 2. Get remote data for sync
      final remoteResult = await backgroundGetAll();
      List<PlanEntity> remotePlans = [];

      remoteResult.fold(
        (failure) {
          debugPrint(
            AppStrings.error(
              tag: 'PlanRepository.getAll - remote',
              message: failure.message,
            ),
          );
        },
        (remoteData) {
          remotePlans = remoteData;
        },
      );

      // 3. Merge and update local data
      if (hasDataChanged(local: localPlans, remote: remotePlans)) {
        await mergeAndUpdate(local: localPlans, remote: remotePlans);

        final updatedLocalResult = await _local.getAll();
        updatedLocalResult.fold(
          (failure) => debugPrint(
            AppStrings.error(
              tag: 'PlanRepository.getAll - local',
              message: failure.message,
            ),
          ),
          (updatedData) =>
              localPlans = updatedData.map((e) => e.toEntity()).toList(),
        );
      }

      // 4. Return local data
      dispatchEvent(
        RepositoryEvents(
          type: RepositoryEventType.get,
          timestamp: DateTime.now(),
          message: 'All plans data getting successfully',
        ),
      );

      if (localPlans.isNotEmpty) {
        // filter plans where deletedAt is not null and id is dailyFocusUid
        localPlans.removeWhere((e) => e.deletedAt != null);
        localPlans.removeWhere((e) => e.id == AppStrings.dailyFocusUid);
      }

      return Right(localPlans);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, PlanEntity>> getById(String id) async {
    // 1. Only local
    try {
      final localResult = await _local.getById(id);
      return localResult.fold((f) => Left(f), (data) {
        if (data == null) return Left(DataSource.NOT_FOUND.getFailure());
        dispatchEvent(
          RepositoryEvents(
            type: RepositoryEventType.get,
            timestamp: DateTime.now(),
            message: 'Plan data getting successfully',
          ),
        );
        return Right(data.toEntity());
      });
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> add(PlanEntity entity) async {
    try {
      final localResult = await _local.add(PlanModel.fromEntity(entity));
      return localResult.fold((f) => Left(f), (r) {
        unawaited(backgroundAdd(entity));
        dispatchEvent(
          RepositoryEvents(
            type: RepositoryEventType.add,
            timestamp: DateTime.now(),
            message: 'Plan data added successfully',
          ),
        );
        return Right(r);
      });
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> update(PlanEntity entity) async {
    try {
      final updatedEntity = entity.markAsUpdated();
      // 1. Update data in local
      final localResult = await _local.update(
        PlanModel.fromEntity(updatedEntity),
      );
      return localResult.fold((f) => Left(f), (r) {
        // 2. Update data in remote
        unawaited(backgroundUpdate(updatedEntity));
        // 3. Dispatch event
        dispatchEvent(
          RepositoryEvents(
            type: RepositoryEventType.update,
            timestamp: DateTime.now(),
            message: 'Plan data updated successfully',
          ),
        );
        return Right(r);
      });
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> delete({
    required PlanEntity entity,
    bool softDelete = false,
  }) async {
    try {
      final updatedEntity = entity.markAsDeleted();
      final model = PlanModel.fromEntity(updatedEntity);
      // 1. SOFT DELETE
      if (softDelete) {
        // Update data in local
        final localResult = await _local.softDelete(model);
        return localResult.fold((f) => Left(f), (r) {
          // Update data in remote
          unawaited(backgroundDelete(entity: updatedEntity, softDelete: true));
          //  Dispatch event
          dispatchEvent(
            RepositoryEvents(
              type: RepositoryEventType.delete,
              timestamp: DateTime.now(),
              message: 'Plan data soft deleted successfully',
            ),
          );
          return Right(r);
        });
      }
      // 2. PERMANENT DELETE
      else {
        // Update data in local
        final localResult = await _local.delete(model.id);
        return localResult.fold((f) => Left(f), (r) {
          // Update data in remote
          unawaited(backgroundDelete(entity: updatedEntity, softDelete: false));
          //  Dispatch event
          dispatchEvent(
            RepositoryEvents(
              type: RepositoryEventType.delete,
              timestamp: DateTime.now(),
              message: 'Plan data permanently deleted successfully',
            ),
          );
          return Right(r);
        });
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<PlanEntity>>> backgroundGetAll() async {
    try {
      // 1. Check internet connection first
      if (await _networkInfo.isConnected) {
        // 2. Fetch from remote
        final remoteResult = await _remote.getAll().timeout(kRequestTimeout);
        // 3. Map models to entities
        return remoteResult.fold(
          (f) => Left(f),
          (models) => Right(models.map((e) => e.toEntity()).toList()),
        );
      }
      return Left(NoInternetFailure());
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> backgroundAdd(PlanEntity entity) async {
    try {
      if (await _networkInfo.isConnected) {
        final model = PlanModel.fromEntity(entity.markAsSynced());
        final result = await _remote.add(model).timeout(kRequestTimeout);
        return result.fold((f) => Left(f), (r) => Right(r));
      }
      return Left(NoInternetFailure());
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> backgroundUpdate(PlanEntity entity) async {
    try {
      if (await _networkInfo.isConnected) {
        final model = PlanModel.fromEntity(entity.markAsSynced());
        final result = await _remote.update(model).timeout(kRequestTimeout);
        return result.fold((f) => Left(f), (r) => Right(r));
      }
      return Left(NoInternetFailure());
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> backgroundDelete({
    required PlanEntity entity,
    bool softDelete = false,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        if (softDelete) {
          // 1. SOFT delete from remote
          final model = PlanModel.fromEntity(entity.markAsSynced());
          final result = await _remote
              .softDelete(model)
              .timeout(kRequestTimeout);
          return result.fold((f) => Left(f), (r) => Right(r));
        } else {
          // 2. PERMANENTLY delete data from remote
          final result = await _remote
              .delete(entity.id)
              .timeout(kRequestTimeout);
          return result.fold((f) => Left(f), (r) => Right(r));
        }
      }
      return Left(NoInternetFailure());
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    }
  }

  @override
  bool hasDataChanged({
    required List<PlanEntity> local,
    required List<PlanEntity> remote,
  }) {
    // 1. Compare lengths
    if (local.length != remote.length) {
      return true;
    }

    final localMap = {for (var item in local) item.id: item};

    // 2. Compare updated dates, soft deletes, and titles, position
    for (final remoteItem in remote) {
      final localItem = localMap[remoteItem.id];

      if (localItem == null) return true;

      if (localItem.updatedAt != remoteItem.updatedAt ||
          localItem.deletedAt != remoteItem.deletedAt) {
        return true;
      }
    }

    /// 3. Check if there are any local items that are not in remote
    final remoteIds = {for (var r in remote) r.id};
    for (final localItem in local) {
      if (!remoteIds.contains(localItem.id)) return true;
    }

    return false;
  }

  @override
  Future<void> mergeAndUpdate({
    required List<PlanEntity> local,
    required List<PlanEntity> remote,
  }) async {
    dispatchEvent(
      RepositoryEvents(
        type: RepositoryEventType.syncStarted,
        timestamp: DateTime.now(),
        message: 'Plan data syncing started',
      ),
    );

    try {
      final localMap = {for (var item in local) item.id: item};

      // 1. Find items to add/update/soft delete
      for (final remoteItem in remote) {
        final localItem = localMap[remoteItem.id];

        // New item - insert
        if (localItem == null) {
          if (remoteItem.deletedAt == null) {
            await _local.add(PlanModel.fromEntity(remoteItem));
          }
          continue;
        }

        // Soft deleted item - soft delete
        if (remoteItem.deletedAt != null) {
          await _local.softDelete(PlanModel.fromEntity(remoteItem));
          continue;
        }

        // Updated item - update
        final localTime = localItem.updatedAt ?? localItem.createdAt;
        final remoteTime = remoteItem.updatedAt ?? remoteItem.createdAt;
        if (remoteTime.isAfter(localTime)) {
          await _local.update(PlanModel.fromEntity(remoteItem));
        }
      }

      // 2. Dispatch event to notify
      dispatchEvent(
        RepositoryEvents(
          type: RepositoryEventType.syncCompleted,
          timestamp: DateTime.now(),
          message: 'Plan data synced successfully',
        ),
      );
    } catch (e) {
      dispatchEvent(
        RepositoryEvents(
          type: RepositoryEventType.syncFailed,
          timestamp: DateTime.now(),
          message: 'Plan data synced failed',
        ),
      );
      debugPrint(
        AppStrings.error(
          tag: 'PlanRepositoryImpl.mergeAndUpdate',
          message: e.toString(),
        ),
      );
    }
  }
}
