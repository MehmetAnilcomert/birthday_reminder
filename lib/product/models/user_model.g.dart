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
      createdAt: const ProductTimestampConverter()
          .fromJson(json['createdAt'] as Object),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'fcmToken': instance.fcmToken,
      'createdAt': const ProductTimestampConverter().toJson(instance.createdAt),
    };
