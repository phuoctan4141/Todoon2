// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class PlanModelAdapter extends TypeAdapter<PlanModel> {
  @override
  final typeId = 0;

  @override
  PlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlanModel(
      id: fields[0] as String,
      title: fields[1] as String,
      position: (fields[2] as num).toInt(),
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime?,
      deletedAt: fields[5] as DateTime?,
      syncedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PlanModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.deletedAt)
      ..writeByte(6)
      ..write(obj.syncedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TodoListModelAdapter extends TypeAdapter<TodoListModel> {
  @override
  final typeId = 1;

  @override
  TodoListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoListModel(
      id: fields[0] as String,
      planId: fields[1] as String,
      reminderId: fields[2] as String,
      title: fields[3] as String,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime?,
      deletedAt: fields[6] as DateTime?,
      syncedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TodoListModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.planId)
      ..writeByte(2)
      ..write(obj.reminderId)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.deletedAt)
      ..writeByte(7)
      ..write(obj.syncedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
