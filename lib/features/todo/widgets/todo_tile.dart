import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/consts.dart';

import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/core/utils/functions.dart';
import 'package:todoon/features/common/widgets/animated_delete_icon.dart';
import 'package:todoon/features/todo/models/todo_model.dart';

class TodoTile extends StatefulWidget {
  final TodoModel todo;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;
  final VoidCallback? onReminderTap;

  const TodoTile({
    super.key,
    required this.todo,
    this.onToggleCompleted,
    this.onDismissed,
    this.onTap,
    this.onReminderTap,
  });

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  double _dismissProgress = d0;

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    return Dismissible(
      key: ValueKey(todo.uid),
      direction: DismissDirection.endToStart,
      onDismissed: widget.onDismissed,
      onUpdate: (details) {
        setState(() {
          _dismissProgress = details.progress.clamp(d0, d1);
        });
      },
      background: _buildDismissBackground(context),
      child: ListTile(
        onTap: widget.onTap,
        leading: _buildCheckbox(context, todo),
        title: _buildTitle(context, todo),
        subtitle: _buildSubtitle(context, todo),
        trailing: _buildTrailing(context, todo),
      ),
    );
  }

  // ===== Dismiss background =====
  Widget _buildDismissBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppSize.s16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r8),
        color: context.colors.error,
      ),
      child: AnimatedDeleteIcon(
        progress: _dismissProgress,
        size: AppSize.s24,
        color: context.colors.onError,
      ),
    );
  }

  // ===== Checkbox =====
  Widget _buildCheckbox(BuildContext context, TodoModel todo) {
    return Checkbox(
      value: todo.isDone,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.r8)),
      ),
      activeColor: context.colors.primary,
      checkColor: context.colors.onPrimary,
      side: BorderSide(color: context.colors.outline),
      onChanged: widget.onToggleCompleted == null
          ? null
          : (value) => widget.onToggleCompleted!(value ?? false),
    );
  }

  // ===== Title =====
  Widget _buildTitle(BuildContext context, TodoModel todo) {
    return AnimatedOpacity(
      duration: Durations.medium1,
      opacity: todo.isDone ? AppColorValue.v60 : AppColorValue.v100,
      child: AnimatedDefaultTextStyle(
        duration: Durations.medium1,
        curve: Curves.easeOut,
        style: TextStyle(
          color: todo.isDone
              ? context.colors.onSurfaceVariant
              : context.colors.onSurface,
          decoration: todo.isDone
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
        child: Text(
          todo.content,
          maxLines: i1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // ===== Subtitle: dueDate + sync =====
  Widget? _buildSubtitle(BuildContext context, TodoModel todo) {
    if (todo.dueDate == null && todo.isSynced) return null;

    return Row(
      children: [
        if (todo.dueDate != null) ...[
          Icon(
            Icons.event,
            size: AppSize.s14,
            color: context.dueDateColor(todo.dueDate),
          ),
          const Gap(AppSize.s4),
          Text(
            formatDate(todo.dueDate!),
            style: context.text.bodySmall?.copyWith(
              color: context.dueDateColor(todo.dueDate),
            ),
          ),
        ],
        if (!todo.isSynced) ...[
          const Gap(AppSize.s8),
          Icon(
            Icons.sync_problem,
            size: AppSize.s14,
            color: context.colors.error,
          ),
        ],
      ],
    );
  }

  // ===== Trailing: reminder bell =====
  Widget _buildTrailing(BuildContext context, TodoModel todo) {
    final hasReminder = todo.reminderId != null || todo.dueDate != null;
    final isOverdue =
        todo.dueDate != null && todo.dueDate!.isBefore(DateTime.now());

    final tooltip = hasReminder ? 'action.editReminder' : 'action.addReminder';

    Color iconColor;
    if (todo.isDone) {
      iconColor = context.colors.onSurfaceVariant.withValues(
        alpha: AppColorValue.v40,
      );
    } else if (isOverdue) {
      iconColor = context.colors.error;
    } else if (hasReminder) {
      iconColor = context.colors.primary;
    } else {
      iconColor = context.colors.onSurfaceVariant;
    }

    return IconButton(
      tooltip: tooltip.tr(),
      icon: Icon(
        hasReminder ? Icons.notifications_active : Icons.notifications_none,
        size: AppSize.s24,
        color: iconColor,
      ),
      onPressed: todo.isDone ? null : widget.onReminderTap,
    );
  }
}
