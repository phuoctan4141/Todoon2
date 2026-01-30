// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_tag_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoTagModelAdapter extends TypeAdapter<TodoTagModel> {
  @override
  final int typeId = 5;

  @override
  TodoTagModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoTagModel(
      todoListId: fields[0] as String,
      tagId: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TodoTagModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.todoListId)
      ..writeByte(1)
      ..write(obj.tagId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoTagModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
