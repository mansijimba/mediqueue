import 'package:dartz/dartz.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';

abstract interface class IAppointmentRepository {
  /// Book a new appointment
  Future<Either<Failure, AppointmentEntity>> bookAppointment({
    required String doctorId,
    required String patientId,
    required String specialty,
    required String date,
    required String time,
    required String type,
  });

  /// Get all appointments for a patient
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsByPatientId(String patientId);

  /// Cancel an appointment
  Future<Either<Failure, bool>> cancelAppointment(String appointmentId);
}
