// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    _SettingsModel(
      theme: $enumDecodeNullable(_$ColorThemeEnumMap, json['theme']) ??
          ColorTheme.dark,
      projectDir: json['project_dir'] as String?,
    );

Map<String, dynamic> _$SettingsModelToJson(_SettingsModel instance) =>
    <String, dynamic>{
      'theme': _$ColorThemeEnumMap[instance.theme]!,
      if (instance.projectDir case final value?) 'project_dir': value,
    };

const _$ColorThemeEnumMap = {
  ColorTheme.dark: 'dark',
  ColorTheme.light: 'light',
};
