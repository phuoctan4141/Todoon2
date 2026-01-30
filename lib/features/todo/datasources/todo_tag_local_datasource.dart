import 'package:todoon/core/services/local/hive_service.dart';
import 'package:todoon/core/services/local/hive_box_names.dart';
import 'package:todoon/features/todo/models/todo_tag_model.dart';

abstract class TodoTagLocalDataSource {
  Future<void> add(TodoTagModel model);
  Future<void> remove(String todoListId, String tagId);

  Future<List<String>> getTagIdsByTodoList(String todoListId);
  Future<List<String>> getTodoListIdsByTag(String tagId);
}

class TodoTagLocalDataSourceImpl implements TodoTagLocalDataSource {
  final HiveService _hive;

  TodoTagLocalDataSourceImpl(this._hive);

  String _key(String todoListId, String tagId) => '$todoListId-$tagId';

  @override
  Future<void> add(TodoTagModel model) async {
    await _hive.put<TodoTagModel>(
      HiveBoxNames.todoTags,
      _key(model.todoListId, model.tagId),
      model,
    );
  }

  @override
  Future<void> remove(String todoListId, String tagId) async {
    await _hive.delete(HiveBoxNames.todoTags, _key(todoListId, tagId));
  }

  @override
  Future<List<String>> getTagIdsByTodoList(String todoListId) async {
    final result = _hive.getAll<TodoTagModel>(HiveBoxNames.todoTags);

    return result.fold(
      (_) => [],
      (values) => values
          .where((e) => e.todoListId == todoListId)
          .map((e) => e.tagId)
          .toList(),
    );
  }

  @override
  Future<List<String>> getTodoListIdsByTag(String tagId) async {
    final result = _hive.getAll<TodoTagModel>(HiveBoxNames.todoTags);

    return result.fold(
      (_) => [],
      (values) => values
          .where((e) => e.tagId == tagId)
          .map((e) => e.todoListId)
          .toList(),
    );
  }
}
