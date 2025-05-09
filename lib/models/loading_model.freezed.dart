// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loading_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoadingModel {
  bool get loading;
  double? get loadingValue;
  double? get loadingTotal;

  /// Create a copy of LoadingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoadingModelCopyWith<LoadingModel> get copyWith =>
      _$LoadingModelCopyWithImpl<LoadingModel>(
          this as LoadingModel, _$identity);

  /// Serializes this LoadingModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoadingModel &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.loadingValue, loadingValue) ||
                other.loadingValue == loadingValue) &&
            (identical(other.loadingTotal, loadingTotal) ||
                other.loadingTotal == loadingTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, loading, loadingValue, loadingTotal);

  @override
  String toString() {
    return 'LoadingModel(loading: $loading, loadingValue: $loadingValue, loadingTotal: $loadingTotal)';
  }
}

/// @nodoc
abstract mixin class $LoadingModelCopyWith<$Res> {
  factory $LoadingModelCopyWith(
          LoadingModel value, $Res Function(LoadingModel) _then) =
      _$LoadingModelCopyWithImpl;
  @useResult
  $Res call({bool loading, double? loadingValue, double? loadingTotal});
}

/// @nodoc
class _$LoadingModelCopyWithImpl<$Res> implements $LoadingModelCopyWith<$Res> {
  _$LoadingModelCopyWithImpl(this._self, this._then);

  final LoadingModel _self;
  final $Res Function(LoadingModel) _then;

  /// Create a copy of LoadingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? loadingValue = freezed,
    Object? loadingTotal = freezed,
  }) {
    return _then(_self.copyWith(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingValue: freezed == loadingValue
          ? _self.loadingValue
          : loadingValue // ignore: cast_nullable_to_non_nullable
              as double?,
      loadingTotal: freezed == loadingTotal
          ? _self.loadingTotal
          : loadingTotal // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _LoadingModel extends LoadingModel {
  const _LoadingModel(
      {this.loading = false, this.loadingValue, this.loadingTotal})
      : super._();
  factory _LoadingModel.fromJson(Map<String, dynamic> json) =>
      _$LoadingModelFromJson(json);

  @override
  @JsonKey()
  final bool loading;
  @override
  final double? loadingValue;
  @override
  final double? loadingTotal;

  /// Create a copy of LoadingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoadingModelCopyWith<_LoadingModel> get copyWith =>
      __$LoadingModelCopyWithImpl<_LoadingModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LoadingModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoadingModel &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.loadingValue, loadingValue) ||
                other.loadingValue == loadingValue) &&
            (identical(other.loadingTotal, loadingTotal) ||
                other.loadingTotal == loadingTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, loading, loadingValue, loadingTotal);

  @override
  String toString() {
    return 'LoadingModel(loading: $loading, loadingValue: $loadingValue, loadingTotal: $loadingTotal)';
  }
}

/// @nodoc
abstract mixin class _$LoadingModelCopyWith<$Res>
    implements $LoadingModelCopyWith<$Res> {
  factory _$LoadingModelCopyWith(
          _LoadingModel value, $Res Function(_LoadingModel) _then) =
      __$LoadingModelCopyWithImpl;
  @override
  @useResult
  $Res call({bool loading, double? loadingValue, double? loadingTotal});
}

/// @nodoc
class __$LoadingModelCopyWithImpl<$Res>
    implements _$LoadingModelCopyWith<$Res> {
  __$LoadingModelCopyWithImpl(this._self, this._then);

  final _LoadingModel _self;
  final $Res Function(_LoadingModel) _then;

  /// Create a copy of LoadingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? loading = null,
    Object? loadingValue = freezed,
    Object? loadingTotal = freezed,
  }) {
    return _then(_LoadingModel(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingValue: freezed == loadingValue
          ? _self.loadingValue
          : loadingValue // ignore: cast_nullable_to_non_nullable
              as double?,
      loadingTotal: freezed == loadingTotal
          ? _self.loadingTotal
          : loadingTotal // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

// dart format on
