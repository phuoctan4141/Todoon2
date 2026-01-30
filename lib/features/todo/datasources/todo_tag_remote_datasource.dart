import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoon/core/services/firebase/firebase_auth_service.dart';
import 'package:todoon/core/services/firebase/firestore_collections.dart';
import 'package:todoon/core/services/firebase/firestore_service.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/features/todo/models/todo_tag_model.dart';

abstract class TodoTagRemoteDataSource {
  Future<List<TodoTagModel>> getAll();
  Future<List<String>> getTagIdsByTodoList(String todoListId);

  Future<void> addTagToTodoList({
    required String todoListId,
    required String tagId,
  });

  Future<void> removeTagFromTodoList({
    required String todoListId,
    required String tagId,
  });
}

class TodoTagRemoteDataSourceImpl implements TodoTagRemoteDataSource {
  final FirebaseAuthService _auth;
  final FirestoreService _firestore;

  TodoTagRemoteDataSourceImpl(this._auth, this._firestore);

  String get _userID =>
      _auth.currentUser?.uid ?? (throw DataSource.UNAUTHORISED.getFailure());

  CollectionReference<Map<String, dynamic>> get _ref => _firestore
      .collection(FirestoreCollections.users)
      .doc(_userID)
      .collection(FirestoreCollections.todoTags);

  String _docId(String todoListId, String tagId) => '${todoListId}_$tagId';

  @override
  Future<List<TodoTagModel>> getAll() async {
    final snapshot = await _ref.get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return TodoTagModel(
        todoListId: data['todo_list_id'].toString(),
        tagId: data['tag_id'].toString(),
      );
    }).toList();
  }

  @override
  Future<List<String>> getTagIdsByTodoList(String todoListId) async {
    final snapshot = await _ref
        .where('todo_list_id', isEqualTo: todoListId)
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) => doc.data()['tag_id'].toString()).toList();
  }

  @override
  Future<void> addTagToTodoList({
    required String todoListId,
    required String tagId,
  }) async {
    await _ref.doc(_docId(todoListId, tagId)).set({
      'todo_list_id': todoListId,
      'tag_id': tagId,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> removeTagFromTodoList({
    required String todoListId,
    required String tagId,
  }) async {
    await _ref.doc(_docId(todoListId, tagId)).delete();
  }
}
