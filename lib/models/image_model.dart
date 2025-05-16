import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_model.freezed.dart';
part 'image_model.g.dart';

//flutter pub run build_runner build --delete-conflicting-outputs

@freezed
abstract class ImageModel with _$ImageModel {
  const ImageModel._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory ImageModel({
    required String imageName,
    required String imagePath,
    required String imageThumbnailName,
    required String imageThumbnailPath,
  }) = _ImageModel;

  factory ImageModel.fromJson(Map<String, dynamic> json) => _$ImageModelFromJson(json);
}