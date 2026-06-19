// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoTaskModelAdapter extends TypeAdapter<TodoTaskModel> {
  @override
  final int typeId = 2;

  @override
  TodoTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoTaskModel(
      id: fields[0] as String,
      title: fields[1] as String,
      isCompleted: fields[2] as bool,
      date: fields[3] as DateTime,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      isSynced: fields[6] as bool,
      isDeleted: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TodoTaskModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.isSynced)
      ..writeByte(7)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
