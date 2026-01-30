import 'package:flutter/material.dart';
import 'package:todoon/core/resources/consts.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/plan/models/plan_block_model.dart';

abstract class PlanBlockChunk {}

class NoteBlockChunk extends PlanBlockChunk {}

class TodoListBlock extends PlanBlockChunk {}

class PlanBlockGridViewWidget extends StatelessWidget {
  final List<PlanBlockModel> blocks;
  final Widget Function(PlanBlockModel block) itemBuilder;

  const PlanBlockGridViewWidget({
    super.key,
    required this.blocks,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    List<List<PlanBlockModel>> segments = [];
    List<PlanBlockModel> noteBuffer = [];

    for (final block in blocks) {
      if (block.type == PlanBlockType.note) {
        noteBuffer.add(block);
      } else {
        if (noteBuffer.isNotEmpty) {
          segments.add(List.from(noteBuffer));
          noteBuffer.clear();
        }
        segments.add([block]); // todoList đứng riêng
      }
    }

    if (noteBuffer.isNotEmpty) {
      segments.add(List.from(noteBuffer));
    }

    return CustomScrollView(
      slivers: [
        for (final segment in segments)
          if (segment.first.type == PlanBlockType.note)
            _buildNoteGrid(segment, itemBuilder)
          else
            _buildTodoFull(segment.first, itemBuilder),
      ],
    );
  }

  Widget _buildNoteGrid(
    List<PlanBlockModel> blocks,
    Widget Function(PlanBlockModel block) itemBuilder,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppPadding.p4),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return itemBuilder(blocks[index]);
        }, childCount: blocks.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: i2,
          crossAxisSpacing: d8,
          mainAxisSpacing: d8,
          childAspectRatio: d0d7,
        ),
      ),
    );
  }

  Widget _buildTodoFull(
    PlanBlockModel block,
    Widget Function(PlanBlockModel block) itemBuilder,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p4),
        child: itemBuilder(block),
      ),
    );
  }
}
