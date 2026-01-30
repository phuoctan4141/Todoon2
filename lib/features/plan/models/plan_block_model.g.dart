// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_block_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlanBlockModelAdapter extends TypeAdapter<PlanBlockModel> {
  @override
  final int typeId = 10;

  @override
  PlanBlockModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlanBlockModel(
      uid: fields[0] as String,
      planId: fields[1] as String,
      refId: fields[2] as String,
      type: fields[3] as PlanBlockType,
      position: fields[4] as int,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime?,
      deletedAt: fields[7] as DateTime?,
      isSynced: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlanBlockModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.planId)
      ..writeByte(2)
      ..write(obj.refId)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.position)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.deletedAt)
      ..writeByte(8)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanBlockModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
