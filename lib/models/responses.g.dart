// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddImagesResponse _$AddImagesResponseFromJson(Map<String, dynamic> json) =>
    _AddImagesResponse(
      status: json['status'] as String,
      imagesReceived: (json['images_received'] as num).toInt(),
      imagesAdded: (json['images_added'] as num).toInt(),
      failedImages: (json['failed_images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AddImagesResponseToJson(_AddImagesResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'images_received': instance.imagesReceived,
      'images_added': instance.imagesAdded,
      'failed_images': instance.failedImages,
    };
