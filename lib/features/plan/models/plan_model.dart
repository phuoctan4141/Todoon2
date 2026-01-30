import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:todoon/core/resources/consts.dart';

part 'plan_model.g.dart';

@HiveType(typeId: 0)
class PlanModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime? updatedAt;
  @HiveField(5)
  final DateTime? deletedAt;
  @HiveField(6)
  final bool isSynced;

  PlanModel({
    required this.uid,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isSynced = false,
  });

  PlanModel copyWith({
    String? uid,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isSynced,
  }) {
    return PlanModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  factory PlanModel.empty() {
    return PlanModel(
      uid: empty,
      title: empty,
      description: empty,
      createdAt: DateTime(0),
    );
  }

  factory PlanModel.home() {
    return PlanModel(
      uid: 'home',
      title: empty,
      description: empty,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'title': title,
    'description': description,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
    'is_synced': isSynced,
  };

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      uid: json['uid'],
      title: json['title'],
      description: json['description'],
      createdAt: (json['created_at'] as Timestamp).toDate(),
      updatedAt: json['updated_at'] != null
          ? (json['updated_at'] as Timestamp).toDate()
          : null,
      deletedAt: json['deleted_at'] != null
          ? (json['deleted_at'] as Timestamp).toDate()
          : null,
      isSynced: json['is_synced'] ?? false,
    );
  }

  @override
  List<Object?> get props => [uid];
}
