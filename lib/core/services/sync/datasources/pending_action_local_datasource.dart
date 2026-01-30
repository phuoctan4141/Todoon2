import 'package:todoon/core/services/local/hive_box_names.dart';
import 'package:todoon/core/services/local/hive_service.dart';
import 'package:todoon/core/services/sync/models/pending_action_model.dart';

abstract class PendingActionLocalDataSource {
  Future<List<PendingActionModel>> getAll();
  Future<void> put(PendingActionModel action);
  Future<void> delete(String id);
  Future<void> clear();
}

class PendingActionLocalDataSourceImpl implements PendingActionLocalDataSource {
  final HiveService _hive;

  PendingActionLocalDataSourceImpl(this._hive);

  static const _boxName = HiveBoxNames.pendingActions;

  @override
  Future<List<PendingActionModel>> getAll() async {
    final result = _hive.getAll<PendingActionModel>(_boxName);

    return result.fold(
      (_) => <PendingActionModel>[],
      (values) =>
          values.toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
    );
  }

  @override
  Future<void> put(PendingActionModel action) async {
    await _hive.put<PendingActionModel>(_boxName, action.id, action);
  }

  @override
  Future<void> delete(String id) async {
    await _hive.delete(_boxName, id);
  }

  @override
  Future<void> clear() async {
    await _hive.clear(_boxName);
  }
}
