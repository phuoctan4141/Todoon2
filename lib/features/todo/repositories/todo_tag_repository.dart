import 'package:dartz/dartz.dart';

import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/result_type.dart';
import 'package:todoon/features/todo/datasources/todo_tag_local_datasource.dart';
import 'package:todoon/features/todo/datasources/todo_tag_remote_datasource.dart';
import 'package:todoon/features/todo/models/todo_tag_model.dart';

abstract class TodoListTagRepository {
  Future<Either<Failure, List<TodoTagModel>>> getTodoTagsForTodoList(
    String todoId,
  );

  Future<Either<Failure, Unit>> addTagToTodoList({
    required String todoListId,
    required String tagId,
  });

  Future<Either<Failure, Unit>> removeTagFromTodoList({
    required String todoListId,
    required String tagId,
  });
}

class TodoListTagRepositoryImpl implements TodoListTagRepository {
  final TodoTagLocalDataSource _local;
  final TodoTagRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  TodoListTagRepositoryImpl(this._local, this._remote, this._networkInfo);

  @override
  Future<Either<Failure, List<TodoTagModel>>> getTodoTagsForTodoList(
    String todoListId,
  ) async {
    try {
      // only local
      final result = await _local
          .getTagIdsByTodoList(todoListId)
          .then(
            (ids) => ids
                .map((id) => TodoTagModel(todoListId: todoListId, tagId: id))
                .toList(),
          );

      return Right(result);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addTagToTodoList({
    required String todoListId,
    required String tagId,
  }) async {
    try {
      // 1. local
      await _local.add(TodoTagModel(todoListId: todoListId, tagId: tagId));

      // 2. remote (online)
      if (await _networkInfo.isConnected) {
        await _remote.addTagToTodoList(todoListId: todoListId, tagId: tagId);
      }

      return const Right(unit);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeTagFromTodoList({
    required String todoListId,
    required String tagId,
  }) async {
    try {
      // 1. local
      await _local.remove(todoListId, tagId);

      // 2. remote (online)
      if (await _networkInfo.isConnected) {
        await _remote.removeTagFromTodoList(
          todoListId: todoListId,
          tagId: tagId,
        );
      }

      return const Right(unit);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }
}
