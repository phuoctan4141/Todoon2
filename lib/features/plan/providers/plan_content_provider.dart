// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_final_fields, unused_field
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:todoon/core/services/sync/models/pending_action_model.dart';
import 'package:todoon/core/services/sync/models/pending_action_type.dart';
import 'package:todoon/core/services/sync/pending_action_sync_service.dart';
import 'package:todoon/core/utils/result_type.dart';
import 'package:todoon/features/common/state_render/state_render_impl.dart';
import 'package:todoon/features/common/state_render/state_renderer.dart';
import 'package:todoon/features/note/models/note_model.dart';
import 'package:todoon/features/note/models/note_tag_model.dart';
import 'package:todoon/features/note/repositories/note_repository.dart';
import 'package:todoon/features/note/repositories/note_tag_repository.dart';
import 'package:todoon/features/plan/models/plan_block_model.dart';
import 'package:todoon/features/plan/repositories/plan_block_repository.dart';
import 'package:todoon/features/plan/widgets/plan_view_mode.dart';
import 'package:todoon/features/tag/models/tag_model.dart';
import 'package:todoon/features/tag/repositories/tag_repository.dart';
import 'package:todoon/features/todo/models/todo_list_model.dart';
import 'package:todoon/features/todo/models/todo_model.dart';
import 'package:todoon/features/todo/models/todo_tag_model.dart';
import 'package:todoon/features/todo/repositories/todo_list_repository.dart';
import 'package:todoon/features/todo/repositories/todo_repository.dart';
import 'package:todoon/features/todo/repositories/todo_tag_repository.dart';

class PlanContentProvider extends ChangeNotifier {
  String _planId;
  String get planId => _planId;

  final PlanBlockRepository _planBlockRepo;
  final NoteRepository _noteRepo;
  final TodoListRepository _todoListRepo;
  final TodoRepository _todoRepo;
  final TagRepository _tagRepo;
  final NoteTagRepository _noteTagRepo;
  final TodoListTagRepository _todoTagRepo;
  final PendingActionSyncService _pendingAction;

  PlanContentProvider({
    String? planId,
    required PlanBlockRepository planBlockRepo,
    required NoteRepository noteRepo,
    required TodoListRepository todoListRepo,
    required TodoRepository todoRepo,
    required TagRepository tagRepo,
    required NoteTagRepository noteTagRepo,
    required TodoListTagRepository todoTagRepo,
    required PendingActionSyncService pendingAction,
  }) : _planId = planId ?? 'home',
       _planBlockRepo = planBlockRepo,
       _noteRepo = noteRepo,
       _todoListRepo = todoListRepo,
       _todoRepo = todoRepo,
       _tagRepo = tagRepo,
       _noteTagRepo = noteTagRepo,
       _todoTagRepo = todoTagRepo,
       _pendingAction = pendingAction;

  // ================= STATE =================
  FlowState _state = ContentState();
  FlowState get state => _state;

  PlanViewMode _viewMode = PlanViewMode.list;
  PlanViewMode get viewMode => _viewMode;

  // ================= DATA =================
  List<PlanBlockModel> _blocks = [];
  List<PlanBlockModel> get blocks => List.unmodifiable(_blocks);

  // ✅ ĐỔI SANG MAP ĐỂ TRA CỨU NHANH HƠN
  Map<String, NoteModel> _notes = {};
  Map<String, NoteModel> get notes => Map.unmodifiable(_notes);

  Map<String, TodoListModel> _todoLists = {};
  Map<String, TodoListModel> get todoLists => Map.unmodifiable(_todoLists);

  Map<String, List<TodoModel>> _todosByList = {};
  Map<String, List<TodoModel>> get todosByList =>
      Map.unmodifiable(_todosByList);

  Map<String, List<TagModel>> _tags = {};
  Map<String, List<TagModel>> get tags => Map.unmodifiable(_tags);

  List<NoteTagModel> _noteTags = [];
  List<NoteTagModel> get noteTags => List.unmodifiable(_noteTags);

  List<TodoTagModel> _todoTags = [];
  List<TodoTagModel> get todoTags => List.unmodifiable(_todoTags);

  Timer? _debounceTimer;

  // ================= LOAD =================
  Future<void> fetchByPLanId(String newPlanId) async {
    if (_planId == newPlanId) return;

    _planId = newPlanId;
    await fetchData();
  }

