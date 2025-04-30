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
    String? projectsDirPath,
    String? projectName,
  }) = _SettingsModel;

  Directory? get currentProjectDir {
    if (projectsDirPath == null || projectName == null) {
      return null;
    }
    final projectPath = path.join(projectsDirPath!, projectName);
    return Directory(projectPath);
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);
}
