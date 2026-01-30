import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 3)
class TodoModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String listId;
  @HiveField(2)
  final String? reminderId;
  @HiveField(3)
  final String content;
  @HiveField(4)
  final bool isDone;
  @HiveField(5)
  final DateTime? dueDate;
  @HiveField(6)
  final int position;
  @HiveField(7)
  final DateTime createdAt;
  @HiveField(8)
  final DateTime? updatedAt;
  @HiveField(9)
  final DateTime? deletedAt;
  @HiveField(10)
  final bool isSynced;

  TodoModel({
    required this.uid,
    required this.listId,
    this.reminderId,
    required this.content,
    this.isDone = false,
    this.dueDate,
    required this.position,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isSynced = false,
  });

  TodoModel copyWith({
    String? uid,
    String? listId,
    String? reminderId,
    String? content,
    bool? isDone,
    DateTime? dueDate,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isSynced,
  }) {
    return TodoModel(
      uid: uid ?? this.uid,
      listId: listId ?? this.listId,
      reminderId: reminderId ?? this.reminderId,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'list_id': listId,
    'reminder_id': reminderId,
    'content': content,
    'is_done': isDone,
    'due_date': dueDate,
    'position': position,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
    'is_synced': isSynced,
  };

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
    uid: json['uid'],
    listId: json['list_id'],
    reminderId: json['reminder_id'],
    content: json['content'],
    isDone: json['is_done'] ?? false,
    dueDate: json['due_date'] != null
        ? (json['due_date'] as Timestamp).toDate()
        : null,
    position: json['position'],
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
