// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      fcmToken: json['fcmToken'] as String?,
      birthday: _$JsonConverterFromJson<Object, DateTime>(
          json['birthday'], const ProductTimestampConverter().fromJson),
      createdAt: const ProductTimestampConverter()
          .fromJson(json['createdAt'] as Object),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'fcmToken': instance.fcmToken,
      'birthday': _$JsonConverterToJson<Object, DateTime>(
          instance.birthday, const ProductTimestampConverter().toJson),
      'createdAt': const ProductTimestampConverter().toJson(instance.createdAt),
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
