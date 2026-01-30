import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/features/todo/models/todo_model.dart';
import 'package:todoon/features/todo/widgets/todo_tile.dart';

class TodoDemoPage extends StatefulWidget {
  const TodoDemoPage({super.key});

  @override
  State<TodoDemoPage> createState() => _TodoDemoPageState();
}

class _TodoDemoPageState extends State<TodoDemoPage> {
  final List<TodoModel> _todos = [
    TodoModel(
      uid: '1',
      content: 'Learn Flutter Material 3',
      isDone: false,
      listId: '',
      position: 1,
      createdAt: DateTime.now(),
    ),
    TodoModel(
      uid: '2',
      content: 'Refactor TodoListTile animation',
      isDone: true,
      listId: '',
      position: 2,
      createdAt: DateTime.now(),
    ),
    TodoModel(
      uid: '3',
      content: 'Build Todoon MVP',
      isDone: false,
      listId: '',
      position: 3,
      createdAt: DateTime.now(),
    ),
  ];

  void _toggleTodo(String uid, bool value) {
    setState(() {
      final index = _todos.indexWhere((t) => t.uid == uid);
      _todos[index] = _todos[index].copyWith(isDone: value);
    });
  }

  void _deleteTodo(String uid) {
    setState(() {
      _todos.removeWhere((t) => t.uid == uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Demo'),
        backgroundColor: context.colors.surface,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _todos.length,
        separatorBuilder: (_, m) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final todo = _todos[index];

          return TodoTile(
            todo: todo,
            onToggleCompleted: (value) => _toggleTodo(todo.uid, value),
            onDismissed: (_) => _deleteTodo(todo.uid),
            onTap: () {},
          );
        },
      ),
    );
  }
}
