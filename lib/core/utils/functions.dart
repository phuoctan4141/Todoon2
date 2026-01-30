import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoon/features/note/models/note_tag_model.dart';
import 'package:todoon/features/tag/models/tag_model.dart';
import 'package:todoon/features/todo/models/todo_tag_model.dart';

DateTime parseDate(dynamic value) {
  if (value == null) return DateTime.now();

  if (value is Timestamp) return value.toDate(); // Firestore
  if (value is DateTime) return value; // Local
  if (value is String) return DateTime.parse(value); // ISO
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value); // millis
  }

  throw UnsupportedError('Invalid date type: ${value.runtimeType}');
}

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

List<TagModel> getTagsForNote(
  String noteId,
  Map<String, List<TagModel>> tags,
  List<NoteTagModel> noteTags,
) {
  final tagIds = noteTags.where((e) => e.noteId == noteId).map((e) => e.tagId);

  return tagIds.map((uid) => tags[uid]).whereType<TagModel>().toList();
}

List<TagModel> getTagsForTodoList(
  String todoListId,
  Map<String, List<TagModel>> tags,
  List<TodoTagModel> todoTags,
) {
  final tagIds = todoTags
      .where((e) => e.todoListId == todoListId)
      .map((e) => e.tagId);

  return tagIds.map((uid) => tags[uid]).whereType<TagModel>().toList();
}
