// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_tag_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteTagModelAdapter extends TypeAdapter<NoteTagModel> {
  @override
  final int typeId = 6;

  @override
  NoteTagModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteTagModel(
      noteId: fields[0] as String,
      tagId: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NoteTagModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.noteId)
      ..writeByte(1)
      ..write(obj.tagId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteTagModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
