import 'package:birthday_reminder/product/utility/json_converters/product_timestamp_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'birthday_model.g.dart';

enum RelationshipType { family, friend, colleague, other }

@JsonSerializable()
class BirthdayModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String surname;
  @ProductTimestampConverter()
  final DateTime birthdayDate;
  final RelationshipType relationship;
  final String greetingMessage;
  @ProductTimestampConverter()
  final DateTime createdAt;
  @ProductTimestampConverter()
  final DateTime? updatedAt;

  const BirthdayModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.surname,
    required this.birthdayDate,
    required this.relationship,
    required this.greetingMessage,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$name $surname';

  factory BirthdayModel.fromJson(Map<String, dynamic> json) =>
      _$BirthdayModelFromJson(json);

  Map<String, dynamic> toJson() => _$BirthdayModelToJson(this);

  BirthdayModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? surname,
    DateTime? birthdayDate,
    RelationshipType? relationship,
    String? greetingMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BirthdayModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      birthdayDate: birthdayDate ?? this.birthdayDate,
      relationship: relationship ?? this.relationship,
      greetingMessage: greetingMessage ?? this.greetingMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int daysUntilBirthday() {
    final now = DateTime.now();
    final thisYearBirthday = DateTime(
      now.year,
      birthdayDate.month,
      birthdayDate.day,
    );

    if (thisYearBirthday.isBefore(DateTime(now.year, now.month, now.day))) {
      final nextYearBirthday = DateTime(
        now.year + 1,
        birthdayDate.month,
        birthdayDate.day,
      );
      return nextYearBirthday
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
    } else {
      return thisYearBirthday
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
    }
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    surname,
    birthdayDate,
    relationship,
    greetingMessage,
    createdAt,
    updatedAt,
  ];
}
