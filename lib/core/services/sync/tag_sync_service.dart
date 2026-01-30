import 'package:todoon/core/services/sync/app_sync_sevice.dart';
import 'package:todoon/core/services/sync/models/sync_names.dart';
import 'package:todoon/features/tag/datasources/tag_local_datasource.dart';
import 'package:todoon/features/tag/datasources/tag_remote_datasource.dart';
import 'package:todoon/features/tag/models/tag_model.dart';

class TagSyncService extends BaseSyncService<TagModel> {
  TagSyncService(
    TagLocalDataSource super.local,
    TagRemoteDataSource super.remote,
  ) : super(
        onSyncStatusChanged: (item, status) => item.copyWith(isSynced: status),
      );

  @override
  String get name => SyncNames.tags;
}
