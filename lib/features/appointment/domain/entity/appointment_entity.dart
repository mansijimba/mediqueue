import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String doctorId;
  final String doctorName;
  final String patientId;
  final String specialty;
  final String date;
  final String time;
  final String type;
  final String status;

  const AppointmentEntity({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.patientId,
    required this.specialty,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        doctorId,
        doctorName,
        patientId,
        specialty,
        date,
        time,
        type,
        status,
      ];
}
