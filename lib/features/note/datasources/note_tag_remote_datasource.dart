import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoon/core/services/firebase/firebase_auth_service.dart';
import 'package:todoon/core/services/firebase/firestore_collections.dart';
import 'package:todoon/core/services/firebase/firestore_service.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/features/note/models/note_tag_model.dart';

abstract class NoteTagRemoteDataSource {
  Future<List<NoteTagModel>> getAll();
  Future<List<String>> getTagIdsByNote(String noteId);

  Future<void> addTagToNote({required String noteId, required String tagId});

  Future<void> removeTagFromNote({
    required String noteId,
    required String tagId,
  });
}

class NoteTagRemoteDataSourceImpl implements NoteTagRemoteDataSource {
  final FirebaseAuthService _auth;
  final FirestoreService _firestore;

  NoteTagRemoteDataSourceImpl(this._auth, this._firestore);

  String get _userID =>
      _auth.currentUser?.uid ?? (throw DataSource.UNAUTHORISED.getFailure());

  CollectionReference<Map<String, dynamic>> get _ref => _firestore
      .collection(FirestoreCollections.users)
      .doc(_userID)
      .collection(FirestoreCollections.noteTags);

  String _docId(String noteId, String tagId) => '${noteId}_$tagId';

  @override
  Future<List<NoteTagModel>> getAll() async {
    final snapshot = await _ref.get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return NoteTagModel(
        noteId: data['note_id'].toString(),
        tagId: data['tag_id'].toString(),
      );
    }).toList();
  }

  @override
  Future<List<String>> getTagIdsByNote(String noteId) async {
    final snapshot = await _ref.where('note_id', isEqualTo: noteId).get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) => doc.data()['tag_id'].toString()).toList();
  }

  @override
  Future<void> addTagToNote({
    required String noteId,
    required String tagId,
  }) async {
    await _ref.doc(_docId(noteId, tagId)).set({
      'note_id': noteId,
      'tag_id': tagId,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> removeTagFromNote({
    required String noteId,
    required String tagId,
  }) async {
    await _ref.doc(_docId(noteId, tagId)).delete();
  }
}
