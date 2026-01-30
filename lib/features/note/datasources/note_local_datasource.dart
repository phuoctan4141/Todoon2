import 'package:todoon/core/services/local/base_local_datasource.dart';
import 'package:todoon/core/services/local/hive_box_names.dart';
import 'package:todoon/core/services/local/hive_service.dart';
import 'package:todoon/features/note/models/note_model.dart';

abstract class NoteLocalDataSource implements BaseLocalDataSource<NoteModel> {
  @override
  Future<List<NoteModel>> getAll();

  Future<List<NoteModel>> getByPlanId(String planId);

  @override
  Future<void> put(NoteModel note);

  @override
  Future<void> softDelete(String uid);

  @override
  Future<List<NoteModel>> getUnsynced();
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final HiveService _hive;

  NoteLocalDataSourceImpl(this._hive);

  @override
  Future<List<NoteModel>> getAll() async {
    final result = _hive.getAll<NoteModel>(HiveBoxNames.notes);

    return result.fold(
      (_) => <NoteModel>[],
      (values) => values.where((e) => e.deletedAt == null).toList(),
    );
  }

  @override
  Future<List<NoteModel>> getByPlanId(String planId) async {
    final result = _hive.getAll<NoteModel>(HiveBoxNames.notes);

    return result.fold(
      (_) => <NoteModel>[],
      (values) => values
          .where((e) => e.planId == planId && e.deletedAt == null)
          .toList(),
    );
  }

  @override
  Future<void> put(NoteModel note) async {
    await _hive.put<NoteModel>(HiveBoxNames.notes, note.uid, note);
  }

  @override
  Future<void> softDelete(String uid) async {
    final result = _hive.get<NoteModel>(HiveBoxNames.notes, uid);

    await result.fold((_) async {}, (note) async {
      if (note == null) return;

      await _hive.put<NoteModel>(
        HiveBoxNames.notes,
        uid,
        note.copyWith(deletedAt: DateTime.now(), isSynced: false),
      );
    });
  }

  @override
  Future<List<NoteModel>> getUnsynced() async {
    final all = await getAll();
    return all.where((e) => !e.isSynced).toList();
  }
}
