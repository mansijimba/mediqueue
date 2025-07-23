// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueApiModel _$QueueApiModelFromJson(Map<String, dynamic> json) =>
    QueueApiModel(
      status: json['status'] as String,
      position: (json['position'] as num).toInt(),
      totalAhead: (json['totalAhead'] as num).toInt(),
      estimatedWait: (json['estimatedWait'] as num).toInt(),
    );

Map<String, dynamic> _$QueueApiModelToJson(QueueApiModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'position': instance.position,
      'totalAhead': instance.totalAhead,
      'estimatedWait': instance.estimatedWait,
    };
