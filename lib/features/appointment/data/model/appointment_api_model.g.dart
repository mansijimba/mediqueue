// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentApiModel _$AppointmentApiModelFromJson(Map<String, dynamic> json) =>
    AppointmentApiModel(
      id: json['_id'] as String?,
      doctor: json['doctor'] as Map<String, dynamic>,
      patient: json['patient'] as String,
      specialty: json['specialty'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$AppointmentApiModelToJson(
        AppointmentApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'doctor': instance.doctor,
      'patient': instance.patient,
      'specialty': instance.specialty,
      'date': instance.date,
      'time': instance.time,
      'type': instance.type,
      'status': instance.status,
    };
