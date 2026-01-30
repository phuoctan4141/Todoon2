import 'package:dartz/dartz.dart';

import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/result_type.dart';
import 'package:todoon/features/tag/datasources/tag_local_datasource.dart';
import 'package:todoon/features/tag/datasources/tag_remote_datasource.dart';
import 'package:todoon/features/tag/models/tag_model.dart';

abstract class TagRepository {
  Future<Either<Failure, List<TagModel>>> getAll();
  Future<Either<Failure, TagModel>> create(TagModel tag);
  Future<Either<Failure, TagModel>> update(TagModel tag);
  Future<Either<Failure, Unit>> delete(String uid);
  Future<Either<Failure, Unit>> sync();
}

class TagRepositoryImpl implements TagRepository {
  final TagLocalDataSource _local;
  final TagRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  TagRepositoryImpl(this._local, this._remote, this._networkInfo);

  @override
  Future<Either<Failure, List<TagModel>>> getAll() async {
    final localTags = await _local.getAll();
    final filteredLocal = localTags.where((e) => e.deletedAt == null).toList();

    try {
      if (!await _networkInfo.isConnected) {
        return Right(filteredLocal);
      }

      final remoteTags = await _remote.getAll();

      final filteredRemote = remoteTags
          .where((e) => e.deletedAt == null)
          .toList();

      // Sync remote → local
      for (final tag in filteredRemote) {
        await _local.put(tag.copyWith(isSynced: true));
      }

      return Right(filteredRemote);
    } catch (_) {
      return Right(filteredLocal);
    }
  }

  @override
  Future<Either<Failure, TagModel>> create(TagModel tag) async {
    try {
      final now = DateTime.now();

      final newTag = tag.copyWith(
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );

      // Save local first
      await _local.put(newTag);

      if (await _networkInfo.isConnected) {
        await _remote.upsert(newTag);
        await _local.put(newTag.copyWith(isSynced: true));
      }

      return Right(newTag);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, TagModel>> update(TagModel tag) async {
    try {
      final updated = tag.copyWith(updatedAt: DateTime.now(), isSynced: false);

      await _local.put(updated);

      if (await _networkInfo.isConnected) {
        await _remote.upsert(updated);
        await _local.put(updated.copyWith(isSynced: true));
      }

      return Right(updated);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String uid) async {
    try {
      // Soft delete local
      await _local.softDelete(uid);

      if (await _networkInfo.isConnected) {
        await _remote.softDelete(uid);
      }

      return const Right(unit);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> sync() async {
    if (!await _networkInfo.isConnected) {
      return const Right(unit);
    }

    final unsynced = await _local.getUnsynced();

    for (final tag in unsynced) {
      await _remote.upsert(tag);
      await _local.put(tag.copyWith(isSynced: true));
    }

    return const Right(unit);
  }
}
