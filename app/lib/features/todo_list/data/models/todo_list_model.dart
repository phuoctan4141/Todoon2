class TodoListModel {
  final String id;
  final String planId;
  final String reminderId;
  final String title;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? syncedAt;

  TodoListModel({
    required this.id,
    required this.planId,
    required this.reminderId,
    required this.title,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.syncedAt,
  });
}
