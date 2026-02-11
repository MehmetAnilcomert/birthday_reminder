import 'package:birthday_reminder/product/utility/json_converters/product_timestamp_converter.dart';
import 'package:birthday_reminder/product/services/encryption_service.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'birthday_model.g.dart';

enum RelationshipType { family, friend, colleague, other }

@JsonSerializable()
class BirthdayModel extends Equatable with CacheModel {
  final String id;
  final String userId;

  // Plain text fields (for backward compatibility and when not encrypted)
  final String? name;
  final String? surname;
  @ProductTimestampConverter()
  final DateTime? birthdayDate;
  final RelationshipType? relationship;
  final String? greetingMessage;
  final String? phoneNumber;

  // Encrypted fields (stored in Firestore)
  final String? encryptedName;
  final String? encryptedSurname;
  final String? encryptedBirthdayDate;
  final String? encryptedGreetingMessage;
  final String? encryptedPhoneNumber;

  @ProductTimestampConverter()
  final DateTime createdAt;
  @ProductTimestampConverter()
  final DateTime? updatedAt;

  const BirthdayModel({
    required this.id,
    required this.userId,
    this.name,
    this.surname,
    this.birthdayDate,
    this.relationship,
    this.greetingMessage,
    this.phoneNumber,
    this.encryptedName,
    this.encryptedSurname,
    this.encryptedBirthdayDate,
    this.encryptedGreetingMessage,
    this.encryptedPhoneNumber,
    required this.createdAt,
    this.updatedAt,
  });

  /// Returns true if this model contains encrypted data
  bool get isEncrypted => encryptedName != null;

  /// Returns the full name (works with both encrypted and plain data)
  String get fullName => '${name ?? ""} ${surname ?? ""}'.trim();

  factory BirthdayModel.fromJson(Map<String, dynamic> json) =>
      _$BirthdayModelFromJson(json);

  @override
  BirthdayModel fromDynamicJson(dynamic json) =>
      BirthdayModel.fromJson(json as Map<String, dynamic>);

  @override
  Map<String, dynamic> toJson() => _$BirthdayModelToJson(this);

  /// Creates a BirthdayModel from encrypted Firestore data
  static Future<BirthdayModel> fromEncrypted(
    Map<String, dynamic> json,
    EncryptionService encryptionService,
    String userId,
    String userEmail,
  ) async {
    // Decrypt the fields
    final name = json['encryptedName'] != null
        ? await encryptionService.decryptString(
            json['encryptedName'] as String,
            userId,
            userEmail,
          )
        : null;

    final surname = json['encryptedSurname'] != null
        ? await encryptionService.decryptString(
            json['encryptedSurname'] as String,
            userId,
            userEmail,
          )
        : null;

    final birthdayDateStr = json['encryptedBirthdayDate'] != null
        ? await encryptionService.decryptString(
            json['encryptedBirthdayDate'] as String,
            userId,
            userEmail,
          )
        : null;

    final greetingMessage = json['encryptedGreetingMessage'] != null
        ? await encryptionService.decryptString(
            json['encryptedGreetingMessage'] as String,
            userId,
            userEmail,
          )
        : null;

    final phoneNumber = json['encryptedPhoneNumber'] != null
        ? await encryptionService.decryptString(
            json['encryptedPhoneNumber'] as String,
            userId,
            userEmail,
          )
        : null;

    return BirthdayModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: name,
      surname: surname,
      birthdayDate: birthdayDateStr != null
          ? DateTime.parse(birthdayDateStr)
          : null,
      relationship: json['relationship'] != null
          ? RelationshipType.values.firstWhere(
              (e) => e.toString() == 'RelationshipType.${json['relationship']}',
            )
          : null,
      greetingMessage: greetingMessage,
      phoneNumber: phoneNumber,
      encryptedName: json['encryptedName'] as String?,
      encryptedSurname: json['encryptedSurname'] as String?,
      encryptedBirthdayDate: json['encryptedBirthdayDate'] as String?,
      encryptedGreetingMessage: json['encryptedGreetingMessage'] as String?,
      encryptedPhoneNumber: json['encryptedPhoneNumber'] as String?,
      createdAt: const ProductTimestampConverter().fromJson(
        json['createdAt'] as Object,
      ),
      updatedAt: json['updatedAt'] != null
          ? const ProductTimestampConverter().fromJson(
              json['updatedAt'] as Object,
            )
          : null,
    );
  }

  /// Converts this model to encrypted JSON for Firestore storage
  Future<Map<String, dynamic>> toEncryptedJson(
    EncryptionService encryptionService,
    String userId,
    String userEmail,
  ) async {
    // Encrypt the sensitive fields
    final encryptedName = name != null
        ? await encryptionService.encryptString(name!, userId, userEmail)
        : null;

    final encryptedSurname = surname != null
        ? await encryptionService.encryptString(surname!, userId, userEmail)
        : null;

    final encryptedBirthdayDate = birthdayDate != null
        ? await encryptionService.encryptString(
            birthdayDate!.toIso8601String(),
            userId,
            userEmail,
          )
        : null;

    final encryptedGreetingMessage = greetingMessage != null
        ? await encryptionService.encryptString(
            greetingMessage!,
            userId,
            userEmail,
          )
        : null;

    final encryptedPhoneNumber = phoneNumber != null
        ? await encryptionService.encryptString(
            phoneNumber!,
            userId,
            userEmail,
          )
        : null;

    return {
      'userId': userId,
      'encryptedName': encryptedName,
      'encryptedSurname': encryptedSurname,
      'encryptedBirthdayDate': encryptedBirthdayDate,
      'encryptedGreetingMessage': encryptedGreetingMessage,
      'encryptedPhoneNumber': encryptedPhoneNumber,
      'relationship': relationship?.toString().split('.').last,
      'createdAt': const ProductTimestampConverter().toJson(createdAt),
      if (updatedAt != null)
        'updatedAt': const ProductTimestampConverter().toJson(updatedAt!),
    };
  }

  BirthdayModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? surname,
    DateTime? birthdayDate,
    RelationshipType? relationship,
    String? greetingMessage,
    String? phoneNumber,
    String? encryptedName,
    String? encryptedSurname,
    String? encryptedBirthdayDate,
    String? encryptedGreetingMessage,
    String? encryptedPhoneNumber,
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
      phoneNumber: phoneNumber ?? this.phoneNumber,
      encryptedName: encryptedName ?? this.encryptedName,
      encryptedSurname: encryptedSurname ?? this.encryptedSurname,
      encryptedBirthdayDate:
          encryptedBirthdayDate ?? this.encryptedBirthdayDate,
      encryptedGreetingMessage:
          encryptedGreetingMessage ?? this.encryptedGreetingMessage,
      encryptedPhoneNumber: encryptedPhoneNumber ?? this.encryptedPhoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int daysUntilBirthday() {
    if (birthdayDate == null) return 0;

    final now = DateTime.now();
    final thisYearBirthday = DateTime(
      now.year,
      birthdayDate!.month,
      birthdayDate!.day,
    );

    if (thisYearBirthday.isBefore(DateTime(now.year, now.month, now.day))) {
      final nextYearBirthday = DateTime(
        now.year + 1,
        birthdayDate!.month,
        birthdayDate!.day,
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
    phoneNumber,
    encryptedName,
    encryptedSurname,
    encryptedBirthdayDate,
    encryptedGreetingMessage,
    encryptedPhoneNumber,
    createdAt,
    updatedAt,
  ];
}
