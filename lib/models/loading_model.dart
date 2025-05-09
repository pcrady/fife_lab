import 'package:freezed_annotation/freezed_annotation.dart';

part 'loading_model.freezed.dart';
part 'loading_model.g.dart';

@freezed
abstract class LoadingModel with _$LoadingModel {
  const LoadingModel._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory LoadingModel({
    @Default(false) bool loading,
    double? loadingValue,
    double? loadingTotal,
  }) = _LoadingModel;

  double? get loadingProgress {
    if (!loading) return null;
    if (loadingValue == null || loadingTotal == null) return null;
    if (loadingTotal == 0) return null;
    return loadingValue! / loadingTotal!;
  }

  factory LoadingModel.fromJson(Map<String, dynamic> json) => _$LoadingModelFromJson(json);
}