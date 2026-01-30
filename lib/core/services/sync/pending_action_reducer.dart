import 'package:todoon/core/services/sync/models/pending_action_model.dart';
import 'package:todoon/core/services/sync/models/pending_action_type.dart';
import 'package:todoon/features/plan/models/plan_block_model.dart';
import 'package:todoon/features/todo/models/todo_model.dart';
import 'package:todoon/routes/app_exports.dart';

abstract class PendingActionReducer {
  Future<void> reduce(PendingActionModel action);
}

class PendingActionReducerImpl implements PendingActionReducer {
  final NoteTagRemoteDataSource _noteTagRemote;
  final TodoTagRemoteDataSource _todoTagRemote;
  final TodoRemoteDataSource _todoRemote;
  final PlanBlockRepository _planBlockRepository;

  PendingActionReducerImpl(
    this._noteTagRemote,
    this._todoTagRemote,
    this._todoRemote,
    this._planBlockRepository,
  );

  @override
  Future<void> reduce(PendingActionModel action) async {
    switch (action.type) {
      case PendingActionType.addNoteTag:
        await _noteTagRemote.addTagToNote(
          noteId: action.payload['note_id'],
          tagId: action.payload['tag_id'],
        );
        break;

      case PendingActionType.removeNoteTag:
        await _noteTagRemote.removeTagFromNote(
          noteId: action.payload['note_id'],
          tagId: action.payload['tag_id'],
        );
        break;

      case PendingActionType.addTodoTag:
        await _todoTagRemote.addTagToTodoList(
          todoListId: action.payload['todo_list_id'],
          tagId: action.payload['tag_id'],
        );

      case PendingActionType.removeTodoTag:
        await _todoTagRemote.removeTagFromTodoList(
          todoListId: action.payload['todo_list_id'],
          tagId: action.payload['tag_id'],
        );

      case PendingActionType.reorderBlock:
        {
          final blocks = (action.payload['blocks'] as List)
              .cast<PlanBlockModel>();

          await _planBlockRepository.updateBlocks(blocks, false);
        }
        break;

      case PendingActionType.reorderTodo:
        final todo = TodoModel.fromJson(action.payload['todo']);
        await _todoRemote.upsert(todo);
        break;
    }
  }
}
