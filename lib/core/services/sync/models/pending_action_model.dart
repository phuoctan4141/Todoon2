import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:todoon/core/services/sync/models/pending_action_type.dart';

part 'pending_action_model.g.dart';

@HiveType(typeId: 20)
class PendingActionModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final PendingActionType type;

  @HiveField(2)
  final Map<String, dynamic> payload;

  @HiveField(3)
  final DateTime createdAt;

  PendingActionModel({
    required this.id,
    required this.type,
    required this.payload,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
