// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    _SettingsModel(
      theme: $enumDecodeNullable(_$ColorThemeEnumMap, json['theme']) ??
          ColorTheme.dark,
      projectsPath: json['projects_path'] as String?,
      projectName: json['project_name'] as String?,
      function:
          $enumDecodeNullable(_$FifeLabFunctionEnumMap, json['function']) ??
              FifeLabFunction.general,
    );

Map<String, dynamic> _$SettingsModelToJson(_SettingsModel instance) =>
    <String, dynamic>{
      'theme': _$ColorThemeEnumMap[instance.theme]!,
      if (instance.projectsPath case final value?) 'projects_path': value,
      if (instance.projectName case final value?) 'project_name': value,
      'function': _$FifeLabFunctionEnumMap[instance.function]!,
    };

const _$ColorThemeEnumMap = {
  ColorTheme.dark: 'dark',
  ColorTheme.light: 'light',
};

const _$FifeLabFunctionEnumMap = {
  FifeLabFunction.general: 'general',
  FifeLabFunction.convexHull: 'convexHull',
};
