import 'package:todoon/core/services/network/network_info.dart';

abstract class BaseSyncService<T> {
  final dynamic _local;
  final dynamic _remote;

  final T Function(T item, bool isSynced) onSyncStatusChanged;

  String get name;

  BaseSyncService(
    this._local,
    this._remote, {
    required this.onSyncStatusChanged,
  });

  Future<void> pull() async {
    final remoteData = await _remote.getAll();
    if (remoteData.isEmpty) return;

    await Future.wait(
      remoteData
          .map<Future<void>>((item) => Future(() => _local.put(item as T)))
          .toList(),
    );
  }

  Future<void> push() async {
    final unsyncedData = await _local.getUnsynced();
    if (unsyncedData.isEmpty) return;

    await Future.wait(
      unsyncedData.map<Future<void>>((item) async {
        await _remote.upsert(item);
        final updatedItem = onSyncStatusChanged(item, true);
        await _local.put(updatedItem);
      }).toList(),
    );
  }
}

class AppSyncService {
  final NetworkInfo _networkInfo;
  final List<BaseSyncService> _services;

  AppSyncService(this._networkInfo, this._services);

  Future<void> pullAll() async {
    if (!await _networkInfo.isConnected) return;

    for (final service in _services) {
      await service.pull();
    }
  }

  Future<void> pushAll() async {
    if (!await _networkInfo.isConnected) return;

    for (final service in _services) {
      await service.push();
    }
  }
}
