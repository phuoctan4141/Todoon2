// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todoon/core/services/sync/app_sync_sevice.dart';
import 'package:todoon/core/services/sync/models/sync_names.dart';
import 'package:todoon/features/todo/datasources/todo_list_local_datasource.dart';
import 'package:todoon/features/todo/datasources/todo_list_remote_datasource.dart';
import 'package:todoon/features/todo/datasources/todo_local_datasource.dart';
import 'package:todoon/features/todo/datasources/todo_remote_datasource.dart';
import 'package:todoon/features/todo/datasources/todo_tag_local_datasource.dart';
import 'package:todoon/features/todo/datasources/todo_tag_remote_datasource.dart';
import 'package:todoon/features/todo/models/todo_list_model.dart';
import 'package:todoon/features/todo/models/todo_model.dart';
import 'package:todoon/features/todo/models/todo_tag_model.dart';

class TodoListSyncService extends BaseSyncService<TodoListModel> {
  TodoListSyncService(
    TodoListLocalDataSource super.local,
    TodoListRemoteDataSource super.remote,
  ) : super(
        onSyncStatusChanged: (item, status) => item.copyWith(isSynced: status),
      );

  @override
  String get name => SyncNames.todoLists;
}

class TodoSyncService extends BaseSyncService<TodoModel> {
  TodoSyncService(
    TodoLocalDataSource super.local,
    TodoRemoteDataSource super.remote,
  ) : super(
        onSyncStatusChanged: (item, status) => item.copyWith(isSynced: status),
      );

  @override
  String get name => SyncNames.todos;
}

class TodoTagSyncService implements BaseSyncService<TodoTagModel> {
  final TodoTagLocalDataSource _local;
  final TodoTagRemoteDataSource _remote;

  TodoTagSyncService(this._local, this._remote);

  @override
  String get name => SyncNames.todoTags;

  @override
  TodoTagModel Function(TodoTagModel item, bool isSynced)
  get onSyncStatusChanged =>
      (item, isSynced) => item;

  @override
  Future<void> pull() async {
    final remoteData = await _remote.getAll();
    if (remoteData.isEmpty) return;
    await Future.wait(remoteData.map(_local.add));
  }

  @override
  Future<void> push() async {}
}
