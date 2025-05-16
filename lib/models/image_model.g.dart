// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImageModel _$ImageModelFromJson(Map<String, dynamic> json) => _ImageModel(
      imageName: json['image_name'] as String,
      imagePath: json['image_path'] as String,
      imageThumbnailName: json['image_thumbnail_name'] as String,
      imageThumbnailPath: json['image_thumbnail_path'] as String,
    );

Map<String, dynamic> _$ImageModelToJson(_ImageModel instance) =>
    <String, dynamic>{
      'image_name': instance.imageName,
      'image_path': instance.imagePath,
      'image_thumbnail_name': instance.imageThumbnailName,
      'image_thumbnail_path': instance.imageThumbnailPath,
    };
