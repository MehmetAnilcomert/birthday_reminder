import 'package:birthday_reminder/product/utility/json_converters/product_timestamp_converter.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable with CacheModel {
  final String id;
  final String email;
  final String? name;
  final String? surname;
  final String? displayName;
  final String? fcmToken;
  @ProductTimestampConverter()
  final DateTime? birthday;
  @ProductTimestampConverter()
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.surname,
    this.displayName,
    this.fcmToken,
    this.birthday,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  UserModel fromDynamicJson(dynamic json) =>
      UserModel.fromJson(json as Map<String, dynamic>);

  @override
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? surname,
    String? displayName,
    String? fcmToken,
    DateTime? birthday,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      displayName: displayName ?? this.displayName,
      fcmToken: fcmToken ?? this.fcmToken,
      birthday: birthday ?? this.birthday,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    surname,
    displayName,
    fcmToken,
    birthday,
    createdAt,
  ];
}
