// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_action_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PendingActionModelAdapter extends TypeAdapter<PendingActionModel> {
  @override
  final int typeId = 20;

  @override
  PendingActionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingActionModel(
      id: fields[0] as String,
      type: fields[1] as PendingActionType,
      payload: (fields[2] as Map).cast<String, dynamic>(),
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PendingActionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.payload)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingActionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
