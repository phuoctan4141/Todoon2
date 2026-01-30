import 'package:todoon/core/services/local/base_local_datasource.dart';
import 'package:todoon/core/services/local/hive_box_names.dart';
import 'package:todoon/core/services/local/hive_service.dart';
import 'package:todoon/features/plan/models/plan_model.dart';

abstract class PlanLocalDataSource implements BaseLocalDataSource<PlanModel> {
  @override
  Future<List<PlanModel>> getAll();
  @override
  Future<void> put(PlanModel plan);
  @override
  Future<void> softDelete(String uid);
  @override
  Future<List<PlanModel>> getUnsynced();

  Future<bool> exists(String uid);
}

class PlanLocalDataSourceImpl implements PlanLocalDataSource {
  final HiveService _hive;

  PlanLocalDataSourceImpl(this._hive);

  @override
  Future<List<PlanModel>> getAll() async {
    final result = _hive.getAll<PlanModel>(HiveBoxNames.plans);

    return result.fold(
      (_) => <PlanModel>[],
      (values) => values.where((e) => e.deletedAt == null).toList(),
    );
  }

  @override
  Future<void> put(PlanModel plan) async {
    await _hive.put<PlanModel>(HiveBoxNames.plans, plan.uid, plan);
  }

  @override
  Future<void> softDelete(String uid) async {
    final result = _hive.get<PlanModel>(HiveBoxNames.plans, uid);

    await result.fold((_) async {}, (plan) async {
      if (plan == null) return;

      await _hive.put<PlanModel>(
        HiveBoxNames.plans,
        uid,
        plan.copyWith(deletedAt: DateTime.now(), isSynced: false),
      );
    });
  }

  @override
  Future<List<PlanModel>> getUnsynced() async {
    final all = await getAll();
    return all.where((e) => !e.isSynced).toList();
  }

  @override
  Future<bool> exists(String uid) async {
    final result = _hive.get<PlanModel>(HiveBoxNames.plans, uid);

    return result.fold((_) => false, (plan) => plan != null);
  }
}
