import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

@immutable
class PlanEntity extends Equatable {
  final String id;
  final String title;
  final int position;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? syncedAt;

  const PlanEntity({
    required this.id,
    required this.title,
    required this.position,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.syncedAt,
  });

  PlanEntity copyWith({
    String? id,
    String? title,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return PlanEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  factory PlanEntity.create({required String title, required int position}) {
    return PlanEntity(
      id: Uuid().v4(),
      title: title,
      position: position,
      createdAt: DateTime.now(),
      updatedAt: null,
      deletedAt: null,
      syncedAt: null,
    );
  }

  PlanEntity markAsUpdated() {
    return copyWith(updatedAt: DateTime.now());
  }

  PlanEntity markAsSynced() {
    return copyWith(syncedAt: DateTime.now());
  }

  PlanEntity markAsDeleted() {
    return copyWith(deletedAt: DateTime.now());
  }

  bool get isDeleted => deletedAt != null;
  bool get isSynced => syncedAt != null;
  bool get needsSync =>
      updatedAt != null && (syncedAt == null || updatedAt!.isAfter(syncedAt!));

  static PlanEntity empty = PlanEntity(
    id: '',
    title: '',
    position: 0,
    createdAt: DateTime(0),
  );

  @override
  List<Object?> get props => [
    id,
    title,
    position,
    createdAt,
    updatedAt,
    deletedAt,
    syncedAt,
  ];
}
