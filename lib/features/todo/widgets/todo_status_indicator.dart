import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/consts.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/common/widgets/animated_count.dart';
import 'package:todoon/features/todo/models/todo_status_model.dart';

class TodoStatusIndicator extends StatefulWidget {
  final int count;
  final TodoStatusType type;

  const TodoStatusIndicator({
    super.key,
    required this.count,
    required this.type,
  });

  @override
  State<TodoStatusIndicator> createState() => _TodoStatusIndicatorState();
}

class _TodoStatusIndicatorState extends State<TodoStatusIndicator> {
  int _displayCount = i0;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    if (widget.count > 0) {
      _visible = true;
      _displayCount = widget.count;
    }
  }

  @override
  void didUpdateWidget(covariant TodoStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 0 → 1 (xuất hiện + quay số)
    if (oldWidget.count == i0 && widget.count > i0) {
      _displayCount = i0;
      _visible = true;

      // cho 1 frame để AnimatedCount animate 0 → 1
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _displayCount = widget.count;
          });
        }
      });
      return;
    }

    /// 1 → 0 (quay số + biến mất)
    if (oldWidget.count > i0 && widget.count == i0) {
      _displayCount = i0;

      Future.microtask(() {
        if (mounted) {
          setState(() => _visible = false);
        }
      });
      return;
    }

    /// n → m (bình thường)
    _displayCount = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Durations.medium1,
      transitionBuilder: (child, anim) {
        return SizeTransition(
          sizeFactor: anim,
          axis: Axis.horizontal,
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      child: _visible
          ? _IndicatorShell(
              key: const ValueKey('shell'),
              count: _displayCount,
              type: widget.type,
            )
          : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }
}

class _IndicatorShell extends StatelessWidget {
  final int count;
  final TodoStatusType type;

  const _IndicatorShell({super.key, required this.count, required this.type});

  Color get _color => switch (type) {
    TodoStatusType.overdue => Colors.red,
    TodoStatusType.pending => Colors.orange,
    TodoStatusType.done => Colors.green,
  };

  IconData get _icon => switch (type) {
    TodoStatusType.overdue => Icons.error_outline,
    TodoStatusType.pending => Icons.schedule,
    TodoStatusType.done => Icons.check_circle_outline,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p8,
        vertical: AppPadding.p2,
      ),
      decoration: BoxDecoration(
        color: context.bgColorContainer(_color),
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: AppSize.s14, color: _color),
          const Gap(AppSize.s4),
          AnimatedCount(
            value: count,
            style: context.text.labelSmall?.copyWith(
              color: _color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
