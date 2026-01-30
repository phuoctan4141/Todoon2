import 'package:todoon/core/services/sync/app_sync_sevice.dart';
import 'package:todoon/core/services/sync/models/sync_names.dart';
import 'package:todoon/features/note/datasources/note_local_datasource.dart';
import 'package:todoon/features/note/datasources/note_remote_datasource.dart';
import 'package:todoon/features/note/datasources/note_tag_local_datasource.dart';
import 'package:todoon/features/note/datasources/note_tag_remote_datasource.dart';
import 'package:todoon/features/note/models/note_model.dart';
import 'package:todoon/features/note/models/note_tag_model.dart';

class NoteSyncService extends BaseSyncService<NoteModel> {
  NoteSyncService(
    NoteLocalDataSource super.local,
    NoteRemoteDataSource super.remote,
  ) : super(
        onSyncStatusChanged: (item, status) => item.copyWith(isSynced: status),
      );

  @override
  String get name => SyncNames.notes;
}

class NoteTagSyncService implements BaseSyncService<NoteTagModel> {
  final NoteTagLocalDataSource _local;
  final NoteTagRemoteDataSource _remote;

  NoteTagSyncService(this._local, this._remote);

  @override
  String get name => SyncNames.noteTags;

  @override
  NoteTagModel Function(NoteTagModel item, bool isSynced)
  get onSyncStatusChanged =>
      (item, isSynced) => item;

  @override
  Future<void> pull() async {
    final remoteData = await _remote.getAll();
    if (remoteData.isEmpty) return;
    await Future.wait(remoteData.map(_local.add));
  }

  @override
  Future<void> push() async {}
}
