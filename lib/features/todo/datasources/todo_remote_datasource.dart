// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoon/core/services/firebase/firebase_auth_service.dart';
import 'package:todoon/core/services/firebase/firestore_collections.dart';
import 'package:todoon/core/services/firebase/firestore_service.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/features/todo/models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getAll();
  Future<List<TodoModel>> getByTodoListId(String listId);
  Future<void> upsert(TodoModel todo);
  Future<void> softDelete(String uid);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final FirebaseAuthService _auth;
  final FirestoreService _firestore;

  TodoRemoteDataSourceImpl(this._auth, this._firestore);

  String get _userID =>
      _auth.currentUser?.uid ?? (throw DataSource.UNAUTHORISED.getFailure());

  CollectionReference<Map<String, dynamic>> get _ref => _firestore
      .collection(FirestoreCollections.users)
      .doc(_userID)
      .collection(FirestoreCollections.todos);

  @override
  Future<List<TodoModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => TodoModel.fromJson(e.data())).toList();
  }

  @override
  Future<List<TodoModel>> getByTodoListId(String listId) async {
    final snapshot = await _ref.where('list_id', isEqualTo: listId).get();
    return snapshot.docs.map((e) => TodoModel.fromJson(e.data())).toList();
  }

  @override
  Future<void> upsert(TodoModel todo) async {
    await _ref.doc(todo.uid).set(todo.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> softDelete(String todoId) async {
    await _ref.doc(todoId).update({'deleted_at': Timestamp.now()});
  }
}
