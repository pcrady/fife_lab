import 'package:freezed_annotation/freezed_annotation.dart';

part 'responses.freezed.dart';
part 'responses.g.dart';

@freezed
abstract class AddImagesResponse with _$AddImagesResponse {
  const AddImagesResponse._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory AddImagesResponse({
    required String status,
    required int imagesReceived,
    required int imagesAdded,
    required List<String> failedImages,
  }) = _AddImagesResponse;

  factory AddImagesResponse.fromJson(Map<String, dynamic> json) => _$AddImagesResponseFromJson(json);
}
