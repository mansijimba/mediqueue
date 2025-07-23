import 'package:dartz/dartz.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';

abstract interface class IDoctorRepository {
  Future<Either<Failure, List<DoctorEntity>>> getAllDoctors();

  Future<Either<Failure, DoctorEntity>> getDoctorById(String doctorId);

}