import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';

part 'appointment_api_model.g.dart';

@JsonSerializable()
class AppointmentApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  final Map<String, dynamic> doctor;  // Changed from String to Map
  final String patient;
  final String specialty;
  final String date;
  final String time;
  final String type;
  final String status;

  const AppointmentApiModel({
    this.id,
    required this.doctor,
    required this.patient,
    required this.specialty,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
  });

  factory AppointmentApiModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentApiModelFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$AppointmentApiModelToJson(this);
    if (json['_id'] == null) {
      json.remove('_id');
    }
    return json;
  }

  // From Entity (if you ever need it)
  factory AppointmentApiModel.fromEntity(AppointmentEntity entity) {
    return AppointmentApiModel(
      id: entity.id,
      doctor: {
        '_id': entity.doctorId,
        'name': entity.doctorName,
      },
      patient: entity.patientId,
      specialty: entity.specialty,
      date: entity.date,
      time: entity.time,
      type: entity.type,
      status: entity.status,
    );
  }

  // To Entity (used by Repository)
  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id ?? '',
      doctorId: doctor['_id'] ?? '',
      doctorName: doctor['name'] ?? '',
      patientId: patient,
      specialty: specialty,
      date: date,
      time: time,
      type: type,
      status: status,
    );
  }

  @override
  List<Object?> get props =>
      [id, doctor, patient, specialty, date, time, type, status];
}
