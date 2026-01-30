import 'package:todoon/features/todo/models/todo_model.dart';

enum TodoStatusType { overdue, pending, done }

class TodoStats {
  final int overdue;
  final int pending;
  final int done;

  const TodoStats({
    required this.overdue,
    required this.pending,
    required this.done,
  });

  factory TodoStats.fromTodos(List<TodoModel> todos) {
    final now = DateTime.now();

    return TodoStats(
      overdue: todos
          .where(
            (t) => !t.isDone && t.dueDate != null && t.dueDate!.isBefore(now),
          )
          .length,
      pending: todos
          .where(
            (t) => !t.isDone && (t.dueDate == null || t.dueDate!.isAfter(now)),
          )
          .length,
      done: todos.where((t) => t.isDone).length,
    );
  }
}
