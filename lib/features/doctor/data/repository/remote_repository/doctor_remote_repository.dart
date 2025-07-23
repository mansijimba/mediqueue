import 'package:dartz/dartz.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/doctor/data/datasource/remote_datasource/doctor_remote_data_source.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';
import 'package:mediqueue/features/doctor/domain/repository/doctor_repository.dart';

class DoctorRemoteRepository implements IDoctorRepository {
  final DoctorRemoteDataSource _doctorRemoteDataSource;

  DoctorRemoteRepository({required DoctorRemoteDataSource doctorRemoteDataSource})
      : _doctorRemoteDataSource = doctorRemoteDataSource;

  @override
  Future<Either<Failure, List<DoctorEntity>>> getAllDoctors() async {
    try {
      final doctors = await _doctorRemoteDataSource.getAllDoctors();
      return Right(doctors);
    } catch (e) {
      
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorById(String doctorId) async {
    try {
      final doctor = await _doctorRemoteDataSource.getDoctorById(doctorId);
      return Right(doctor);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
