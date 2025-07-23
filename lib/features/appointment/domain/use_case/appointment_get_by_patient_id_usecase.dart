import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediqueue/app/use_case/usecase.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';
import 'package:mediqueue/features/appointment/domain/repository/appointment_repository.dart';

class GetUserAppointmentsParams extends Equatable {
  final String patientId;

  const GetUserAppointmentsParams(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

class GetUserAppointmentsUseCase
    implements UsecaseWithParams<List<AppointmentEntity>, GetUserAppointmentsParams> {
  final IAppointmentRepository _appointmentRepository;

  GetUserAppointmentsUseCase({required IAppointmentRepository appointmentRepository})
      : _appointmentRepository = appointmentRepository;

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(GetUserAppointmentsParams params) {
    return _appointmentRepository.getAppointmentsByPatientId(params.patientId);
  }
}
