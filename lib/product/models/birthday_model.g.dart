// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birthday_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BirthdayModel _$BirthdayModelFromJson(Map<String, dynamic> json) =>
    BirthdayModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      birthdayDate: _$JsonConverterFromJson<Object, DateTime>(
          json['birthdayDate'], const ProductTimestampConverter().fromJson),
      relationship:
          $enumDecodeNullable(_$RelationshipTypeEnumMap, json['relationship']),
      greetingMessage: json['greetingMessage'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      encryptedName: json['encryptedName'] as String?,
      encryptedSurname: json['encryptedSurname'] as String?,
      encryptedBirthdayDate: json['encryptedBirthdayDate'] as String?,
      encryptedGreetingMessage: json['encryptedGreetingMessage'] as String?,
      encryptedPhoneNumber: json['encryptedPhoneNumber'] as String?,
      createdAt: const ProductTimestampConverter()
          .fromJson(json['createdAt'] as Object),
      updatedAt: _$JsonConverterFromJson<Object, DateTime>(
          json['updatedAt'], const ProductTimestampConverter().fromJson),
    );

Map<String, dynamic> _$BirthdayModelToJson(BirthdayModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'surname': instance.surname,
      'birthdayDate': _$JsonConverterToJson<Object, DateTime>(
          instance.birthdayDate, const ProductTimestampConverter().toJson),
      'relationship': _$RelationshipTypeEnumMap[instance.relationship],
      'greetingMessage': instance.greetingMessage,
      'phoneNumber': instance.phoneNumber,
      'encryptedName': instance.encryptedName,
      'encryptedSurname': instance.encryptedSurname,
      'encryptedBirthdayDate': instance.encryptedBirthdayDate,
      'encryptedGreetingMessage': instance.encryptedGreetingMessage,
      'encryptedPhoneNumber': instance.encryptedPhoneNumber,
      'createdAt': const ProductTimestampConverter().toJson(instance.createdAt),
      'updatedAt': _$JsonConverterToJson<Object, DateTime>(
          instance.updatedAt, const ProductTimestampConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$RelationshipTypeEnumMap = {
  RelationshipType.family: 'family',
  RelationshipType.friend: 'friend',
  RelationshipType.colleague: 'colleague',
  RelationshipType.other: 'other',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