  Future<void> fetchData() async {
    _state = LoadingState(
      stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE,
    );
    notifyListeners();

    try {
      /// 1. fetch base data
      final results = await Future.wait([
        _planBlockRepo.getByPlanId(planId),
        _noteRepo.getByPlanId(planId),
        _todoListRepo.getByPlanId(planId),
        _tagRepo.getAll(),
      ]);

      final failure = firstFailureOf(results.cast<Either<Failure, Object>>());
      if (failure != null) {
        _state = ErrorState(
          StateRendererType.FULL_SCREEN_ERROR_STATE,
          failure.message,
        );
        notifyListeners();
        return;
      }

      /// 2. assign data
      _blocks = (results[0] as Either<Failure, List<PlanBlockModel>>).getOrElse(
        () => [],
      );

      // CHUYỂN LIST THÀNH MAP VỚI KEY LÀ UID
      final notesList = (results[1] as Either<Failure, List<NoteModel>>)
          .getOrElse(() => []);
      _notes = {for (var note in notesList) note.uid: note};

      final todoListsList = (results[2] as Either<Failure, List<TodoListModel>>)
          .getOrElse(() => []);
      _todoLists = {for (var list in todoListsList) list.uid: list};

      final allTags = (results[3] as Either<Failure, List<TagModel>>).getOrElse(
        () => [],
      );

      print('Lenght blocks:${_blocks.length}');

      /// 3. empty state
      if (_blocks.isEmpty && _notes.isEmpty && _todoLists.isEmpty) {
        _state = EmptyState('state.empty');
        notifyListeners();
        return;
      }

      /// 4. fetch todos by todoList
      _todosByList.clear();
      for (final list in _todoLists.values) {
        final todosResult = await _todoRepo.getByTodoListId(list.uid);
        _todosByList[list.uid] = todosResult.getOrElse(() => []);
      }

      /// 5. fetch noteTags
      _noteTags.clear();
      for (final note in _notes.values) {
        final result = await _noteTagRepo.getNoteTagsForNote(note.uid);
        _noteTags.addAll(result.getOrElse(() => []));
      }

      /// 6. fetch todoTags
      _todoTags.clear();
      for (final list in _todoLists.values) {
        final result = await _todoTagRepo.getTodoTagsForTodoList(list.uid);
        _todoTags.addAll(result.getOrElse(() => []));
      }

      /// 7. resolve tags for UI
      _tags.clear();

      // note -> tags
      for (final note in _notes.values) {
        final tagIds = _noteTags
            .where((e) => e.noteId == note.uid)
            .map((e) => e.tagId);

        _tags[note.uid] = allTags
            .where((tag) => tagIds.contains(tag.uid))
            .toList();
      }

      // todoList -> tags
      for (final list in _todoLists.values) {
        final tagIds = _todoTags
            .where((e) => e.todoListId == list.uid)
            .map((e) => e.tagId);

        _tags[list.uid] = allTags
            .where((tag) => tagIds.contains(tag.uid))
            .toList();
      }

      _state = ContentState();
      notifyListeners();
    } catch (e) {
      _state = ErrorState(
        StateRendererType.FULL_SCREEN_ERROR_STATE,
        e.toString(),
      );
      notifyListeners();
    }
  }

  // ================= ADD BLOCK =================
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

    if (type == PlanBlockType.note && noteModel != null) {
      final result = await _noteRepo.create(noteModel);
      result.fold(
        (f) =>
            _state = ErrorState(StateRendererType.POPUP_ERROR_STATE, f.message),
        (note) {
          refId = note.uid;
          // THÊM VÀO MAP
          _notes[note.uid] = note;
        },
      );
    }

    if (type == PlanBlockType.todo_list && todoListModel != null) {
      final result = await _todoListRepo.create(todoListModel);
      result.fold(
        (f) =>
            _state = ErrorState(StateRendererType.POPUP_ERROR_STATE, f.message),
        (list) {
          refId = list.uid;
          // THÊM VÀO MAP
          _todoLists[list.uid] = list;
        },
      );
    }

    if (refId == null) {
      notifyListeners();
      return;
    }

    final newBlock = PlanBlockModel(
      uid: const Uuid().v4(),
      planId: planId,
      refId: refId!,
      type: type,
      position: _blocks.length,
      createdAt: DateTime.now(),
      isSynced: false,
    );

    final blockResult = await _planBlockRepo.create(newBlock);
    blockResult.fold(
      (f) =>
          _state = ErrorState(StateRendererType.POPUP_ERROR_STATE, f.message),
      (block) {
        _blocks.add(block);
        _state = SuccessState('plan.blockAdded');
      },
    );

    notifyListeners();
  }

  // ================= REMOVE BLOCK =================
  Future<void> removeBlock(String blockId) async {
    _state = LoadingState(
      stateRendererType: StateRendererType.POPUP_LOADING_STATE,
    );
    notifyListeners();

    final block = _blocks.firstWhere(
      (b) => b.uid == blockId,
      orElse: () => PlanBlockModel.empty(),
    );

    if (block.uid.isEmpty) return;

    if (block.type == PlanBlockType.note) {
      await _noteRepo.delete(block.refId);
      // XÓA KHỎI MAP
      _notes.remove(block.refId);
    } else {
      await _todoListRepo.delete(block.refId);
      // XÓA KHỎI MAP
      _todoLists.remove(block.refId);
    }

    await _planBlockRepo.delete(blockId);
    _blocks.removeWhere((b) => b.uid == blockId);

    _state = SuccessState('plan.blockRemoved');
    notifyListeners();
  }

  // ================= REORDER =================
  Future<void> reorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;

    final reordered = List<PlanBlockModel>.from(_blocks);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);

    _blocks = reordered;
    notifyListeners();

    // update local
    _planBlockRepo.updateBlocks(blocks, true);
    // save action immediately
    final action = PendingActionModel(
      id: 'reorder_${DateTime.now().millisecondsSinceEpoch}',
      type: PendingActionType.reorderBlock,
      payload: {'blocks': _blocks},
      createdAt: DateTime.now(),
    );
    await _pendingAction.putLocal(action);

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 10), () async {
      await _pendingAction.execute(action);
    });
  }

  // ================= CHANGE VIEW MODE =================
  void changeViewMode() {
    _viewMode = _viewMode == PlanViewMode.list
        ? PlanViewMode.grid
        : PlanViewMode.list;
    notifyListeners();
  }

  void setViewMode(PlanViewMode mode) {
    if (_viewMode != mode) {
      _viewMode = mode;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
