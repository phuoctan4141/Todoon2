import 'package:hive/hive.dart';

part 'todo_tag_model.g.dart';

@HiveType(typeId: 5)
class TodoTagModel extends HiveObject {
  @HiveField(0)
  final String todoListId;
  @HiveField(1)
  final String tagId;

  TodoTagModel({required this.todoListId, required this.tagId});

  TodoTagModel copyWith({String? todoListId, String? tagId}) {
    return TodoTagModel(
      todoListId: todoListId ?? this.todoListId,
      tagId: tagId ?? this.tagId,
    );
  }

  Map<String, dynamic> toJson() => {
    'todo_list_id': todoListId,
    'tag_id': tagId,
  };

  factory TodoTagModel.fromJson(Map<String, dynamic> json) =>
      TodoTagModel(todoListId: json['todo_list_id'], tagId: json['tag_id']);
}
