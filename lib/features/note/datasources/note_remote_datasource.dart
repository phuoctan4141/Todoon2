import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoon/core/services/firebase/firebase_auth_service.dart';
import 'package:todoon/core/services/firebase/firestore_collections.dart';
import 'package:todoon/core/services/firebase/firestore_service.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/features/note/models/note_model.dart';

abstract class NoteRemoteDataSource {
  Future<List<NoteModel>> getAll();
  Future<List<NoteModel>> getByPlanId(String planId);
  Future<void> upsert(NoteModel note);
  Future<void> softDelete(String uid);
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final FirebaseAuthService _auth;
  final FirestoreService _firestore;

  NoteRemoteDataSourceImpl(this._auth, this._firestore);

  String get _userId =>
      _auth.currentUser?.uid ?? (throw DataSource.UNAUTHORISED.getFailure());

  CollectionReference<Map<String, dynamic>> get _ref => _firestore
      .collection(FirestoreCollections.users)
      .doc(_userId)
      .collection(FirestoreCollections.notes);

  @override
  Future<List<NoteModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => NoteModel.fromJson(e.data())).toList();
  }

  @override
  Future<List<NoteModel>> getByPlanId(String planId) async {
    final snapshot = await _ref.where('plan_id', isEqualTo: planId).get();

    return snapshot.docs.map((e) => NoteModel.fromJson(e.data())).toList();
  }

  @override
  Future<void> upsert(NoteModel note) async {
    await _ref.doc(note.uid).set(note.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> softDelete(String uid) async {
    await _ref.doc(uid).update({'deleted_at': Timestamp.now()});
  }
}
