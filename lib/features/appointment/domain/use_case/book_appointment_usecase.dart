import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediqueue/app/use_case/usecase.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';
import 'package:mediqueue/features/appointment/domain/repository/appointment_repository.dart';

class AppointmentBookParams extends Equatable {
  final String doctorId;
  final String patientId;
  final String specialty;
  final String date;
  final String time;
  final String type;

  const AppointmentBookParams({
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

class AppointmentBookUseCase
    implements UsecaseWithParams<AppointmentEntity, AppointmentBookParams> {
  final IAppointmentRepository _appointmentRepository;

  AppointmentBookUseCase({required IAppointmentRepository appointmentRepository})
      : _appointmentRepository = appointmentRepository;

  @override
  Future<Either<Failure, AppointmentEntity>> call(AppointmentBookParams params) {
    return _appointmentRepository.bookAppointment(
      doctorId: params.doctorId,
      patientId: params.patientId,
      specialty: params.specialty,
      date: params.date,
      time: params.time,
      type: params.type,
    );
  }
}
