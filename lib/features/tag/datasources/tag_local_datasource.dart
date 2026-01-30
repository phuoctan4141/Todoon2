import 'package:todoon/core/services/local/base_local_datasource.dart';
import 'package:todoon/core/services/local/hive_box_names.dart';
import 'package:todoon/core/services/local/hive_service.dart';
import 'package:todoon/features/tag/models/tag_model.dart';

abstract class TagLocalDataSource implements BaseLocalDataSource<TagModel> {
  @override
  Future<List<TagModel>> getAll();

  @override
  Future<void> put(TagModel tag);

  @override
  Future<void> softDelete(String uid);

  @override
  Future<List<TagModel>> getUnsynced();
}

class TagLocalDataSourceImpl implements TagLocalDataSource {
  final HiveService _hive;

  TagLocalDataSourceImpl(this._hive);

  @override
  Future<List<TagModel>> getAll() async {
    final result = _hive.getAll<TagModel>(HiveBoxNames.tags);

    return result.fold(
      (_) => <TagModel>[],
      (values) => values.where((e) => e.deletedAt == null).toList(),
    );
  }

  @override
  Future<void> put(TagModel tag) async {
    await _hive.put<TagModel>(HiveBoxNames.tags, tag.uid, tag);
  }

  @override
  Future<void> softDelete(String uid) async {
    final result = _hive.get<TagModel>(HiveBoxNames.tags, uid);

    await result.fold((_) async {}, (tag) async {
      if (tag == null) return;

      await _hive.put<TagModel>(
        HiveBoxNames.tags,
        uid,
        tag.copyWith(deletedAt: DateTime.now(), isSynced: false),
      );
    });
  }

  @override
  Future<List<TagModel>> getUnsynced() async {
    final all = await getAll();
    return all.where((e) => !e.isSynced).toList();
  }
}
