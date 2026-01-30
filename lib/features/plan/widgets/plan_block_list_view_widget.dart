import 'package:flutter/material.dart';
import 'package:todoon/features/common/widgets/custom_reorderable_list.dart';
import 'package:todoon/features/plan/models/plan_block_model.dart';

class PlanBlockListViewWidget extends StatelessWidget {
  final List<PlanBlockModel> blocks;
  final Widget Function(PlanBlockModel block) itemBuilder;
  final void Function(int oldIndex, int newIndex) onReorder;

  const PlanBlockListViewWidget({
    super.key,
    required this.blocks,
    required this.itemBuilder,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return CustomReorderableList(
      itemCount: blocks.length,
      onReorder: onReorder,
      itemBuilder: (context, index) {
        final block = blocks[index];
        final widget = itemBuilder(block);

        return KeyedSubtree(
          key: widget.key ?? ValueKey(block.uid),
          child: widget,
        );
      },
    );
  }
}
