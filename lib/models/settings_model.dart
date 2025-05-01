import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as path;
part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

enum ColorTheme {
  dark,
  light,
}

@freezed
abstract class SettingsModel with _$SettingsModel {
  const SettingsModel._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory SettingsModel({
    @Default(ColorTheme.dark) ColorTheme theme,
    String? projectsPath,
    String? projectName,
  }) = _SettingsModel;

  String? get projectPath {
    if (projectsPath == null || projectName == null) {
      return null;
    }
    return path.join(projectsPath!, projectName);
  }

  Directory? get projectsDir => projectsPath != null ? Directory(projectsPath!) : null;
  Directory? get projectDir => projectPath != null ? Directory(projectPath!) : null;

  factory SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);
}
