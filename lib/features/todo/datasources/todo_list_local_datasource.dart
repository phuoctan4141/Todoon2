import 'package:todoon/core/services/local/base_local_datasource.dart';
import 'package:todoon/core/services/local/hive_box_names.dart';
import 'package:todoon/core/services/local/hive_service.dart';
import 'package:todoon/features/todo/models/todo_list_model.dart';

abstract class TodoListLocalDataSource
    implements BaseLocalDataSource<TodoListModel> {
  @override
  Future<List<TodoListModel>> getAll();
  Future<List<TodoListModel>> getByPlanId(String planId);
  @override
  Future<void> put(TodoListModel todolist);
  @override
  Future<void> softDelete(String uid);
  @override
  Future<List<TodoListModel>> getUnsynced();
}

class TodoListLocalDataSourceImpl implements TodoListLocalDataSource {
  final HiveService _hive;

  TodoListLocalDataSourceImpl(this._hive);

  @override
  Future<List<TodoListModel>> getAll() async {
    final result = _hive.getAll<TodoListModel>(HiveBoxNames.todoLists);

    return result.fold(
      (_) => <TodoListModel>[],
      (values) => values.where((e) => e.deletedAt == null).toList(),
    );
  }

  @override
  Future<List<TodoListModel>> getByPlanId(String planId) async {
    final result = _hive.getAll<TodoListModel>(HiveBoxNames.todoLists);

    return result.fold(
      (_) => <TodoListModel>[],
      (values) => values
          .where((e) => e.planId == planId && e.deletedAt == null)
          .toList(),
    );
  }

  @override
  Future<void> put(TodoListModel todolist) async {
    await _hive.put<TodoListModel>(
      HiveBoxNames.todoLists,
      todolist.uid,
      todolist,
    );
  }

  @override
  Future<void> softDelete(String uid) async {
    final result = _hive.get<TodoListModel>(HiveBoxNames.todoLists, uid);

    await result.fold((_) async {}, (todo) async {
      if (todo == null) return;

      await _hive.put<TodoListModel>(
        HiveBoxNames.todos,
        uid,
        todo.copyWith(deletedAt: DateTime.now(), isSynced: false),
      );
    });
  }

  @override
  Future<List<TodoListModel>> getUnsynced() async {
    final all = await getAll();
    return all.where((e) => !e.isSynced).toList();
  }
}
