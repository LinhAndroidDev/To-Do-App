// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_work.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleWorkAdapter extends TypeAdapter<ScheduleWork> {
  @override
  final int typeId = 1;

  @override
  ScheduleWork read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleWork(
      id: fields[0] as int,
      dateTime: fields[1] as DateTime,
      works: (fields[2] as List).cast<Work>(),
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleWork obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.works);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleWorkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
