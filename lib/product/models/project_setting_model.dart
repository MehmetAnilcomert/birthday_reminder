import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_setting_model.g.dart';

@JsonSerializable()
/// ProjectSettingModel is a model that represents the project`s cached settings data.
class ProjectSettingModel extends Equatable with CacheModel {
  @override
  final String id;
  final String? token;
  final String? user;
  final String? themeMode;
  final bool? isTutorialShown;
  final String? lastBirthdayGreetingShownDate;

  /// Constructor for ProjectSettingModel
  const ProjectSettingModel({
    required this.id,
    this.token,
    this.user,
    this.themeMode,
    this.isTutorialShown,
    this.lastBirthdayGreetingShownDate,
  });

  factory ProjectSettingModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectSettingModelFromJson(json);

  @override
  ProjectSettingModel fromDynamicJson(dynamic json) =>
      ProjectSettingModel.fromJson(json as Map<String, dynamic>);

  @override
  Map<String, dynamic> toJson() => _$ProjectSettingModelToJson(this);

  ProjectSettingModel copyWith({
    String? id,
    String? token,
    String? user,
    String? themeMode,
    bool? isTutorialShown,
    String? lastBirthdayGreetingShownDate,
  }) {
    return ProjectSettingModel(
      id: id ?? this.id,
      token: token ?? this.token,
      user: user ?? this.user,
      themeMode: themeMode ?? this.themeMode,
      isTutorialShown: isTutorialShown ?? this.isTutorialShown,
      lastBirthdayGreetingShownDate:
          lastBirthdayGreetingShownDate ?? this.lastBirthdayGreetingShownDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    token,
    user,
    themeMode,
    isTutorialShown,
    lastBirthdayGreetingShownDate,
  ];
}
