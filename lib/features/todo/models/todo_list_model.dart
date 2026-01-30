import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'todo_list_model.g.dart';

@HiveType(typeId: 1)
class TodoListModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String planId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime? updatedAt;
  @HiveField(5)
  final DateTime? deletedAt;
  @HiveField(6)
  final bool isSynced;

  TodoListModel({
    required this.uid,
    required this.planId,
    required this.title,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isSynced = false,
  });

  TodoListModel copyWith({
    String? uid,
    String? planId,
    String? title,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isSynced,
  }) {
    return TodoListModel(
      uid: uid ?? this.uid,
      planId: planId ?? this.planId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'plan_id': planId,
    'title': title,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
    'is_synced': isSynced,
  };

  factory TodoListModel.fromJson(Map<String, dynamic> json) => TodoListModel(
    uid: json['uid'],
    planId: json['plan_id'],
    title: json['title'],
    createdAt: (json['created_at'] as Timestamp).toDate(),
    updatedAt: json['updated_at'] != null
        ? (json['updated_at'] as Timestamp).toDate()
        : null,
    deletedAt: json['deleted_at'] != null
        ? (json['deleted_at'] as Timestamp).toDate()
        : null,
    isSynced: json['is_synced'] ?? false,
  );

  @override
  List<Object?> get props => [uid];
}
