// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/result_type.dart';
import 'package:todoon/features/note/datasources/note_tag_local_datasource.dart';
import 'package:todoon/features/note/datasources/note_tag_remote_datasource.dart';
import 'package:todoon/features/note/models/note_tag_model.dart';

abstract class NoteTagRepository {
  Future<Either<Failure, List<NoteTagModel>>> getNoteTagsForNote(String noteId);

  Future<Either<Failure, Unit>> addTagToNote({
    required String noteId,
    required String tagId,
  });

  Future<Either<Failure, Unit>> removeTagFromNote({
    required String noteId,
    required String tagId,
  });
}

class NoteTagRepositoryImpl implements NoteTagRepository {
  final NoteTagLocalDataSource _local;
  final NoteTagRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  NoteTagRepositoryImpl(this._local, this._remote, this._networkInfo);

  @override
  Future<Either<Failure, List<NoteTagModel>>> getNoteTagsForNote(
    String noteId,
  ) async {
    try {
      // only local
      final result = await _local
          .getTagIdsByNote(noteId)
          .then(
            (ids) => ids
                .map((id) => NoteTagModel(noteId: noteId, tagId: id))
                .toList(),
          );

      return Right(result);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addTagToNote({
    required String noteId,
    required String tagId,
  }) async {
    try {
      // 1. local
      await _local.add(NoteTagModel(noteId: noteId, tagId: tagId));

      // 2. remote -> online
      if (await _networkInfo.isConnected) {
        await _remote.addTagToNote(noteId: noteId, tagId: tagId);
      }

      return const Right(unit);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeTagFromNote({
    required String noteId,
    required String tagId,
  }) async {
    try {
      // 1. local
      await _local.remove(noteId, tagId);

      // 2. remote -> online
      if (await _networkInfo.isConnected) {
        await _remote.removeTagFromNote(noteId: noteId, tagId: tagId);
      }

      return const Right(unit);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }
}
