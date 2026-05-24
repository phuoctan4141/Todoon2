import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/icons_manager.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/widgets/animated_delete_icon.dart';
import 'package:todoon/common/widgets/custom_dialog.dart';
import 'package:todoon/features/plan/domain/entities/plan_entity.dart';
import 'package:todoon/generated/locale_keys.g.dart';

class PlanTile extends StatefulWidget {
  final PlanEntity plan;
  final void Function(String) onDismissed;
  final void Function(String) onTapped;

  const PlanTile({
    super.key,
    required this.plan,
    required this.onDismissed,
    required this.onTapped,
  });

  @override
  State<PlanTile> createState() => _PlanTileState();
}

class _PlanTileState extends State<PlanTile> {
  double _dragProgress = 0.0;

  void _onDragUpdate(DismissUpdateDetails details) {
    setState(() {
      _dragProgress = details.progress.abs();
    });
  }

  void _onDismissed(DismissDirection direction) {
    widget.onDismissed(widget.plan.id);
  }

  Future<bool> _onConfirmDismiss(DismissDirection direction) async {
    final result = await CustomDialog.confirmationDialog<bool>(
      context: context,
      icon: Icon(Icons.delete, color: context.colors.error),
      title: LocaleKeys.action_deletePlan,
      subTitle: LocaleKeys.dialog_deletePlanMess,
      confirmText: LocaleKeys.action_deletePlan,
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.plan.id),
      background: _buildDismissBackground(context),
      direction: DismissDirection.endToStart,
      onUpdate: _onDragUpdate,
      onDismissed: _onDismissed,
      confirmDismiss: _onConfirmDismiss,
      child: Card(
        elevation: AppElevation.e3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r16),
          ),
          leading: CircleAvatar(
            backgroundColor: context.colors.secondaryContainer.withValues(
              alpha: AppColorValue.v30,
            ),
            child: Text(
              widget.plan.title.substring(0, 1).toUpperCase(),
              style: AppStyles.medium(
                color: context.colors.onSecondaryContainer,
              ),
            ),
          ),
          title: Text(widget.plan.title),
          onTap: () => widget.onTapped(widget.plan.id),
          trailing: Icon(AppIcons.next, color: context.colors.tertiary),
        ),
      ),
    );
  }

  Widget _buildDismissBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        color: context.colors.errorContainer,
      ),
      child: AnimatedDeleteIcon(
        progress: _dragProgress,
        size: 28,
        color: context.colors.onErrorContainer,
      ),
    );
  }
}
