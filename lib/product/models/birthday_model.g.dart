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
      birthdayDate: const ProductTimestampConverter()
          .fromJson(json['birthdayDate'] as Object),
      relationship:
          $enumDecode(_$RelationshipTypeEnumMap, json['relationship']),
      greetingMessage: json['greetingMessage'] as String,
      createdAt: const ProductTimestampConverter()
          .fromJson(json['createdAt'] as Object),
      updatedAt: _$JsonConverterFromJson<Object, DateTime>(
          json['updatedAt'], const ProductTimestampConverter().fromJson),
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$BirthdayModelToJson(BirthdayModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'surname': instance.surname,
      'birthdayDate':
          const ProductTimestampConverter().toJson(instance.birthdayDate),
      'relationship': _$RelationshipTypeEnumMap[instance.relationship]!,
      'greetingMessage': instance.greetingMessage,
      'createdAt': const ProductTimestampConverter().toJson(instance.createdAt),
      'updatedAt': _$JsonConverterToJson<Object, DateTime>(
          instance.updatedAt, const ProductTimestampConverter().toJson),
      'phoneNumber': instance.phoneNumber,
    };

const _$RelationshipTypeEnumMap = {
  RelationshipType.family: 'family',
  RelationshipType.friend: 'friend',
  RelationshipType.colleague: 'colleague',
  RelationshipType.other: 'other',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
