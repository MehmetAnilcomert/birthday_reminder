import 'package:birthday_reminder/product/utility/json_converters/product_timestamp_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? fcmToken;
  @ProductTimestampConverter()
  final DateTime? birthday;
  @ProductTimestampConverter()
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.fcmToken,
    this.birthday,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? fcmToken,
    DateTime? birthday,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
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
    displayName,
    fcmToken,
    birthday,
    createdAt,
  ];
}
