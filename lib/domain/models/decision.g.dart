// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DecisionAdapter extends TypeAdapter<Decision> {
  @override
  final int typeId = 0;

  @override
  Decision read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Decision(
      id: fields[0] as String,
      createdAt: fields[1] as DateTime,
      category: fields[2] as DecisionCategory,
      goal: fields[3] as String,
      description: fields[4] as String,
      emotionalState: fields[5] as EmotionalState,
      energyLevel: fields[6] as int,
      urgencyLevel: fields[7] as int,
      context: fields[8] as DecisionContext,
      involvesOthers: fields[9] as bool,
      expectedResult: fields[10] as String,
      actualResult: fields[11] as String?,
      resultRating: fields[12] as int?,
      resultAddedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Decision obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.goal)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.emotionalState)
      ..writeByte(6)
      ..write(obj.energyLevel)
      ..writeByte(7)
      ..write(obj.urgencyLevel)
      ..writeByte(8)
      ..write(obj.context)
      ..writeByte(9)
      ..write(obj.involvesOthers)
      ..writeByte(10)
      ..write(obj.expectedResult)
      ..writeByte(11)
      ..write(obj.actualResult)
      ..writeByte(12)
      ..write(obj.resultRating)
      ..writeByte(13)
      ..write(obj.resultAddedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecisionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DecisionCategoryAdapter extends TypeAdapter<DecisionCategory> {
  @override
  final int typeId = 1;

  @override
  DecisionCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DecisionCategory.work;
      case 1:
        return DecisionCategory.money;
      case 2:
        return DecisionCategory.relationships;
      case 3:
        return DecisionCategory.health;
      case 4:
        return DecisionCategory.other;
      default:
        return DecisionCategory.work;
    }
  }

  @override
  void write(BinaryWriter writer, DecisionCategory obj) {
    switch (obj) {
      case DecisionCategory.work:
        writer.writeByte(0);
        break;
      case DecisionCategory.money:
        writer.writeByte(1);
        break;
      case DecisionCategory.relationships:
        writer.writeByte(2);
        break;
      case DecisionCategory.health:
        writer.writeByte(3);
        break;
      case DecisionCategory.other:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecisionCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmotionalStateAdapter extends TypeAdapter<EmotionalState> {
  @override
  final int typeId = 2;

  @override
  EmotionalState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EmotionalState.calm;
      case 1:
        return EmotionalState.excited;
      case 2:
        return EmotionalState.anxious;
      case 3:
        return EmotionalState.stressed;
      case 4:
        return EmotionalState.confident;
      case 5:
        return EmotionalState.uncertain;
      default:
        return EmotionalState.calm;
    }
  }

  @override
  void write(BinaryWriter writer, EmotionalState obj) {
    switch (obj) {
      case EmotionalState.calm:
        writer.writeByte(0);
        break;
      case EmotionalState.excited:
        writer.writeByte(1);
        break;
      case EmotionalState.anxious:
        writer.writeByte(2);
        break;
      case EmotionalState.stressed:
        writer.writeByte(3);
        break;
      case EmotionalState.confident:
        writer.writeByte(4);
        break;
      case EmotionalState.uncertain:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmotionalStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DecisionContextAdapter extends TypeAdapter<DecisionContext> {
  @override
  final int typeId = 3;

  @override
  DecisionContext read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DecisionContext.home;
      case 1:
        return DecisionContext.work;
      case 2:
        return DecisionContext.commute;
      case 3:
        return DecisionContext.other;
      default:
        return DecisionContext.home;
    }
  }

  @override
  void write(BinaryWriter writer, DecisionContext obj) {
    switch (obj) {
      case DecisionContext.home:
        writer.writeByte(0);
        break;
      case DecisionContext.work:
        writer.writeByte(1);
        break;
      case DecisionContext.commute:
        writer.writeByte(2);
        break;
      case DecisionContext.other:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecisionContextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
