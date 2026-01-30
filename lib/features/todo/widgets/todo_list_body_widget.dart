import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/todo/models/todo_model.dart';
import 'package:todoon/features/todo/widgets/todo_tile.dart';

enum TodoListDisplayMode {
  collapsed, // chỉ show 5
  expanded, // show hết
}

class TodoListBodyWidget extends StatefulWidget {
  static const int maxVisible = 5;

  final List<TodoModel> todos;

  /// Hybrid controlled
  final bool? isExpanded;
  final ValueChanged<bool>? onExpandedChanged;

  final ValueChanged<int>? onReorder;
  final ValueChanged<TodoModel>? onUpdateTodo;
  final ValueChanged<String>? onDeleteTodo;

  const TodoListBodyWidget({
    super.key,
    required this.todos,
    this.isExpanded,
    this.onExpandedChanged,
    this.onReorder,
    this.onUpdateTodo,
    this.onDeleteTodo,
  });

  @override
  State<StatefulWidget> createState() => _TodoListBodyWidgetState();
}

class _TodoListBodyWidgetState extends State<TodoListBodyWidget> {
  bool _internalExpanded = false;

  /// Hybrid: nếu bên ngoài truyền isExpanded thì dùng,
  /// không thì dùng state nội bộ
  bool get _isExpanded {
    return widget.isExpanded ?? _internalExpanded;
  }

  void _toggleExpanded() {
    final bool nextExpanded = !_isExpanded;

    // Notify parent (controlled mode)
    if (widget.onExpandedChanged != null) {
      widget.onExpandedChanged!(nextExpanded);
    }

    // Update internal state (uncontrolled mode)
    if (widget.isExpanded == null) {
      setState(() {
        _internalExpanded = nextExpanded;
      });
    }
  }

  List<TodoModel> get _visibleTodos {
    if (_isExpanded) {
      return widget.todos;
    }
    return widget.todos.take(TodoListBodyWidget.maxVisible).toList();
  }

  int get _remainingCount {
    return widget.todos.length - _visibleTodos.length;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.todos.isEmpty) {
      return const Gap(AppSize.s8);
    }

    return Column(
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _visibleTodos.length,
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex--;
            widget.onReorder?.call(oldIndex);
          },
          itemBuilder: (context, index) {
            final todo = _visibleTodos[index];

            return TodoTile(
              key: ValueKey(todo.uid),
              todo: todo,
              onDismissed: (_) => widget.onDeleteTodo?.call(todo.uid),
              onToggleCompleted: (done) {
                widget.onUpdateTodo?.call(todo.copyWith(isDone: done));
              },
              onReminderTap: () {},
            );
          },
        ),

        if (widget.todos.length > TodoListBodyWidget.maxVisible)
          _ToggleExpandedButton(
            isExpanded: _isExpanded,
            remainingCount: _remainingCount,
            onTap: _toggleExpanded,
          ),
      ],
    );
  }
}

class _ToggleExpandedButton extends StatelessWidget {
  final bool isExpanded;
  final int remainingCount;
  final VoidCallback onTap;

  const _ToggleExpandedButton({
    required this.isExpanded,
    required this.remainingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = isExpanded ? Icons.expand_less : Icons.expand_more;

    final text = isExpanded
        ? 'action.showLess'.tr()
        : 'action.showMore'.tr(namedArgs: {'count': remainingCount.toString()});

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.r8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppSize.s14, color: context.colors.primary),
            const Gap(AppSize.s4),
            Text(
              text,
              style: context.text.labelMedium?.copyWith(
                color: context.colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
