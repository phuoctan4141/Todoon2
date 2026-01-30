import 'package:todoon/core/services/sync/app_sync_sevice.dart';
import 'package:todoon/core/services/sync/models/sync_names.dart';
import 'package:todoon/features/plan/datasources/plan_block_local_datasource.dart';
import 'package:todoon/features/plan/datasources/plan_block_remote_datasource.dart';
import 'package:todoon/features/plan/datasources/plan_local_datasource.dart';
import 'package:todoon/features/plan/datasources/plan_remote_datasource.dart';
import 'package:todoon/features/plan/models/plan_block_model.dart';
import 'package:todoon/features/plan/models/plan_model.dart';

class PlanSyncService extends BaseSyncService<PlanModel> {
  PlanSyncService(
    PlanLocalDataSource super.local,
    PlanRemoteDataSource super.remote,
  ) : super(
        onSyncStatusChanged: (item, status) => item.copyWith(isSynced: status),
      );

  @override
  String get name => SyncNames.plans;
}

class PlanBlockSyncService extends BaseSyncService<PlanBlockModel> {
  PlanBlockSyncService(
    PlanBlockLocalDataSource super.local,
    PlanBlockRemoteDataSource super.remote,
  ) : super(
        onSyncStatusChanged: (item, status) => item.copyWith(isSynced: status),
      );

  @override
  String get name => SyncNames.planBlocks;
}
