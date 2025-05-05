// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsModel {
  ColorTheme get theme;
  String? get projectsPath;
  String? get projectName;
  FifeLabFunction get function;

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SettingsModelCopyWith<SettingsModel> get copyWith =>
      _$SettingsModelCopyWithImpl<SettingsModel>(
          this as SettingsModel, _$identity);

  /// Serializes this SettingsModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SettingsModel &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.projectsPath, projectsPath) ||
                other.projectsPath == projectsPath) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.function, function) ||
                other.function == function));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, theme, projectsPath, projectName, function);

  @override
  String toString() {
    return 'SettingsModel(theme: $theme, projectsPath: $projectsPath, projectName: $projectName, function: $function)';
  }
}

/// @nodoc
abstract mixin class $SettingsModelCopyWith<$Res> {
  factory $SettingsModelCopyWith(
          SettingsModel value, $Res Function(SettingsModel) _then) =
      _$SettingsModelCopyWithImpl;
  @useResult
  $Res call(
      {ColorTheme theme,
      String? projectsPath,
      String? projectName,
      FifeLabFunction function});
}

/// @nodoc
class _$SettingsModelCopyWithImpl<$Res>
    implements $SettingsModelCopyWith<$Res> {
  _$SettingsModelCopyWithImpl(this._self, this._then);

  final SettingsModel _self;
  final $Res Function(SettingsModel) _then;

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? projectsPath = freezed,
    Object? projectName = freezed,
    Object? function = null,
  }) {
    return _then(_self.copyWith(
      theme: null == theme
          ? _self.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ColorTheme,
      projectsPath: freezed == projectsPath
          ? _self.projectsPath
          : projectsPath // ignore: cast_nullable_to_non_nullable
              as String?,
      projectName: freezed == projectName
          ? _self.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String?,
      function: null == function
          ? _self.function
          : function // ignore: cast_nullable_to_non_nullable
              as FifeLabFunction,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _SettingsModel extends SettingsModel {
  const _SettingsModel(
      {this.theme = ColorTheme.dark,
      this.projectsPath,
      this.projectName,
      this.function = FifeLabFunction.general})
      : super._();
  factory _SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  @override
  @JsonKey()
  final ColorTheme theme;
  @override
  final String? projectsPath;
  @override
  final String? projectName;
  @override
  @JsonKey()
  final FifeLabFunction function;

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SettingsModelCopyWith<_SettingsModel> get copyWith =>
      __$SettingsModelCopyWithImpl<_SettingsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SettingsModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SettingsModel &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.projectsPath, projectsPath) ||
                other.projectsPath == projectsPath) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.function, function) ||
                other.function == function));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, theme, projectsPath, projectName, function);

  @override
  String toString() {
    return 'SettingsModel(theme: $theme, projectsPath: $projectsPath, projectName: $projectName, function: $function)';
  }
}

/// @nodoc
abstract mixin class _$SettingsModelCopyWith<$Res>
    implements $SettingsModelCopyWith<$Res> {
  factory _$SettingsModelCopyWith(
          _SettingsModel value, $Res Function(_SettingsModel) _then) =
      __$SettingsModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ColorTheme theme,
      String? projectsPath,
      String? projectName,
      FifeLabFunction function});
}

/// @nodoc
class __$SettingsModelCopyWithImpl<$Res>
    implements _$SettingsModelCopyWith<$Res> {
  __$SettingsModelCopyWithImpl(this._self, this._then);

  final _SettingsModel _self;
  final $Res Function(_SettingsModel) _then;

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? theme = null,
    Object? projectsPath = freezed,
    Object? projectName = freezed,
    Object? function = null,
  }) {
    return _then(_SettingsModel(
      theme: null == theme
          ? _self.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ColorTheme,
      projectsPath: freezed == projectsPath
          ? _self.projectsPath
          : projectsPath // ignore: cast_nullable_to_non_nullable
              as String?,
      projectName: freezed == projectName
          ? _self.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String?,
      function: null == function
          ? _self.function
          : function // ignore: cast_nullable_to_non_nullable
              as FifeLabFunction,
    ));
  }
}

// dart format on
