// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectSettingModel _$ProjectSettingModelFromJson(Map<String, dynamic> json) =>
    ProjectSettingModel(
      id: json['id'] as String,
      token: json['token'] as String?,
      themeMode: json['themeMode'] as String?,
      isTutorialShown: json['isTutorialShown'] as bool?,
      lastBirthdayGreetingShownDate:
          json['lastBirthdayGreetingShownDate'] as String?,
    );

Map<String, dynamic> _$ProjectSettingModelToJson(
        ProjectSettingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'themeMode': instance.themeMode,
      'isTutorialShown': instance.isTutorialShown,
      'lastBirthdayGreetingShownDate': instance.lastBirthdayGreetingShownDate,
    };
