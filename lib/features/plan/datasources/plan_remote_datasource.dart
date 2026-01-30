import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoon/core/services/firebase/firebase_auth_service.dart';
import 'package:todoon/core/services/firebase/firestore_collections.dart';
import 'package:todoon/core/services/firebase/firestore_service.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/features/plan/models/plan_model.dart';

abstract class PlanRemoteDataSource {
  Future<List<PlanModel>> getAll();
  Future<void> upsert(PlanModel plan);
  Future<void> softDelete(String uid);
}

class PlanRemoteDataSourceImpl implements PlanRemoteDataSource {
  final FirebaseAuthService _auth;
  final FirestoreService _firestore;

  PlanRemoteDataSourceImpl(this._auth, this._firestore);

  String get _userID =>
      _auth.currentUser?.uid ?? (throw DataSource.UNAUTHORISED.getFailure());

  CollectionReference<Map<String, dynamic>> get _ref => _firestore
      .collection(FirestoreCollections.users)
      .doc(_userID)
      .collection(FirestoreCollections.plans);

  @override
  Future<List<PlanModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => PlanModel.fromJson(e.data())).toList();
  }

  @override
  Future<void> upsert(PlanModel plan) async {
    await _ref.doc(plan.uid).set(plan.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> softDelete(String uid) async {
    await _ref.doc(uid).update({'deleted_at': Timestamp.now()});
  }
}
