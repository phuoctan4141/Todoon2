import 'package:dartz/dartz.dart';

import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/result_type.dart';
import 'package:todoon/features/note/datasources/note_local_datasource.dart';
import 'package:todoon/features/note/datasources/note_remote_datasource.dart';
import 'package:todoon/features/note/models/note_model.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<NoteModel>>> getAll();

  Future<Either<Failure, List<NoteModel>>> getByPlanId(String planId);

  Future<Either<Failure, NoteModel>> create(NoteModel note);

  Future<Either<Failure, NoteModel>> update(NoteModel note);

  Future<Either<Failure, Unit>> delete(String uid);

  Future<Either<Failure, Unit>> sync();
}

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource _local;
  final NoteRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  NoteRepositoryImpl(this._local, this._remote, this._networkInfo);

  @override
  Future<Either<Failure, List<NoteModel>>> getAll() async {
    final localNotes = await _local.getAll();

    try {
      if (!await _networkInfo.isConnected) {
        return Right(localNotes);
      }

      final remoteNotes = await _remote.getAll();

      final filteredRemote = remoteNotes
          .where((e) => e.deletedAt == null)
          .toList();

      // Sync remote → local
      for (final note in filteredRemote) {
        await _local.put(note.copyWith(isSynced: true));
      }

      return Right(filteredRemote);
    } catch (_) {
      return Right(localNotes);
    }
  }

  @override
  Future<Either<Failure, List<NoteModel>>> getByPlanId(String planId) async {
    try {
      final localNotes = await _local.getByPlanId(planId);

      if (!await _networkInfo.isConnected) {
        return Right(localNotes);
      }

      final remoteNotes = await _remote.getByPlanId(planId);

      final filteredRemoteNotes = remoteNotes
          .where((e) => e.deletedAt == null)
          .toList();

      for (final note in filteredRemoteNotes) {
        await _local.put(note.copyWith(isSynced: true));
      }

      return Right(filteredRemoteNotes);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, NoteModel>> create(NoteModel note) async {
    try {
      final now = DateTime.now();

      final newNote = note.copyWith(
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );

      // Save local first
      await _local.put(newNote);

      if (await _networkInfo.isConnected) {
        await _remote.upsert(newNote);
        await _local.put(newNote.copyWith(isSynced: true));
      }

      return Right(newNote);
    } on ErrorHandler catch (e) {
      return Left(e.failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, NoteModel>> update(NoteModel note) async {
    try {
      final updated = note.copyWith(updatedAt: DateTime.now(), isSynced: false);

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

    try {
      final unsyncedNotes = await _local.getUnsynced();

      for (final note in unsyncedNotes) {
        await _remote.upsert(note);
        await _local.put(note.copyWith(isSynced: true));
      }

      return const Right(unit);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }
}
