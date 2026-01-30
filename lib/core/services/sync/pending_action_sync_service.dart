// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/services/sync/datasources/pending_action_local_datasource.dart';
import 'package:todoon/core/services/sync/models/pending_action_model.dart';
import 'package:todoon/core/services/sync/models/sync_names.dart';
import 'package:todoon/core/services/sync/pending_action_reducer.dart';
import 'package:todoon/core/services/sync/app_sync_sevice.dart';

class PendingActionSyncService
    implements BaseSyncService<PendingActionReducer> {
  final PendingActionLocalDataSource _local;
  final PendingActionReducer _reducer;
  final NetworkInfo _networkInfo;

  PendingActionSyncService(this._local, this._reducer, this._networkInfo);

  @override
  String get name => SyncNames.pendingActions;

  Future<void> putLocal(PendingActionModel action) async =>
      await _local.put(action);

  Future<void> execute(PendingActionModel action) async {
    try {
      if (await _networkInfo.isConnected) {
        await _reducer.reduce(action).whenComplete(() async {
          await _local.delete(action.id);
        });
      }
    } catch (_) {}
  }

  @override
  Future<void> push() async {
    if (!await _networkInfo.isConnected) return;

    final actions = await _local.getAll();

    for (final action in actions) {
      try {
        await _reducer.reduce(action).whenComplete(() async {
          await _local.delete(action.id);
        });
      } catch (_) {}
    }
  }

  @override
  Future<void> pull() async {
    return;
  }

  @override
  PendingActionReducer Function(PendingActionReducer action, bool isSynced)
  get onSyncStatusChanged =>
      (action, isSynced) => action;
}
