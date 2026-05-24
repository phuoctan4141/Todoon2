import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:todoon/core/resources/strings_manager.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void initEmulator({
    bool useEmulator = true,
    String emulatorHost = '192.168.1.11',
    int emulatorPort = 8080,
  }) {
    if (useEmulator) {
      _firestore.useFirestoreEmulator(emulatorHost, emulatorPort);
    }
  }

  /// === CREATE ===
  Future<Either<Failure, Unit>> create({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).set(data);
      debugPrint(
        AppStrings.info(
          tag: 'FirestoreService.create',
          message: 'Data added successfully',
        ),
      );
      return const Right(unit);
    } on FirebaseException catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.create',
          message: 'Failed to add data: $e',
        ),
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.create',
          message: 'Unexpected error: $e',
        ),
      );
      return Left(UnknownFailure());
    }
  }

  /// === GET ===
  Future<Either<Failure, Map<String, dynamic>?>> get({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      final doc = await _firestore.collection(collectionPath).doc(docId).get();
      debugPrint(
        AppStrings.info(
          tag: 'FirestoreService.get',
          message: 'Document fetched successfully',
        ),
      );
      return Right(doc.data());
    } on FirebaseException catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.get',
          message: 'Failed to get document: $e',
        ),
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.get',
          message: 'Unexpected error: $e',
        ),
      );
      return Left(UnknownFailure());
    }
  }

  /// === GET ALL ===
  Future<Either<Failure, List<Map<String, dynamic>>>> getAll({
    required String collectionPath,
  }) async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();
      final dataList = snapshot.docs.map((doc) => doc.data()).toList();
      debugPrint(
        AppStrings.info(
          tag: 'FirestoreService.getAll',
          message:
              'All documents fetched successfully (${dataList.length} items)',
        ),
      );
      return Right(dataList);
    } on FirebaseException catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.getAll',
          message: 'Failed to get collection: $e',
        ),
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.getAll',
          message: 'Unexpected error: $e',
        ),
      );
      return Left(UnknownFailure());
    }
  }

  /// === UPDATE ===
  Future<Either<Failure, Unit>> update({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
      debugPrint(
        AppStrings.info(
          tag: 'FirestoreService.update',
          message: 'Document updated successfully',
        ),
      );
      return const Right(unit);
    } on FirebaseException catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.update',
          message: 'Failed to update document: $e',
        ),
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.update',
          message: 'Unexpected error: $e',
        ),
      );
      return Left(UnknownFailure());
    }
  }

  /// === UPSERT ===
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
      debugPrint(
        AppStrings.info(
          tag: 'FirestoreService.upsert',
          message: 'Document upserted successfully',
        ),
      );
      return const Right(unit);
    } on FirebaseException catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.upsert',
          message: 'Failed to upsert document: $e',
        ),
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.upsert',
          message: 'Unexpected error: $e',
        ),
      );
      return Left(UnknownFailure());
    }
  }

  /// === DELETE ===
  Future<Either<Failure, Unit>> delete({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
      debugPrint(
        AppStrings.info(
          tag: 'FirestoreService.delete',
          message: 'Document deleted successfully',
        ),
      );
      return const Right(unit);
    } on FirebaseException catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.delete',
          message: 'Failed to delete document: $e',
        ),
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.delete',
          message: 'Unexpected error: $e',
        ),
      );
      return Left(UnknownFailure());
    }
  }

  /// === DELETE ALL ===
  Future<Either<Failure, Unit>> deleteAll({
    required String collectionPath,
  }) async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      debugPrint(
        AppStrings.info(
          tag: 'FirestoreService.deleteAll',
          message:
              'All documents deleted successfully (${snapshot.docs.length} items)',
        ),
      );
      return const Right(unit);
    } on FirebaseException catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.deleteAll',
          message: 'Failed to delete collection: $e',
        ),
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      debugPrint(
        AppStrings.error(
          tag: 'FirestoreService.deleteAll',
          message: 'Unexpected error: $e',
        ),
      );
      return Left(UnknownFailure());
    }
  }
}
