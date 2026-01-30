import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todoon/features/plan/widgets/plan_view_mode.dart';
import 'package:uuid/uuid.dart';

import 'package:todoon/core/resources/consts.dart';
import 'package:todoon/core/services/sync/pending_action_reducer.dart';
import 'package:todoon/core/services/sync/models/pending_action_model.dart';
import 'package:todoon/core/services/sync/models/pending_action_type.dart';
import 'package:todoon/features/common/state_render/state_render_impl.dart';
import 'package:todoon/features/common/state_render/state_renderer.dart';
import 'package:todoon/features/plan/models/plan_block_model.dart';
import 'package:todoon/features/plan/repositories/plan_block_repository.dart';
import 'package:todoon/features/note/models/note_model.dart';
import 'package:todoon/features/note/repositories/note_repository.dart';
import 'package:todoon/features/todo/models/todo_list_model.dart';
import 'package:todoon/features/todo/repositories/todo_list_repository.dart';

class PlanPageProvider extends ChangeNotifier {
  final String planId;

  final PlanBlockRepository _planBlockRepo;
  final NoteRepository _noteRepo;
  final TodoListRepository _todoListRepo;
  final PendingActionReducer _pendingActionReducer;

  PlanPageProvider({
    required this.planId,
    required PlanBlockRepository planBlockRepo,
    required NoteRepository noteRepo,
    required TodoListRepository todoListRepo,
    required PendingActionReducer pendingActionReducer,
  }) : _planBlockRepo = planBlockRepo,
       _noteRepo = noteRepo,
       _todoListRepo = todoListRepo,
       _pendingActionReducer = pendingActionReducer;

  // ===== STATE =====
  FlowState _state = ContentState();
  FlowState get state => _state;

  PlanViewMode _viewMode = PlanViewMode.list;
  PlanViewMode get viewMode => _viewMode;

  List<PlanBlockModel> _blocks = [];
  List<PlanBlockModel> get blocks => List.unmodifiable(_blocks);

  Timer? _debounceTimer;

  Future<void> loadInitialData() async {
    _state = LoadingState(
      stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE,
    );
    notifyListeners();

    final result = await _planBlockRepo.getByPlanId(planId);

    result.fold(
      (failure) {
        _state = ErrorState(
          StateRendererType.FULL_SCREEN_ERROR_STATE,
          failure.message,
        );
      },
      (blocks) {
        _blocks = blocks..sort((a, b) => a.position.compareTo(b.position));
        _state = ContentState();
      },
    );

    notifyListeners();
  }

  void toggleViewMode() {
    _viewMode = _viewMode == PlanViewMode.list
        ? PlanViewMode.grid
        : PlanViewMode.list;
    notifyListeners();
  }

  // Thêm block (note hoặc todo list) - UI sẽ truyền model đầy đủ từ form
  Future<void> addBlock({
    required PlanBlockType type,
    NoteModel? noteModel,
    TodoListModel? todoListModel,
  }) async {
    _state = LoadingState(
      stateRendererType: StateRendererType.POPUP_LOADING_STATE,
    );
    notifyListeners();

    String? refId;

    if (type == PlanBlockType.note) {
      if (noteModel == null) return;

      final createResult = await _noteRepo.create(noteModel);
      createResult.fold((failure) {
        _state = ErrorState(
          StateRendererType.POPUP_ERROR_STATE,
          failure.message,
        );
      }, (createdNote) => refId = createdNote.uid);
    } else if (type == PlanBlockType.todo_list) {
      if (todoListModel == null) return;

      final createResult = await _todoListRepo.create(todoListModel);
      createResult.fold((failure) {
        _state = ErrorState(
          StateRendererType.POPUP_ERROR_STATE,
          failure.message,
        );
      }, (createdList) => refId = createdList.uid);
    }

    if (refId == null) return;

    final newBlock = PlanBlockModel(
      uid: Uuid().v4(),
      planId: planId,
      refId: refId ?? empty,
      type: type,
      position: _blocks.length,
      createdAt: DateTime.now(),
      isSynced: false,
    );

    final blockResult = await _planBlockRepo.create(newBlock);
    blockResult.fold(
      (failure) {
        _state = ErrorState(
          StateRendererType.POPUP_ERROR_STATE,
          failure.message,
        );
      },
      (createdBlock) {
        _blocks.add(createdBlock);
        _state = SuccessState('plan.blockAdded');
      },
    );

    notifyListeners();
  }

  // Xóa block (giữ nguyên)
  Future<void> removeBlock(String blockId) async {
    _state = LoadingState(
      stateRendererType: StateRendererType.POPUP_LOADING_STATE,
    );
    notifyListeners();

    try {
      final block = _blocks.firstWhere(
        (b) => b.uid == blockId,
        orElse: () => PlanBlockModel.empty(),
      );

      if (block.uid.isEmpty) return;

      if (block.type == PlanBlockType.note) {
        await _noteRepo.delete(block.refId);
      } else if (block.type == PlanBlockType.todo_list) {
        await _todoListRepo.delete(block.refId);
      }

      await _planBlockRepo.delete(blockId);
      _blocks.removeWhere((b) => b.uid == blockId);

      _state = SuccessState('plan.blockRemoved');
      notifyListeners();
    } catch (e) {
      _state = ErrorState(StateRendererType.POPUP_ERROR_STATE, e.toString());
      notifyListeners();
    }
  }

  // Reorder với debounce - dùng reducer
  Future<void> reorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;

    final reordered = List<PlanBlockModel>.from(_blocks);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);

    for (int i = 0; i < reordered.length; i++) {
      reordered[i] = reordered[i].copyWith(position: i, isSynced: false);
      await _planBlockRepo.update(reordered[i]);
    }

    _blocks = reordered;
    notifyListeners();

    // Debounce sync qua reducer
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () async {
      for (final block in _blocks) {
        final action = PendingActionModel(
          id: '${block.uid}_${DateTime.now().millisecondsSinceEpoch}',
          type: PendingActionType.reorderBlock,
          payload: {'block': block.toJson()},
          createdAt: DateTime.now(),
        );

        await _pendingActionReducer.reduce(action);
      }
    });
  }

  void changeViewMode() {
    _viewMode = _viewMode == PlanViewMode.list
        ? PlanViewMode.grid
        : PlanViewMode.list;
    notifyListeners();
  }

  void resetState() {
    if (_state.getStateRendererType() !=
        StateRendererType.CONTENT_SCREEN_STATE) {
      _state = ContentState();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
