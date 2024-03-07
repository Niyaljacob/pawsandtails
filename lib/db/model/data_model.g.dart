// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventDetailsModelAdapter extends TypeAdapter<EventDetailsModel> {
  @override
  final int typeId = 0;

  @override
  EventDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventDetailsModel(
      showId: fields[0] as String,
      showName: fields[1] as String,
      imageUrls: (fields[2] as List).cast<String>(),
      postedOn: fields[3] as String,
      eventDetails: fields[4] as String,
      where: fields[5] as String,
      when: fields[6] as String,
      contact: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventDetailsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.showId)
      ..writeByte(1)
      ..write(obj.showName)
      ..writeByte(2)
      ..write(obj.imageUrls)
      ..writeByte(3)
      ..write(obj.postedOn)
      ..writeByte(4)
      ..write(obj.eventDetails)
      ..writeByte(5)
      ..write(obj.where)
      ..writeByte(6)
      ..write(obj.when)
      ..writeByte(7)
      ..write(obj.contact);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
