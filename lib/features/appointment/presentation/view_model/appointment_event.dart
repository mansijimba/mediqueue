import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class BookAppointmentEvent extends AppointmentEvent {
  final String doctorId;
  final String patientId;
  final String specialty;
  final String date;
  final String time;
  final String type;

  const BookAppointmentEvent({
    required this.doctorId,
    required this.patientId,
    required this.specialty,
    required this.date,
    required this.time,
    required this.type,
  });

  @override
  List<Object?> get props => [doctorId, patientId, specialty, date, time, type];
}

class FetchAppointmentsByPatientId extends AppointmentEvent {
  final String patientId;

  const FetchAppointmentsByPatientId(this.patientId);

  @override
  List<Object?> get props => [patientId];
}


class CancelAppointmentEvent extends AppointmentEvent {
  final String appointmentId;
  final String patientId;

  const CancelAppointmentEvent({
    required this.appointmentId,
    required this.patientId,
  });

  @override
  List<Object?> get props => [appointmentId, patientId];
}

