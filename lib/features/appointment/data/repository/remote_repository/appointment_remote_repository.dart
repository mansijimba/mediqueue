import 'package:dartz/dartz.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/appointment/data/data_source/appointment_data_source.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';
import 'package:mediqueue/features/appointment/domain/repository/appointment_repository.dart';

class AppointmentRemoteRepository implements IAppointmentRepository {
  final IAppointmentDataSource _appointmentRemoteDataSource;

  AppointmentRemoteRepository({required IAppointmentDataSource appointmentRemoteDataSource})
      : _appointmentRemoteDataSource = appointmentRemoteDataSource;

  @override
  Future<Either<Failure, AppointmentEntity>> bookAppointment({
    required String doctorId,
    required String patientId,
    required String specialty,
    required String date,
    required String time,
    required String type,
  }) async {
    try {
      final appointment = await _appointmentRemoteDataSource.bookAppointment(
        doctorId: doctorId,
        patientId: patientId,
        specialty: specialty,
        date: date,
        time: time,
        type: type,
      );
      return Right(appointment);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsByPatientId(String patientId) async {
    try {
      final appointments = await _appointmentRemoteDataSource.getAppointmentsByPatientId(patientId);
      return Right(appointments);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelAppointment(String appointmentId) async {
    try {
      final result = await _appointmentRemoteDataSource.cancelAppointment(appointmentId);
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
