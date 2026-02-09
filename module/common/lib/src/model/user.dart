import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends INetworkModel<User> with EquatableMixin {
  const User({
    this.id,
    this.userId,
    this.title,
    this.body,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  final int? id;
  final int? userId;
  final String? title;
  final String? body;

  @override
  List<Object?> get props => [id, userId, title, body];

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return User(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  User fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }
}
