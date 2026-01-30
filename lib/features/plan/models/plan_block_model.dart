import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:todoon/core/resources/consts.dart';
import 'package:todoon/core/utils/functions.dart';

part 'plan_block_model.g.dart';

@HiveType(typeId: 10)
class PlanBlockModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String planId;

  @HiveField(2)
  final String refId;
  // uid NoteModel / TodoListModel

  @HiveField(3)
  final PlanBlockType type;
  // note | todoList

  @HiveField(4)
  final int position;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime? updatedAt;

  @HiveField(7)
  final DateTime? deletedAt;

  @HiveField(8)
  final bool isSynced;
  PlanBlockModel({
    required this.uid,
    required this.planId,
    required this.refId,
    required this.type,
    required this.position,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isSynced = false,
  });

  PlanBlockModel copyWith({
    String? uid,
    String? planId,
    String? refId,
    PlanBlockType? type,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isSynced,
  }) {
    return PlanBlockModel(
      uid: uid ?? this.uid,
      planId: planId ?? this.planId,
      refId: refId ?? this.refId,
      type: type ?? this.type,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  factory PlanBlockModel.empty() {
    return PlanBlockModel(
      uid: empty,
      planId: empty,
      refId: empty,
      type: PlanBlockType.note,
      position: 0,
      createdAt: DateTime(0),
      isSynced: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'plan_id': planId,
      'ref_id': refId,
      'type': type.value,
      'position': position,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'is_synced': isSynced,
    };
  }

  factory PlanBlockModel.fromJson(Map<String, dynamic> json) {
    return PlanBlockModel(
      uid: json['uid'],
      planId: json['plan_id'] as String,
      refId: json['ref_id'] as String,
      type: PlanBlockTypeX.fromValue(json['type'] as String),
      position: json['position'] as int,
      createdAt: parseDate(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? parseDate(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? parseDate(json['deleted_at'])
          : null,
      isSynced: json['is_synced'] as bool,
    );
  }

  @override
  List<Object> get props {
    return [uid, refId, type, position];
  }
}

enum PlanBlockType { note, todo_list }

extension PlanBlockTypeX on PlanBlockType {
  String get value => name;

  static PlanBlockType fromValue(String value) {
    return PlanBlockType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PlanBlockType.note,
    );
  }
}
