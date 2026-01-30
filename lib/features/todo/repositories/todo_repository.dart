import 'package:dartz/dartz.dart';

import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/result_type.dart';
import 'package:todoon/features/todo/datasources/todo_local_datasource.dart';
import 'package:todoon/features/todo/datasources/todo_remote_datasource.dart';
import 'package:todoon/features/todo/models/todo_model.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoModel>>> getAll();
  Future<Either<Failure, List<TodoModel>>> getByTodoListId(String listId);
  Future<Either<Failure, TodoModel>> create(TodoModel todo);
  Future<Either<Failure, TodoModel>> update(TodoModel todo);
  Future<Either<Failure, Unit>> delete(String uid);
  Future<Either<Failure, Unit>> sync();
}

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource _local;
  final TodoRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  TodoRepositoryImpl(this._local, this._remote, this._networkInfo);

  @override
  Future<Either<Failure, List<TodoModel>>> getAll() async {
    final localTodos = await _local.getAll();

    try {
      if (!await _networkInfo.isConnected) {
        return Right(localTodos);
      }

      final remoteTodos = await _remote.getAll();

      final filteredRemoteTodos = remoteTodos
          .where((e) => e.deletedAt == null)
          .toList();

      // Sync remote → local
      for (final todo in filteredRemoteTodos) {
        await _local.put(todo.copyWith(isSynced: true));
      }

      return Right(filteredRemoteTodos);
    } catch (_) {
      return Right(localTodos);
    }
  }

  @override
  Future<Either<Failure, List<TodoModel>>> getByTodoListId(
    String listId,
  ) async {
    try {
      final localTodos = await _local.getByTodoListId(listId);
      if (!await _networkInfo.isConnected) return Right(localTodos);

      final remoteTodos = await _remote.getByTodoListId(listId);
      for (final todo in remoteTodos) {
        await _local.put(todo.copyWith(isSynced: true));
      }

      return Right(remoteTodos.where((t) => t.deletedAt == null).toList());
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, TodoModel>> create(TodoModel todo) async {
    try {
      final now = DateTime.now();

      final newTodo = todo.copyWith(
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );

      // Save local first
      await _local.put(newTodo);

      if (await _networkInfo.isConnected) {
        await _remote.upsert(newTodo);
        await _local.put(newTodo.copyWith(isSynced: true));
      }

      return Right(newTodo);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, TodoModel>> update(TodoModel todo) async {
    try {
      final updated = todo.copyWith(updatedAt: DateTime.now(), isSynced: false);

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

    final unsyncedTodos = await _local.getUnsynced();

    for (final todo in unsyncedTodos) {
      await _remote.upsert(todo);
      await _local.put(todo.copyWith(isSynced: true));
    }

    return const Right(unit);
  }
}
