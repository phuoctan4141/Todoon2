import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/todo/models/todo_status_model.dart';
import 'package:todoon/features/todo/widgets/todo_status_indicator.dart';

class TodoStatusSummary extends StatelessWidget {
  final TodoStats stats;

  const TodoStatusSummary({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TodoStatusIndicator(count: stats.overdue, type: TodoStatusType.overdue),
        const Gap(AppSize.s4),
        TodoStatusIndicator(count: stats.pending, type: TodoStatusType.pending),
        const Gap(AppSize.s4),
        TodoStatusIndicator(count: stats.done, type: TodoStatusType.done),
      ],
    );
  }
}
