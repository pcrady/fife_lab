import 'dart:io';
import 'package:fife_lab/functions/fife_lab_function.dart';
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
    @Default(FifeLabFunction.general) FifeLabFunction function,
  }) = _SettingsModel;

  String? get projectPath {
    if (projectsPath == null || projectName == null) {
      return null;
    }
    return path.join(projectsPath!, projectName);
  }

  Directory? get projectsDir => projectsPath != null ? Directory(projectsPath!) : null;
  Directory? get projectDir => projectPath != null ? Directory(projectPath!) : null;

  Future<bool> get projectsDirExists async => await projectsDir?.exists() ?? false;
  Future<bool> get projectDirExists async => await projectDir?.exists() ?? false;

  factory SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);
}
