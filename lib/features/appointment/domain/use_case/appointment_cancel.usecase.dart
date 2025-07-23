import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediqueue/app/use_case/usecase.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/appointment/domain/repository/appointment_repository.dart';

class CancelAppointmentParams extends Equatable {
  final String appointmentId;

  const CancelAppointmentParams(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class CancelAppointmentUseCase
    implements UsecaseWithParams<bool, CancelAppointmentParams> {
  final IAppointmentRepository _appointmentRepository;

  CancelAppointmentUseCase({required IAppointmentRepository appointmentRepository})
      : _appointmentRepository = appointmentRepository;

  @override
  Future<Either<Failure, bool>> call(CancelAppointmentParams params) {
    return _appointmentRepository.cancelAppointment(params.appointmentId);
  }
}
