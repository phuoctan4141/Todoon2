class NoteModel {
  final String id;
  final String planId;
  final String reminderId;
  final String content;
  final String color;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? syncedAt;

  NoteModel({
    required this.id,
    required this.planId,
    required this.reminderId,
    required this.content,
    this.color = '',
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.syncedAt,
  });
}
