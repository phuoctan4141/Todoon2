import 'package:dartz/dartz.dart';

import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/result_type.dart';
import 'package:todoon/features/todo/datasources/todo_list_local_datasource.dart';
import 'package:todoon/features/todo/datasources/todo_list_remote_datasource.dart';
import 'package:todoon/features/todo/models/todo_list_model.dart';

abstract class TodoListRepository {
  Future<Either<Failure, List<TodoListModel>>> getAll();
  Future<Either<Failure, List<TodoListModel>>> getByPlanId(String planId);
  Future<Either<Failure, TodoListModel>> create(TodoListModel todoList);
  Future<Either<Failure, TodoListModel>> update(TodoListModel todoList);
  Future<Either<Failure, Unit>> delete(String uid);
  Future<Either<Failure, Unit>> sync();
}

class TodoListRepositoryImpl implements TodoListRepository {
  final TodoListLocalDataSource _local;
  final TodoListRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  TodoListRepositoryImpl(this._local, this._remote, this._networkInfo);

  @override
  Future<Either<Failure, List<TodoListModel>>> getAll() async {
    final localLists = await _local.getAll();

    try {
      if (!await _networkInfo.isConnected) {
        return Right(localLists);
      }

      final remoteLists = await _remote.getAll();

      final filteredRemote = remoteLists
          .where((e) => e.deletedAt == null)
          .toList();

      // Sync remote → local
      for (final list in filteredRemote) {
        await _local.put(list.copyWith(isSynced: true));
      }

      return Right(filteredRemote);
    } catch (_) {
      return Right(localLists);
    }
  }

  @override
  Future<Either<Failure, List<TodoListModel>>> getByPlanId(
    String planId,
  ) async {
    try {
      final localTodoLists = await _local.getByPlanId(planId);

      if (!await _networkInfo.isConnected) {
        return Right(localTodoLists);
      }

      final remoteTodoLists = await _remote.getByPlanId(planId);

      final filteredRemoteTodoLists = remoteTodoLists
          .where((e) => e.deletedAt == null)
          .toList();

      for (final note in filteredRemoteTodoLists) {
        await _local.put(note.copyWith(isSynced: true));
      }

      return Right(filteredRemoteTodoLists);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, TodoListModel>> create(TodoListModel todoList) async {
    try {
      final now = DateTime.now();

      final newList = todoList.copyWith(
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );

      // Save local first
      await _local.put(newList);

      if (await _networkInfo.isConnected) {
        await _remote.upsert(newList);
        await _local.put(newList.copyWith(isSynced: true));
      }

      return Right(newList);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, TodoListModel>> update(TodoListModel todoList) async {
    try {
      final updated = todoList.copyWith(
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
      // Soft delete local
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

    final unsyncedLists = await _local.getUnsynced();

    for (final list in unsyncedLists) {
      await _remote.upsert(list);
      await _local.put(list.copyWith(isSynced: true));
    }

    return const Right(unit);
  }
}
