import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/consts.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/tag/models/tag_model.dart';
import 'package:todoon/features/tag/widgets/tag_horizontal_list.dart';
import 'package:todoon/features/todo/models/todo_list_model.dart';
import 'package:todoon/features/todo/models/todo_model.dart';
import 'package:todoon/features/todo/models/todo_status_model.dart';
import 'package:todoon/features/todo/widgets/todo_list_body_widget.dart';
import 'package:todoon/features/todo/widgets/todo_status_summary_widget.dart';

class TodoListCard extends StatelessWidget {
  final TodoListModel todoList;
  final List<TodoModel> todos;
  final List<TagModel> tags;

  final ValueChanged<int>? onReorderTodo;
  final ValueChanged<String>? onAddTodo;
  final ValueChanged<TodoModel>? onUpdateTodo;
  final ValueChanged<String>? onDeleteTodo;

  final VoidCallback? onTap;
  final VoidCallback? onMore;

  const TodoListCard({
    super.key,
    required this.todoList,
    required this.todos,
    required this.tags,
    this.onReorderTodo,
    this.onAddTodo,
    this.onUpdateTodo,
    this.onDeleteTodo,
    this.onTap,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final stats = TodoStats.fromTodos(todos);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(title: todoList.title, stats: stats, onMore: onMore),
            TodoListBodyWidget(
              todos: todos,
              onReorder: onReorderTodo,
              onUpdateTodo: onUpdateTodo,
              onDeleteTodo: onDeleteTodo,
            ),
            const Gap(AppSize.s8),
            _AddTodoInput(onAdd: onAddTodo),
            const Gap(AppSize.s8),
            TagHorizontalList(tags: tags),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final TodoStats stats;
  final VoidCallback? onMore;

  const _Header({required this.title, required this.stats, this.onMore});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.drag_handle_rounded,
          color: context.colors.onPrimaryContainer,
        ),
        const Gap(AppSize.s8),
        // Title
        Expanded(
          child: Text(
            title,
            maxLines: i1,
            overflow: TextOverflow.ellipsis,
            style: context.text.titleMedium?.copyWith(
              color: context.colors.onPrimaryContainer,
            ),
          ),
        ),
        // Status indicator
        TodoStatusSummary(stats: stats),
        // More
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: context.colors.onTertiaryContainer,
          ),
          onPressed: onMore,
        ),
      ],
    );
  }
}

class _AddTodoInput extends StatefulWidget {
  final ValueChanged<String>? onAdd;

  const _AddTodoInput({this.onAdd});

  @override
  State<_AddTodoInput> createState() => _AddTodoInputState();
}

class _AddTodoInputState extends State<_AddTodoInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(hintText: 'action.addTask'.tr()),
      onSubmitted: (value) {
        if (value.trim().isEmpty) return;
        widget.onAdd?.call(value.trim());
        _controller.clear();
      },
    );
  }
}
