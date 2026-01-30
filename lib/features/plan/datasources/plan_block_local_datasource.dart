import 'package:todoon/core/services/local/base_local_datasource.dart';
import 'package:todoon/core/services/local/hive_box_names.dart';
import 'package:todoon/core/services/local/hive_service.dart';
import 'package:todoon/features/plan/models/plan_block_model.dart';

abstract class PlanBlockLocalDataSource
    implements BaseLocalDataSource<PlanBlockModel> {
  @override
  Future<List<PlanBlockModel>> getAll();

  Future<List<PlanBlockModel>> getByPlanId(String planId);

  @override
  Future<void> put(PlanBlockModel block);

  @override
  Future<void> softDelete(String uid);

  @override
  Future<List<PlanBlockModel>> getUnsynced();
}

class PlanBlockLocalDataSourceImpl implements PlanBlockLocalDataSource {
  final HiveService _hive;

  PlanBlockLocalDataSourceImpl(this._hive);

  @override
  Future<List<PlanBlockModel>> getAll() async {
    final result = _hive.getAll<PlanBlockModel>(HiveBoxNames.planBlocks);

    return result.fold(
      (_) => <PlanBlockModel>[],
      (values) => values.where((e) => e.deletedAt == null).toList(),
    );
  }

  @override
  Future<List<PlanBlockModel>> getByPlanId(String planId) async {
    final all = await getAll();
    print('Lenght all localBlocks:${all.length}');
    return all.where((e) => e.planId == planId).toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  @override
  Future<void> put(PlanBlockModel block) async {
    await _hive.put<PlanBlockModel>(HiveBoxNames.planBlocks, block.uid, block);
  }

  @override
  Future<void> softDelete(String uid) async {
    final result = _hive.get<PlanBlockModel>(HiveBoxNames.planBlocks, uid);

    await result.fold((_) async {}, (block) async {
      if (block == null) return;

      await _hive.put<PlanBlockModel>(
        HiveBoxNames.planBlocks,
        uid,
        block.copyWith(deletedAt: DateTime.now(), isSynced: false),
      );
    });
  }

  @override
  Future<List<PlanBlockModel>> getUnsynced() async {
    final all = await getAll();
    return all.where((e) => !e.isSynced).toList();
  }
}
