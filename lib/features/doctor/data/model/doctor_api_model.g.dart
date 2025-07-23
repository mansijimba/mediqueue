// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorApiModel _$DoctorApiModelFromJson(Map<String, dynamic> json) =>
    DoctorApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      availability: json['availability'] as String,
      appointments: (json['appointments'] as num).toInt(),
      filepath: json['filepath'] as String?,
    );

Map<String, dynamic> _$DoctorApiModelToJson(DoctorApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'specialty': instance.specialty,
      'availability': instance.availability,
      'appointments': instance.appointments,
      'filepath': instance.filepath,
    };
