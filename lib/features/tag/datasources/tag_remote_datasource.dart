import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:todoon/core/services/firebase/firebase_auth_service.dart';
import 'package:todoon/core/services/firebase/firestore_collections.dart';
import 'package:todoon/core/services/firebase/firestore_service.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/features/tag/models/tag_model.dart';

abstract class TagRemoteDataSource {
  Future<List<TagModel>> getAll();
  Future<void> upsert(TagModel tag);
  Future<void> softDelete(String uid);
}

class TagRemoteDataSourceImpl implements TagRemoteDataSource {
  final FirebaseAuthService _auth;
  final FirestoreService _firestore;

  TagRemoteDataSourceImpl(this._auth, this._firestore);

  String get _userID =>
      _auth.currentUser?.uid ?? (throw DataSource.UNAUTHORISED.getFailure());

  CollectionReference<Map<String, dynamic>> get _ref => _firestore
      .collection(FirestoreCollections.users)
      .doc(_userID)
      .collection(FirestoreCollections.tags);

  @override
  Future<List<TagModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => TagModel.fromJson(e.data())).toList();
  }

  @override
  Future<void> upsert(TagModel tag) async {
    await _ref.doc(tag.uid).set(tag.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> softDelete(String tagId) async {
    await _ref.doc(tagId).update({'deleted_at': Timestamp.now()});
  }
}
