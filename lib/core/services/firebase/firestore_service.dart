import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/result_type.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===== INIT =====
  static Future<FirestoreService> init({
    bool useEmulator = false,
    String emulatorHost = '192.168.1.5',
    int emulatorPort = 8080,
  }) async {
    if (useEmulator) {
      FirebaseFirestore.instance.useFirestoreEmulator(
        emulatorHost,
        emulatorPort,
      );
    }
    return _instance;
  }

  // ===== CREATE / UPSERT =====

  Future<Either<Failure, Unit>> upsert({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(docId)
          .set(data, SetOptions(merge: true));
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  // ===== UPDATE =====

  Future<Either<Failure, Unit>> update({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  // ===== DELETE =====

  Future<Either<Failure, Unit>> delete({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  // ===== GET ONE =====

  Future<Either<Failure, Map<String, dynamic>?>> getOne({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      final doc = await _firestore.collection(collectionPath).doc(docId).get();

      if (!doc.exists) {
        return const Right(null);
      }

      return Right({'id': doc.id, ...doc.data()!});
    } on FirebaseException catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  // ===== GET ALL =====

  Future<Either<Failure, List<Map<String, dynamic>>>> getAll(
    String collectionPath,
  ) async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();

      final result = snapshot.docs
          .map((e) => {'id': e.id, ...e.data()})
          .toList();

      return Right(result);
    } on FirebaseException catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      return Left(DefaultFailure());
    }
  }

  // ===== STREAM =====

  Stream<Either<Failure, List<Map<String, dynamic>>>> streamAll(
    String collectionPath,
  ) async* {
    try {
      await for (final snapshot
          in _firestore.collection(collectionPath).snapshots()) {
        yield Right(
          snapshot.docs.map((e) => {'id': e.id, ...e.data()}).toList(),
        );
      }
    } on FirebaseException catch (e) {
      yield Left(ErrorHandler.handle(e).failure);
    } catch (_) {
      yield Left(DefaultFailure());
    }
  }

  // ===== GET COLLECTION =====

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }
}
