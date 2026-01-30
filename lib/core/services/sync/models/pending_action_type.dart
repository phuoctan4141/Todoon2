import 'package:hive/hive.dart';

@HiveType(typeId: 21)
enum PendingActionType {
  @HiveField(0)
  addTodoTag,

  @HiveField(1)
  removeTodoTag,

  @HiveField(2)
  addNoteTag,

  @HiveField(3)
  removeNoteTag,

  @HiveField(4)
  reorderBlock,

  @HiveField(5)
  reorderTodo,
}
