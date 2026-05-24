import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/plan_entity.dart';

class PlanModel {
  String id;
  String title;
  final int position;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  DateTime? syncedAt;

  PlanModel({
    required this.id,
    required this.title,
    required this.position,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.syncedAt,
  });

  /// Entity Serialization
  factory PlanModel.fromEntity(PlanEntity entity) {
    return PlanModel(
      id: entity.id,
      title: entity.title,
      position: entity.position,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      syncedAt: entity.syncedAt,
    );
  }

  PlanEntity toEntity() {
    return PlanEntity(
      id: id,
      title: title,
      position: position,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      syncedAt: syncedAt,
    );
  }

  /// Firestore Serialization
  factory PlanModel.fromFirestore(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as String,
      title: json['title'] as String,
      position: json['position'] as int,
      createdAt: (json['created_at'] as Timestamp).toDate(),
      updatedAt: json['updated_at'] != null
          ? (json['updated_at'] as Timestamp).toDate()
          : null,
      deletedAt: json['deleted_at'] != null
          ? (json['deleted_at'] as Timestamp).toDate()
          : null,
      syncedAt: json['synced_at'] != null
          ? (json['synced_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'position': position,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'deleted_at': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
      'synced_at': syncedAt != null ? Timestamp.fromDate(syncedAt!) : null,
    };
  }

  /// Json Serialization
  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as String,
      title: json['title'] as String,
      position: json['position'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      syncedAt: json['synced_at'] != null
          ? DateTime.parse(json['synced_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'position': position,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
    };
  }
}
