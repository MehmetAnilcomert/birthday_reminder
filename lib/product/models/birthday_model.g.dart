// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birthday_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BirthdayModel _$BirthdayModelFromJson(Map<String, dynamic> json) =>
    BirthdayModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      birthdayDate: DateTime.parse(json['birthdayDate'] as String),
      relationship:
          $enumDecode(_$RelationshipTypeEnumMap, json['relationship']),
      greetingMessage: json['greetingMessage'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BirthdayModelToJson(BirthdayModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'surname': instance.surname,
      'birthdayDate': instance.birthdayDate.toIso8601String(),
      'relationship': _$RelationshipTypeEnumMap[instance.relationship]!,
      'greetingMessage': instance.greetingMessage,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$RelationshipTypeEnumMap = {
  RelationshipType.family: 'family',
  RelationshipType.friend: 'friend',
  RelationshipType.colleague: 'colleague',
  RelationshipType.other: 'other',
};
