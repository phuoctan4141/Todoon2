import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/strings_manager.dart';
import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/common/base/base_repository.dart';
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
  Future<Either<Failure, Unit>> add(PlanEntity data) async {
    try {
      final localResult = await _local.add(PlanModel.fromEntity(data));
      return localResult.fold((f) => Left(f), (r) {
        unawaited(backgroundAdd(data));
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
  Future<Either<Failure, Unit>> update(PlanEntity data) async {
    try {
      final localResult = await _local.update(PlanModel.fromEntity(data));
      return localResult.fold((f) => Left(f), (r) {
        unawaited(backgroundUpdate(data));
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
    required String id,
    bool softDelete = false,
  }) async {
    try {
      if (softDelete) {
        // 1. Get data from local
        final data = await _local.getById(id);
        // 2. Check if data is null
        return data.fold((f) => Left(f), (m) async {
          if (m == null) return Left(DataSource.NOT_FOUND.getFailure());
          // 3. Soft delete data from local
          final localResult = await _local.softDelete(m);
          return localResult.fold((f) => Left(f), (r) {
            // 4. Delete data from remote
            unawaited(
              backgroundDelete(id: id, data: m.toEntity(), softDelete: true),
            );
            // 5. Dispatch event
            dispatchEvent(
              RepositoryEvents(
                type: RepositoryEventType.delete,
                timestamp: DateTime.now(),
                message: 'Plan data soft deleted successfully',
              ),
            );
            return Right(r);
          });
        });
      } else {
        // 1. Delete data from local
        final localResult = await _local.delete(id);
        return localResult.fold((f) => Left(f), (r) {
          // 2. Delete data from remote
          unawaited(backgroundDelete(id: id));
          // 3. Dispatch event
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
  Future<Either<Failure, List<PlanModel>>> backgroundGetAll() async {
    try {
      // 1. Check internet connection first
      if (await _networkInfo.isConnected) {
        // 2. Fetch from remote
        final remoteResult = await _remote.getAll().timeout(kRequestTimeout);
        // 3. Map the result to PlanEntity
        return remoteResult.fold(
          (f) => Left(f),
          (remoteData) =>
              Right(remoteData.map((e) => PlanModel.fromFirestore(e)).toList()),
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
  Future<Either<Failure, Unit>> backgroundAdd(PlanModel data) async {
    try {
      if (await _networkInfo.isConnected) {
        final result = await _remote
            .add(data.toFirestore())
            .timeout(kRequestTimeout);
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
  Future<Either<Failure, Unit>> backgroundUpdate(PlanModel data) async {
    try {
      if (await _networkInfo.isConnected) {
        final result = await _remote
            .update(data.toFirestore())
            .timeout(kRequestTimeout);
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
    required String id,
    PlanModel? data,
    bool softDelete = false,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        if (softDelete) {
          // 1. SOFT delete from remote
          final result = await _remote
              .softDelete(data!.toFirestore())
              .timeout(kRequestTimeout);
          return result.fold((f) => Left(f), (r) => Right(r));
        } else {
          // 2. PERMANENTLY delete data from remote
          final result = await _remote.delete(id).timeout(kRequestTimeout);
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

  bool _hasDataChanged({
    required List<PlanEntity> local,
    required List<PlanEntity> remote,
  }) {
    // 1. Compare lengths
    if (local.length != remote.length) {
      return true;
    }

    final localMap = {for (var item in local) item.id: item};

    // 2. Compare updated dates
    for (final remoteItem in remote) {
      final localItem = localMap[remoteItem.id];

      if (localItem == null || localItem.updatedAt != remoteItem.updatedAt) {
        return true;
      }
    }

    // 3. Compare soft delete items
    for (final remoteItem in remote) {
      final localItem = localMap[remoteItem.id];

      if (localItem != null && localItem.deletedAt != remoteItem.deletedAt) {
        return true;
      }
    }

    return false;
  }

  Future<void> _mergeAndUpdate({
    required List<PlanModel> local,
    required List<PlanModel> remote,
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
      final remoteMap = {for (var item in remote) item.id: item};

      // 1. Find items to add/update
      for (final remoteItem in remote) {
        final localItem = localMap[remoteItem.id];

        if (localItem == null) {
          // New item - insert
          await _local.add(remoteItem.toModel());
        } else if (localItem.updatedAt != remoteItem.updatedAt) {
          // Updated item - update
          await _local.update(remoteItem.toModel());
        }
      }

      // 2. Find items to delete (exist in local but not in remote)
      for (final localItem in local) {
        if (!remoteMap.containsKey(localItem.id)) {
          await _local.delete(localItem.id);
        }
      }

      // 3. Dispatch event to notify
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
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/plan_entity.dart';

class PlanModel {
  String id;
  String title;
  final int position;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  DateTime? syncedAt;

  PlanModel({
    required this.id,
    required this.title,
    required this.position,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.syncedAt,
  });

  /// Entity Serialization
  factory PlanModel.fromEntity(PlanEntity entity) {
    return PlanModel(
      id: entity.id,
      title: entity.title,
      position: entity.position,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      syncedAt: entity.syncedAt,
    );
  }

  PlanEntity toEntity() {
    return PlanEntity(
      id: id,
      title: title,
      position: position,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      syncedAt: syncedAt,
    );
  }

  /// Firestore Serialization
  factory PlanModel.fromFirestore(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as String,
      title: json['title'] as String,
      position: json['position'] as int,
      createdAt: (json['created_at'] as Timestamp).toDate(),
      updatedAt: json['updated_at'] != null
          ? (json['updated_at'] as Timestamp).toDate()
          : null,
      deletedAt: json['deleted_at'] != null
          ? (json['deleted_at'] as Timestamp).toDate()
          : null,
      syncedAt: json['synced_at'] != null
          ? (json['synced_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'position': position,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'deleted_at': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
      'synced_at': syncedAt != null ? Timestamp.fromDate(syncedAt!) : null,
    };
  }

  /// Json Serialization
  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as String,
      title: json['title'] as String,
      position: json['position'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      syncedAt: json['synced_at'] != null
          ? DateTime.parse(json['synced_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'position': position,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
    };
  }
}
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class PlanEntity extends Equatable {
  final String id;
  final String title;
  final int position;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? syncedAt;

  const PlanEntity({
    required this.id,
    required this.title,
    required this.position,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.syncedAt,
  });

  PlanEntity copyWith({
    String? id,
    String? title,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return PlanEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

    factory PlanEntity.create({
    required String id,
    required String title,
    required int position,
  }) {
    return PlanEntity(
      id: id,
      title: title,
      position: position,
      createdAt: DateTime.now(),
      updatedAt: null,
      deletedAt: null,
      syncedAt: null,
    );
  }

    // Business methods
  PlanEntity markAsUpdated() {
    return copyWith(updatedAt: DateTime.now());
  }

  PlanEntity markAsSynced() {
    return copyWith(syncedAt: DateTime.now());
  }

  PlanEntity markAsDeleted() {
    return copyWith(deletedAt: DateTime.now());
  }

  bool get isDeleted => deletedAt != null;
  bool get isSynced => syncedAt != null;
  bool get needsSync => updatedAt != null && 
                        (syncedAt == null || updatedAt!.isAfter(syncedAt!));

  // Empty state
  static const PlanEntity empty = PlanEntity(
    id: '',
    title: '',
    position: 0,
    createdAt: const Duration(), // hoặc dùng DateTime(0)
  );

  @override
  List<Object?> get props => [
    id,
    title,
    position,
    createdAt,
    updatedAt,
    deletedAt,
    syncedAt,
  ];
}
