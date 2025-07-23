import 'package:dartz/dartz.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/doctor/data/datasource/local_datasource/doctor_local_data_source.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';
import 'package:mediqueue/features/doctor/domain/repository/doctor_repository.dart';

class DoctorLocalRepository implements IDoctorRepository {
  final DoctorLocalDataSource _doctorLocalDataSource;

   DoctorLocalRepository({required DoctorLocalDataSource doctorLocalDataSource})
    : _doctorLocalDataSource = doctorLocalDataSource;

  @override
  Future<Either<Failure, List<DoctorEntity>>> getAllDoctors() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorById(String doctorId) {
    throw UnimplementedError();
  }
}
