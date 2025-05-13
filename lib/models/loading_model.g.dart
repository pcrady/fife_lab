// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loading_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoadingModel _$LoadingModelFromJson(Map<String, dynamic> json) =>
    _LoadingModel(
      loading: json['loading'] as bool? ?? false,
      loadingValue: (json['loading_value'] as num?)?.toDouble(),
      loadingTotal: (json['loading_total'] as num?)?.toDouble(),
      loadingMessage: json['loading_message'] as String?,
    );

Map<String, dynamic> _$LoadingModelToJson(_LoadingModel instance) =>
    <String, dynamic>{
      'loading': instance.loading,
      if (instance.loadingValue case final value?) 'loading_value': value,
      if (instance.loadingTotal case final value?) 'loading_total': value,
      if (instance.loadingMessage case final value?) 'loading_message': value,
    };
