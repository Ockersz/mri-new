// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grn_items_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GrnItemsDetailsAdapter extends TypeAdapter<GrnItemsDetails> {
  @override
  final int typeId = 3;

  @override
  GrnItemsDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrnItemsDetails(
      itemId: fields[0] as int,
      itemDesc: fields[1] as String,
      qty: fields[2] as double,
      receivedQty: fields[3] as double,
      oldReceivedQty: fields[9] as double,
      unit: fields[4] as String,
      glAccountId: fields[5] as int,
      unitPrice: fields[6] as double,
      podetaId: fields[7] as int,
      unitId: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GrnItemsDetails obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.itemDesc)
      ..writeByte(2)
      ..write(obj.qty)
      ..writeByte(3)
      ..write(obj.receivedQty)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.glAccountId)
      ..writeByte(6)
      ..write(obj.unitPrice)
      ..writeByte(7)
      ..write(obj.podetaId)
      ..writeByte(8)
      ..write(obj.unitId)
      ..writeByte(9)
      ..write(obj.oldReceivedQty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrnItemsDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
