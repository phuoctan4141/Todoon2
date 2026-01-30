import 'package:todoon/core/services/local/base_local_datasource.dart';
import 'package:todoon/core/services/local/hive_box_names.dart';
import 'package:todoon/core/services/local/hive_service.dart';
import 'package:todoon/features/todo/models/todo_model.dart';

abstract class TodoLocalDataSource implements BaseLocalDataSource<TodoModel> {
  @override
  Future<List<TodoModel>> getAll();
  Future<List<TodoModel>> getByTodoListId(String listId);
  @override
  Future<void> put(TodoModel todo);
  @override
  Future<void> softDelete(String uid);
  @override
  Future<List<TodoModel>> getUnsynced();
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final HiveService _hive;

  TodoLocalDataSourceImpl(this._hive);

  @override
  Future<List<TodoModel>> getAll() async {
    final result = _hive.getAll<TodoModel>(HiveBoxNames.todos);

    return result.fold(
      (_) => <TodoModel>[],
      (values) => values.where((e) => e.deletedAt == null).toList(),
    );
  }

  @override
  Future<List<TodoModel>> getByTodoListId(String listId) async {
    final all = await getAll();
    return all.where((t) => t.listId == listId).toList();
  }

  @override
  Future<void> put(TodoModel todo) async {
    await _hive.put<TodoModel>(HiveBoxNames.todos, todo.uid, todo);
  }

  @override
  Future<void> softDelete(String uid) async {
    final result = _hive.get<TodoModel>(HiveBoxNames.todos, uid);

    await result.fold((_) async {}, (todo) async {
      if (todo == null) return;

      await _hive.put<TodoModel>(
        HiveBoxNames.todos,
        uid,
        todo.copyWith(deletedAt: DateTime.now(), isSynced: false),
      );
    });
  }

  @override
  Future<List<TodoModel>> getUnsynced() async {
    final all = await getAll();
    return all.where((e) => !e.isSynced).toList();
  }
}
