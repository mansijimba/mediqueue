import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';

abstract interface class IAppointmentDataSource {
  /// Book a new appointment
  Future<AppointmentEntity> bookAppointment({
    required String doctorId,
    required String patientId,
    required String specialty,
    required String date,
    required String time,
    required String type,
  });

  /// Get appointments by patientId
  Future<List<AppointmentEntity>> getAppointmentsByPatientId(String patientId);

  /// Cancel an appointment by id
  Future<bool> cancelAppointment(String appointmentId);
}
