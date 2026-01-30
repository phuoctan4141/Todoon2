import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:todoon/core/resources/consts.dart';

part 'note_model.g.dart';

@HiveType(typeId: 2)
class NoteModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String planId;
  @HiveField(2)
  final String? reminderId;
  @HiveField(3)
  final String content;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final DateTime? updatedAt;
  @HiveField(6)
  final DateTime? deletedAt;
  @HiveField(7)
  final bool isSynced;

  NoteModel({
    required this.uid,
    required this.planId,
    this.reminderId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isSynced = false,
  });

  NoteModel copyWith({
    String? uid,
    String? planId,
    String? reminderId,
    String? content,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isSynced,
  }) {
    return NoteModel(
      uid: uid ?? this.uid,
      planId: planId ?? this.planId,
      reminderId: reminderId ?? this.reminderId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  factory NoteModel.empty() {
    return NoteModel(
      uid: empty,
      planId: empty,
      content: empty,
      createdAt: DateTime(0),
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'plan_id': planId,
    'reminder_id': reminderId,
    'content': content,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
    'is_synced': isSynced,
  };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    uid: json['uid'],
    planId: json['plan_id'],
    reminderId: json['reminder_id'],
    content: json['content'],
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
