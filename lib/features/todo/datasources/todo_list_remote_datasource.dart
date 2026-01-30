// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoon/core/services/firebase/firebase_auth_service.dart';
import 'package:todoon/core/services/firebase/firestore_collections.dart';
import 'package:todoon/core/services/firebase/firestore_service.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/features/todo/models/todo_list_model.dart';

abstract class TodoListRemoteDataSource {
  Future<List<TodoListModel>> getAll();
  Future<List<TodoListModel>> getByPlanId(String planId);
  Future<void> upsert(TodoListModel todoList);
  Future<void> softDelete(String uid);
}

class TodoListRemoteDataSourceImpl implements TodoListRemoteDataSource {
  final FirebaseAuthService _auth;
  final FirestoreService _firestore;

  TodoListRemoteDataSourceImpl(this._auth, this._firestore);

  String get _userID =>
      _auth.currentUser?.uid ?? (throw DataSource.UNAUTHORISED.getFailure());

  CollectionReference<Map<String, dynamic>> get _ref => _firestore
      .collection(FirestoreCollections.users)
      .doc(_userID)
      .collection(FirestoreCollections.todoLists);

  @override
  Future<List<TodoListModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => TodoListModel.fromJson(e.data())).toList();
  }

  @override
  Future<List<TodoListModel>> getByPlanId(String planId) async {
    final snapshot = await _ref.where('plan_id', isEqualTo: planId).get();

    return snapshot.docs.map((e) => TodoListModel.fromJson(e.data())).toList();
  }

  @override
  Future<void> upsert(TodoListModel todoList) async {
    await _ref
        .doc(todoList.uid)
        .set(todoList.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> softDelete(String todoListId) async {
    await _ref.doc(todoListId).update({'deleted_at': Timestamp.now()});
  }
}
