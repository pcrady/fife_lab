import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

enum ColorTheme {
  dark,
  light,
}

@freezed
abstract class SettingsModel with _$SettingsModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory SettingsModel({
    @Default(ColorTheme.dark) ColorTheme theme,
    String? projectDir,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);
}
