// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    _SettingsModel(
      theme: $enumDecodeNullable(_$ColorThemeEnumMap, json['theme']) ??
          ColorTheme.dark,
      projectsDirPath: json['projects_dir_path'] as String?,
      projectName: json['project_name'] as String?,
    );

Map<String, dynamic> _$SettingsModelToJson(_SettingsModel instance) =>
    <String, dynamic>{
      'theme': _$ColorThemeEnumMap[instance.theme]!,
      if (instance.projectsDirPath case final value?)
        'projects_dir_path': value,
      if (instance.projectName case final value?) 'project_name': value,
    };

const _$ColorThemeEnumMap = {
  ColorTheme.dark: 'dark',
  ColorTheme.light: 'light',
};
