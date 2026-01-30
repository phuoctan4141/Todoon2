// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todoon/core/services/local/hive_box_names.dart';
import 'package:todoon/core/services/local/hive_service.dart';
import 'package:todoon/features/note/models/note_tag_model.dart';

abstract class NoteTagLocalDataSource {
  Future<void> add(NoteTagModel model);
  Future<void> remove(String noteId, String tagId);

  Future<List<String>> getTagIdsByNote(String noteId);
  Future<List<String>> getNoteIdsByTag(String tagId);
}

class NoteTagLocalDataSourceImpl implements NoteTagLocalDataSource {
  final HiveService _hive;

  NoteTagLocalDataSourceImpl(this._hive);

  @override
  Future<void> add(NoteTagModel model) async {
    final key = '${model.noteId}_${model.tagId}';
    await _hive.put<NoteTagModel>(HiveBoxNames.noteTags, key, model);
  }

  @override
  Future<void> remove(String noteId, String tagId) async {
    final key = '${noteId}_$tagId';
    await _hive.delete(HiveBoxNames.noteTags, key);
  }

  @override
  Future<List<String>> getTagIdsByNote(String noteId) async {
    final result = _hive.getAll<NoteTagModel>(HiveBoxNames.noteTags);

    return result.fold(
      (_) => [],
      (values) =>
          values.where((e) => e.noteId == noteId).map((e) => e.tagId).toList(),
    );
  }

  @override
  Future<List<String>> getNoteIdsByTag(String tagId) async {
    final result = _hive.getAll<NoteTagModel>(HiveBoxNames.noteTags);

    return result.fold(
      (_) => [],
      (values) =>
          values.where((e) => e.tagId == tagId).map((e) => e.noteId).toList(),
    );
  }
}
