// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'responses.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddImagesResponse {
  String get status;
  int get imagesReceived;
  int get imagesAdded;
  List<String> get failedImages;

  /// Create a copy of AddImagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddImagesResponseCopyWith<AddImagesResponse> get copyWith =>
      _$AddImagesResponseCopyWithImpl<AddImagesResponse>(
          this as AddImagesResponse, _$identity);

  /// Serializes this AddImagesResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddImagesResponse &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.imagesReceived, imagesReceived) ||
                other.imagesReceived == imagesReceived) &&
            (identical(other.imagesAdded, imagesAdded) ||
                other.imagesAdded == imagesAdded) &&
            const DeepCollectionEquality()
                .equals(other.failedImages, failedImages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, imagesReceived,
      imagesAdded, const DeepCollectionEquality().hash(failedImages));

  @override
  String toString() {
    return 'AddImagesResponse(status: $status, imagesReceived: $imagesReceived, imagesAdded: $imagesAdded, failedImages: $failedImages)';
  }
}

/// @nodoc
abstract mixin class $AddImagesResponseCopyWith<$Res> {
  factory $AddImagesResponseCopyWith(
          AddImagesResponse value, $Res Function(AddImagesResponse) _then) =
      _$AddImagesResponseCopyWithImpl;
  @useResult
  $Res call(
      {String status,
      int imagesReceived,
      int imagesAdded,
      List<String> failedImages});
}

/// @nodoc
class _$AddImagesResponseCopyWithImpl<$Res>
    implements $AddImagesResponseCopyWith<$Res> {
  _$AddImagesResponseCopyWithImpl(this._self, this._then);

  final AddImagesResponse _self;
  final $Res Function(AddImagesResponse) _then;

  /// Create a copy of AddImagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? imagesReceived = null,
    Object? imagesAdded = null,
    Object? failedImages = null,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      imagesReceived: null == imagesReceived
          ? _self.imagesReceived
          : imagesReceived // ignore: cast_nullable_to_non_nullable
              as int,
      imagesAdded: null == imagesAdded
          ? _self.imagesAdded
          : imagesAdded // ignore: cast_nullable_to_non_nullable
              as int,
      failedImages: null == failedImages
          ? _self.failedImages
          : failedImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _AddImagesResponse extends AddImagesResponse {
  const _AddImagesResponse(
      {required this.status,
      required this.imagesReceived,
      required this.imagesAdded,
      required final List<String> failedImages})
      : _failedImages = failedImages,
        super._();
  factory _AddImagesResponse.fromJson(Map<String, dynamic> json) =>
      _$AddImagesResponseFromJson(json);

  @override
  final String status;
  @override
  final int imagesReceived;
  @override
  final int imagesAdded;
  final List<String> _failedImages;
  @override
  List<String> get failedImages {
    if (_failedImages is EqualUnmodifiableListView) return _failedImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedImages);
  }

  /// Create a copy of AddImagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddImagesResponseCopyWith<_AddImagesResponse> get copyWith =>
      __$AddImagesResponseCopyWithImpl<_AddImagesResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AddImagesResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddImagesResponse &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.imagesReceived, imagesReceived) ||
                other.imagesReceived == imagesReceived) &&
            (identical(other.imagesAdded, imagesAdded) ||
                other.imagesAdded == imagesAdded) &&
            const DeepCollectionEquality()
                .equals(other._failedImages, _failedImages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, imagesReceived,
      imagesAdded, const DeepCollectionEquality().hash(_failedImages));

  @override
  String toString() {
    return 'AddImagesResponse(status: $status, imagesReceived: $imagesReceived, imagesAdded: $imagesAdded, failedImages: $failedImages)';
  }
}

/// @nodoc
abstract mixin class _$AddImagesResponseCopyWith<$Res>
    implements $AddImagesResponseCopyWith<$Res> {
  factory _$AddImagesResponseCopyWith(
          _AddImagesResponse value, $Res Function(_AddImagesResponse) _then) =
      __$AddImagesResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String status,
      int imagesReceived,
      int imagesAdded,
      List<String> failedImages});
}

/// @nodoc
class __$AddImagesResponseCopyWithImpl<$Res>
    implements _$AddImagesResponseCopyWith<$Res> {
  __$AddImagesResponseCopyWithImpl(this._self, this._then);

  final _AddImagesResponse _self;
  final $Res Function(_AddImagesResponse) _then;

  /// Create a copy of AddImagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? imagesReceived = null,
    Object? imagesAdded = null,
    Object? failedImages = null,
  }) {
    return _then(_AddImagesResponse(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      imagesReceived: null == imagesReceived
          ? _self.imagesReceived
          : imagesReceived // ignore: cast_nullable_to_non_nullable
              as int,
      imagesAdded: null == imagesAdded
          ? _self.imagesAdded
          : imagesAdded // ignore: cast_nullable_to_non_nullable
              as int,
      failedImages: null == failedImages
          ? _self._failedImages
          : failedImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
