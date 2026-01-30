import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'note_tag_model.g.dart';

@HiveType(typeId: 6)
class NoteTagModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String noteId;
  @HiveField(1)
  final String tagId;

  NoteTagModel({required this.noteId, required this.tagId});

  NoteTagModel copyWith({String? noteId, String? tagId}) {
    return NoteTagModel(
      noteId: noteId ?? this.noteId,
      tagId: tagId ?? this.tagId,
    );
  }

  Map<String, dynamic> toJson() => {'note_id': noteId, 'tag_id': tagId};

  factory NoteTagModel.fromJson(Map<String, dynamic> json) =>
      NoteTagModel(noteId: json['note_id'], tagId: json['tag_id']);

  factory NoteTagModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final json = doc.data()!;
    return NoteTagModel(noteId: json['note_id'], tagId: json['tag_id']);
  }

  @override
  List<Object?> get props => [noteId, tagId];
}
