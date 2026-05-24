import 'package:dartz/dartz.dart';
import 'package:todoon/core/services/firebase/firebase_auth_service.dart';
import 'package:todoon/core/services/firebase/firestore_collections.dart';
import 'package:todoon/core/services/firebase/firestore_service.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/common/base/base_datasource.dart';
import 'package:todoon/features/plan/data/models/plan_model.dart';

abstract class PlanRemoteDataSource extends BaseRemoteDataSource<PlanModel> {
  @override
  Future<Either<Failure, List<PlanModel>>> getAll();
  @override
  Future<Either<Failure, PlanModel>> getById(String id);
  @override
  Future<Either<Failure, Unit>> add(PlanModel data);
  @override
  Future<Either<Failure, Unit>> update(PlanModel data);
  @override
  Future<Either<Failure, Unit>> delete(String id);
  @override
  Future<Either<Failure, Unit>> softDelete(PlanModel data);
}

class PlanRemoteDataSourceImpl implements PlanRemoteDataSource {
  final FirebaseAuthService _firebaseAuthService;
  final FirestoreService _firestoreService;

  PlanRemoteDataSourceImpl({
    required FirebaseAuthService firebaseAuthService,
    required FirestoreService firestoreService,
  }) : _firebaseAuthService = firebaseAuthService,
       _firestoreService = firestoreService;

  String get _collectionPath =>
      '${FirestoreCollections.users}/${_firebaseAuthService.currentUser?.uid}/${FirestoreCollections.plans}';

  @override
  Future<Either<Failure, List<PlanModel>>> getAll() async {
    final result = await _firestoreService.getAll(
      collectionPath: _collectionPath,
    );

    return result.fold(
      (f) => Left(f),
      (dataList) =>
          Right(dataList.map((e) => PlanModel.fromFirestore(e)).toList()),
    );
  }

  @override
  Future<Either<Failure, PlanModel>> getById(String id) async {
    final result = await _firestoreService.get(
      collectionPath: _collectionPath,
      docId: id,
    );

    return result.fold(
      (f) => Left(f),
      (d) => d != null
          ? Right(PlanModel.fromFirestore(d))
          : Left(DataSource.NOT_FOUND.getFailure()),
    );
  }

  @override
  Future<Either<Failure, Unit>> add(PlanModel data) async {
    return await _firestoreService.create(
      collectionPath: _collectionPath,
      docId: data.id,
      data: data.toFirestore(),
    );
  }

  @override
  Future<Either<Failure, Unit>> update(PlanModel data) async {
    return await _firestoreService.update(
      collectionPath: _collectionPath,
      docId: data.id,
      data: data.toFirestore(),
    );
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    return await _firestoreService.delete(
      collectionPath: _collectionPath,
      docId: id,
    );
  }

  @override
  Future<Either<Failure, Unit>> softDelete(PlanModel data) async {
    return await update(data);
  }
}
