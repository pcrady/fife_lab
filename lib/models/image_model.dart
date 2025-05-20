import 'dart:io';

import 'package:flutter/material.dart';
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
    @Default(false) bool selected,
  }) = _ImageModel;

  FileImage get image => FileImage(File(imagePath));
  FileImage get imageThumbnail => FileImage(File(imageThumbnailPath));

  factory ImageModel.fromJson(Map<String, dynamic> json) => _$ImageModelFromJson(json);
}