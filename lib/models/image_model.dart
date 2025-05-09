import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_model.freezed.dart';
part 'image_model.g.dart';

@freezed
abstract class ImageModel with _$ImageModel {
  const ImageModel._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory ImageModel({
    required String imageName,
  }) = _ImageModel;


  factory ImageModel.fromJson(Map<String, dynamic> json) => _$ImageModelFromJson(json);
}