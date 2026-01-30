import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:todoon/core/extensions/tag_color_extension.dart';

part 'tag_model.g.dart';

@HiveType(typeId: 4)
class TagModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final TagColorEnum color;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime? updatedAt;

  @HiveField(5)
  final DateTime? deletedAt;

  @HiveField(6)
  final bool isSynced;

  TagModel({
    required this.uid,
    required this.name,
    required this.color,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isSynced = false,
  });

  TagModel copyWith({
    String? uid,
    String? name,
    TagColorEnum? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isSynced,
  }) {
    return TagModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'color': color.name,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
    'is_synced': isSynced,
  };

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
    uid: json['uid'],
    name: json['name'],
    color: TagColorEnum.values.firstWhere(
      (e) => e.name == json['color'],
      orElse: () => TagColorEnum.transparent,
    ),
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
