// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageModel {
  String get imageName;
  String get imagePath;
  String get imageThumbnailName;
  String get imageThumbnailPath;
  bool get selected;

  /// Create a copy of ImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImageModelCopyWith<ImageModel> get copyWith =>
      _$ImageModelCopyWithImpl<ImageModel>(this as ImageModel, _$identity);

  /// Serializes this ImageModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImageModel &&
            (identical(other.imageName, imageName) ||
                other.imageName == imageName) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.imageThumbnailName, imageThumbnailName) ||
                other.imageThumbnailName == imageThumbnailName) &&
            (identical(other.imageThumbnailPath, imageThumbnailPath) ||
                other.imageThumbnailPath == imageThumbnailPath) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, imageName, imagePath,
      imageThumbnailName, imageThumbnailPath, selected);

  @override
  String toString() {
    return 'ImageModel(imageName: $imageName, imagePath: $imagePath, imageThumbnailName: $imageThumbnailName, imageThumbnailPath: $imageThumbnailPath, selected: $selected)';
  }
}

/// @nodoc
abstract mixin class $ImageModelCopyWith<$Res> {
  factory $ImageModelCopyWith(
          ImageModel value, $Res Function(ImageModel) _then) =
      _$ImageModelCopyWithImpl;
  @useResult
  $Res call(
      {String imageName,
      String imagePath,
      String imageThumbnailName,
      String imageThumbnailPath,
      bool selected});
}

/// @nodoc
class _$ImageModelCopyWithImpl<$Res> implements $ImageModelCopyWith<$Res> {
  _$ImageModelCopyWithImpl(this._self, this._then);

  final ImageModel _self;
  final $Res Function(ImageModel) _then;

  /// Create a copy of ImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageName = null,
    Object? imagePath = null,
    Object? imageThumbnailName = null,
    Object? imageThumbnailPath = null,
    Object? selected = null,
  }) {
    return _then(_self.copyWith(
      imageName: null == imageName
          ? _self.imageName
          : imageName // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _self.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageThumbnailName: null == imageThumbnailName
          ? _self.imageThumbnailName
          : imageThumbnailName // ignore: cast_nullable_to_non_nullable
              as String,
      imageThumbnailPath: null == imageThumbnailPath
          ? _self.imageThumbnailPath
          : imageThumbnailPath // ignore: cast_nullable_to_non_nullable
              as String,
      selected: null == selected
          ? _self.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _ImageModel extends ImageModel {
  const _ImageModel(
      {required this.imageName,
      required this.imagePath,
      required this.imageThumbnailName,
      required this.imageThumbnailPath,
      this.selected = false})
      : super._();
  factory _ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);

  @override
  final String imageName;
  @override
  final String imagePath;
  @override
  final String imageThumbnailName;
  @override
  final String imageThumbnailPath;
  @override
  @JsonKey()
  final bool selected;

  /// Create a copy of ImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ImageModelCopyWith<_ImageModel> get copyWith =>
      __$ImageModelCopyWithImpl<_ImageModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ImageModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ImageModel &&
            (identical(other.imageName, imageName) ||
                other.imageName == imageName) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.imageThumbnailName, imageThumbnailName) ||
                other.imageThumbnailName == imageThumbnailName) &&
            (identical(other.imageThumbnailPath, imageThumbnailPath) ||
                other.imageThumbnailPath == imageThumbnailPath) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, imageName, imagePath,
      imageThumbnailName, imageThumbnailPath, selected);

  @override
  String toString() {
    return 'ImageModel(imageName: $imageName, imagePath: $imagePath, imageThumbnailName: $imageThumbnailName, imageThumbnailPath: $imageThumbnailPath, selected: $selected)';
  }
}

/// @nodoc
abstract mixin class _$ImageModelCopyWith<$Res>
    implements $ImageModelCopyWith<$Res> {
  factory _$ImageModelCopyWith(
          _ImageModel value, $Res Function(_ImageModel) _then) =
      __$ImageModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String imageName,
      String imagePath,
      String imageThumbnailName,
      String imageThumbnailPath,
      bool selected});
}

/// @nodoc
class __$ImageModelCopyWithImpl<$Res> implements _$ImageModelCopyWith<$Res> {
  __$ImageModelCopyWithImpl(this._self, this._then);

  final _ImageModel _self;
  final $Res Function(_ImageModel) _then;

  /// Create a copy of ImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? imageName = null,
    Object? imagePath = null,
    Object? imageThumbnailName = null,
    Object? imageThumbnailPath = null,
    Object? selected = null,
  }) {
    return _then(_ImageModel(
      imageName: null == imageName
          ? _self.imageName
          : imageName // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _self.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageThumbnailName: null == imageThumbnailName
          ? _self.imageThumbnailName
          : imageThumbnailName // ignore: cast_nullable_to_non_nullable
              as String,
      imageThumbnailPath: null == imageThumbnailPath
          ? _self.imageThumbnailPath
          : imageThumbnailPath // ignore: cast_nullable_to_non_nullable
              as String,
      selected: null == selected
          ? _self.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
