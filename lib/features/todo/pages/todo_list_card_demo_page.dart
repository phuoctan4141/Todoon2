import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/tag_color_extension.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/note/models/note_model.dart';
import 'package:todoon/features/note/widgets/note_card.dart';
import 'package:todoon/features/tag/models/tag_model.dart';
import 'package:todoon/features/todo/widgets/todo_list_card.dart';
import 'package:uuid/uuid.dart';

import 'package:todoon/features/todo/models/todo_model.dart';
import 'package:todoon/features/todo/models/todo_list_model.dart';

class TodoListCardDemoPage extends StatefulWidget {
  const TodoListCardDemoPage({super.key});

  @override
  State<TodoListCardDemoPage> createState() => _TodoListCardDemoPageState();
}

class _TodoListCardDemoPageState extends State<TodoListCardDemoPage> {
  final _uuid = const Uuid();

  late TodoListModel _todoList;
  late List<TodoModel> _todos;
  late List<TagModel> _tags;

  @override
  void initState() {
    super.initState();

    _todoList = TodoListModel(
      uid: 'list_001',
      planId: 'plan_001',
      title: 'Morning Tasks',
      createdAt: DateTime.now(),
    );

    _todos = [
      TodoModel(
        uid: 'todo_001',
        listId: _todoList.uid,
        content: 'Check email',
        isDone: false,
        position: 0,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      ),
      TodoModel(
        uid: 'todo_002',
        listId: _todoList.uid,
        content: 'Daily standup meeting',
        isDone: true,
        position: 1,
        createdAt: DateTime.now(),
      ),
      TodoModel(
        uid: 'todo_003',
        listId: _todoList.uid,
        content: 'Review pull requests',
        isDone: false,
        position: 2,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now(),
      ),
    ];

    _tags = [
      TagModel(
        uid: 'tag_work',
        name: 'work',
        color: TagColorEnum.orange,
        createdAt: DateTime.now(),
      ),
    ];
  }

  void _addTodo(String content) {
    setState(() {
      _todos.add(
        TodoModel(
          uid: _uuid.v4(),
          listId: _todoList.uid,
          content: content,
          isDone: false,
          position: _todos.length,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  void _updateTodo(TodoModel updated) {
    setState(() {
      final index = _todos.indexWhere((e) => e.uid == updated.uid);
      if (index != -1) {
        _todos[index] = updated;
      }
    });
  }

  void _deleteTodo(String uid) {
    setState(() {
      _todos.removeWhere((e) => e.uid == uid);
      for (var i = 0; i < _todos.length; i++) {
        _todos[i] = _todos[i].copyWith(position: i);
      }
    });
  }

  void _reorderTodo(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _todos.removeAt(oldIndex);
      _todos.insert(newIndex, item);

      for (var i = 0; i < _todos.length; i++) {
        _todos[i] = _todos[i].copyWith(position: i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TodoListCard Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TodoListCard(
              todoList: _todoList,
              todos: _todos,
              tags: _tags,
              onAddTodo: _addTodo,
              onUpdateTodo: _updateTodo,
              onDeleteTodo: _deleteTodo,
              onReorderTodo: (oldIndex) {
                // demo đơn giản: reorder xuống cuối
                _reorderTodo(oldIndex, _todos.length - 1);
              },
              onMore: () {},
            ),
            const Gap(AppSize.s8),
            NoteCard(
              note: NoteModel(
                uid: 'note_1',
                planId: 'plan_today',
                content: 'Hoàn thành UI note + tag hôm nay',
                createdAt: DateTime.now(),
              ),
              tags: <TagModel>[
                TagModel(
                  uid: 'tag_work',
                  name: 'work',
                  color: TagColorEnum.orange,
                  createdAt: DateTime.now(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
