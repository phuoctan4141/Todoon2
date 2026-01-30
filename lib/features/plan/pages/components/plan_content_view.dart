import 'package:flutter/material.dart';

import 'package:todoon/features/common/state_render/state_render_impl.dart';
import 'package:todoon/features/note/widgets/note_card.dart';
import 'package:todoon/features/plan/models/plan_block_model.dart';
import 'package:todoon/features/plan/providers/plan_content_provider.dart';
import 'package:todoon/features/plan/widgets/plan_block_grid_view_widget.dart';
import 'package:todoon/features/plan/widgets/plan_block_list_view_widget.dart';
import 'package:todoon/features/plan/widgets/plan_view_mode.dart';
import 'package:todoon/features/todo/widgets/todo_list_card.dart';

class PlanContentView extends StatefulWidget {
  final PlanContentProvider provider;

  const PlanContentView({super.key, required this.provider});

  @override
  State<PlanContentView> createState() => _PlanContentViewState();
}

class _PlanContentViewState extends State<PlanContentView> {
  late PlanContentProvider _provider;
  late List<PlanBlockModel> _blocks = [];

  @override
  void initState() {
    super.initState();
    _provider = widget.provider;
  }

  @override
  void didUpdateWidget(covariant PlanContentView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.provider.blocks != widget.provider.blocks) {
      setState(() {
        _blocks = widget.provider.blocks;
      });
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    // updatePositions
    _provider.reorder(oldIndex, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return _provider.state.getScreenWidget(context, _getView(), () {});
  }

  Widget _getView() {
    if (_provider.viewMode == PlanViewMode.list) {
      return PlanBlockListViewWidget(
        blocks: _blocks,
        onReorder: (oldIndex, newIndex) => _onReorder(oldIndex, newIndex),
        itemBuilder: _buildBlock,
      );
    } else {
      return PlanBlockGridViewWidget(blocks: _blocks, itemBuilder: _buildBlock);
    }
  }

  Widget _buildBlock(PlanBlockModel block) {
    final notes = _provider.notes;
    final todoLists = _provider.todoLists;
    final todosByList = _provider.todosByList;
    final tags = _provider.tags;

    switch (block.type) {
      case PlanBlockType.note:
        {
          final note = notes[block.refId];
          if (note == null) {
            return SizedBox.shrink(key: ValueKey('empty_${block.uid}'));
          }
          return NoteCard(
            key: ValueKey(block.uid),
            note: note,
            tags: tags[note.uid] ?? [],
          );
        }
      case PlanBlockType.todo_list:
        {
          final list = todoLists[block.refId];
          if (list == null) {
            return SizedBox.shrink(key: ValueKey('empty_${block.uid}'));
          }
          return TodoListCard(
            key: ValueKey(block.uid),
            todoList: list,
            todos: todosByList[list.uid] ?? const [],
            tags: tags[list.uid] ?? [],
          );
        }
    }
  }
}
